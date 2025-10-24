import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_diary/app/module/account/controller/bank_account_controller.dart';
import 'package:money_diary/app/module/account/controller/line_of_credit_account_controller.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AddLineOfCreditAccountScreen extends GetView<LineOfCreditAccountController> {
  final ImagePicker _picker = ImagePicker();

  AddLineOfCreditAccountScreen({super.key});

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
                      leading:
                      Icon(Icons.photo_library, color: colorScheme.primary),
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

    final pickedFile = await _picker.pickImage(
      source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(pickedFile.path)}';
      final savedImage =
      await File(pickedFile.path).copy('${appDir.path}/$fileName');

      controller.selectedImage.value = savedImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Add Line of Credit Account"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🏦 Image Picker
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
                        'assets/icons/bank.png',
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

            // 🏷️ Account Name
            TextFormField(
              controller: controller.accountNameController,
              textAlign: TextAlign.start,
              style: textTheme.titleMedium,
              decoration: InputDecoration(
                labelText: "Account Name",
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

            // 🔢 Account Number
            TextFormField(
              controller: controller.accountNumberController,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              style: textTheme.titleMedium,
              decoration: InputDecoration(
                labelText: "Account Number",
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

            // 💰 Initial Balance
            TextFormField(
              controller: controller.startingDueAmountController,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              style: textTheme.titleMedium,
              decoration: InputDecoration(
                labelText: "Initial Due Amount",
                prefixText: "₹ ",
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

            TextFormField(
              controller: controller.startingDueAmountController,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              style: textTheme.titleMedium,
              decoration: InputDecoration(
                labelText: "Credit Limit",
                prefixText: "₹ ",
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

            // 🧮 Toggle for including in net worth
            Obx(() => Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Include balance of this account\ninto overall balance or net worth",
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.3,
                          fontSize: 15
                        ),
                      ),
                    ),
                    Switch(
                      value: controller.includeInNetWorth.value,
                      onChanged: (value) =>
                      controller.includeInNetWorth.value = value,
                    ),
                  ],
                ),
              ),
            )),

            const SizedBox(height: 24),

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
                onPressed: () {}, // TODO: implement save
                child: Text(
                  "Save Account",
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
