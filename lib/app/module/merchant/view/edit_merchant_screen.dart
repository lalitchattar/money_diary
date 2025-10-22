import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_diary/app/data/model/merchant_model.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../../custom/widget/validation_message_screen.dart';
import '../controller/merchant_controller.dart';

class EditMerchantScreen extends GetView<MerchantController> {

  final Merchant merchant = Get.arguments;
  final TextEditingController merchantNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  EditMerchantScreen({super.key});

  void _initializeController() {
    controller.name.value = merchant.name;
    controller.type.value = merchant.type;

    if (merchant.icon != null && merchant.icon!.startsWith('/data')) {
      // Local file from gallery/camera
      controller.selectedImage.value = File(merchant.icon!);
    } else {
      // Asset image or null → let UI show default
      controller.selectedImage.value = null;
    }

    // Pre-fill text controller
    merchantNameController.text = merchant.name;
  }

  /// 📷 Pick image from camera or gallery and store it in app directory
  Future<void> _pickImage(
      BuildContext context, TextTheme textTheme, ColorScheme colorScheme) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Choose an Image',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CLOSE'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.photo_camera, color: colorScheme.primary),
                      title: const Text('Take a Photo'),
                      onTap: () => Navigator.pop(context, 'camera'),
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_library, color: colorScheme.primary),
                      title: const Text('Choose from Gallery'),
                      onTap: () => Navigator.pop(context, 'gallery'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if (choice == null) return;

    // Pick image
    final pickedFile = await _picker.pickImage(
      source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      // Save to app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(pickedFile.path)}';
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      // Store locally in controller
      controller.selectedImage.value = savedImage;
    }
  }

  /// 💾 Validate and save merchant
  Future<void> _updateMerchant() async {
    final name = merchantNameController.text.trim();
    controller.name.value = name;
    final errors = <String>[];

    if (name.isEmpty) {
      errors.add("Merchant name is required");
    } else if (merchant.name != name && await controller.isNameExists(name, controller.type.value)) {
      errors.add("Merchant name already exists");
    }

    if (errors.isNotEmpty) {
      Get.bottomSheet(
        ValidationMessageScreen(errorMessages: errors),
        isScrollControlled: true,
        backgroundColor: Theme.of(Get.context!).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      );
      return;
    }

    await controller.updateMerchant(id: merchant.id, fieldsToUpdate: ['name', 'type', 'icon']);();
    Get.until((route) => Get.currentRoute == "/MerchantListScreen");
  }

  @override
  Widget build(BuildContext context) {
    _initializeController();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Update Merchant"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(context, textTheme, colorScheme),
              child: Obx(() {
                final file = controller.selectedImage.value;

                return Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipOval(
                      child: file != null
                          ? Image.file(
                        file,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        'assets/images/default_merchant.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: colorScheme.surface, width: 2),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 24),

            // 🔘 Segmented button for Expense / Income
            Obx(() => SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                    value: 'Expense',
                    icon: Icon(Icons.arrow_upward),
                    label: Text('Expense')),
                ButtonSegment(
                    value: 'Income',
                    icon: Icon(Icons.arrow_downward),
                    label: Text('Income')),
              ],
              selected: {controller.type.value},
              onSelectionChanged: (val) => controller.type.value = val.first,
            )),
            const SizedBox(height: 24),

            // 🏷️ Merchant name field
            TextFormField(
              controller: merchantNameController..text = merchant.name,
              textAlign: TextAlign.start,
              style: textTheme.titleMedium,
              decoration: InputDecoration(
                labelText: "Merchant Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            const SizedBox(height: 20),

            // 💾 Save button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _updateMerchant,
                child: Text(
                  "Update Merchant",
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
