import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_diary/app/module/account/controller/credit_card_account_controller.dart';
import 'package:money_diary/app/module/account/view/date_picker_popup.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AddCreditAccountScreen extends GetView<CreditCardAccountController> {
  final ImagePicker _picker = ImagePicker();

  AddCreditAccountScreen({super.key});

  /// 📷 Pick image from camera or gallery and store it in app directory
  Future<void> _pickImage(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) async {
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
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
                      leading: Icon(
                        Icons.photo_camera,
                        color: colorScheme.primary,
                      ),
                      title: const Text('Take a Photo'),
                      onTap: () => Navigator.pop(context, 'camera'),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        color: colorScheme.primary,
                      ),
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
      final savedImage = await File(
        pickedFile.path,
      ).copy('${appDir.path}/$fileName');

      controller.selectedImage.value = savedImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Add Credit Card"), centerTitle: true),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 🔹 Progress indicator
              Row(
                children: List.generate(3, (index) {
                  final isActive = index == controller.currentStep.value;
                  final isCompleted = index < controller.currentStep.value;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? colorScheme.primary
                            : isActive
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              _buildStep(context, colorScheme, textTheme),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStep(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    switch (controller.currentStep.value) {
      case 0:
        return _buildStep1(context, colorScheme, textTheme);
      case 1:
        return _buildStep2(context, colorScheme, textTheme);
      case 2:
        return _buildStep3(context, colorScheme, textTheme);
      default:
        return const SizedBox.shrink();
    }
  }

  // 🧾 Step 1
  Widget _buildStep1(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
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
                          'assets/icons/credit.png',
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
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 24),

        // 🏷️ Account Name
        _textField(
          controller.accountNameController,
          "Account Name",
          textTheme,
          colorScheme,
        ),
        const SizedBox(height: 20),

        // 🔢 Account Number
        _textField(
          controller.accountNumberController,
          "Account Number",
          textTheme,
          colorScheme,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),

        // 💳 Credit Limit
        _textField(
          controller.creditLimitController,
          "Credit Limit",
          textTheme,
          colorScheme,
          prefixText: "₹ ",
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        _buildStepButtons(textTheme, colorScheme, nextOnly: true),
      ],
    );
  }

  // 💰 Step 2
  Widget _buildStep2(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        _textField(
          controller.outstandingAmountController,
          "Outstanding Amount",
          textTheme,
          colorScheme,
          prefixText: "₹ ",
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _textField(
          controller.billGenerationDateDisplayController,
          "Bill Generation Date",
          textTheme,
          colorScheme,
          keyboardType: TextInputType.none,
          onTap: () async {
            var day = await DatePickerPopup.pickDate(context, 'Select Bill Generation Date');
           if(day != null) {
             controller.billGeneration.value = day;
             controller.billGenerationDateDisplayController.text = "$day of every month";
           }
          }
        ),
        const SizedBox(height: 20),
        _textField(
          controller.billDueDateDisplayController,
          "Bill Due Date",
          textTheme,
          colorScheme,
            keyboardType: TextInputType.none,
            onTap: () async {
             var day = await DatePickerPopup.pickDate(context, 'Select Bill Due Date');
              if(day != null) {
                controller.billDueDateDisplayController.text = "$day of every month";
                controller.billDueDate.value = day;
              }
            }
        ),
        const SizedBox(height: 24),
        _buildStepButtons(textTheme, colorScheme),
      ],
    );
  }

  // ⚙️ Step 3
  // ⚙️ Step 3
  Widget _buildStep3(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        // ✅ Include in Net Worth
        Obx(
          () => Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Include balance of this account\ninto overall balance or net worth",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 15,
                        height: 1.3
                      ),
                    ),
                  ),
                  Switch(
                    value: controller.includeInNetWorth.value,
                    onChanged: (v) => controller.includeInNetWorth.value = v,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 💳 Card Utilization Ratio
        Obx(
          () => Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Card Utilization Ratio",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                        fontSize: 15,
                      height: 1.3
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: controller.cardUtilization.value,
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: "${controller.cardUtilization.value.toInt()}%",
                          onChanged: (v) =>
                              controller.cardUtilization.value = v,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          "${controller.cardUtilization.value.toInt()}%",
                          style: textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        Obx(
          () => Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Alert me when usage go beyond credit utilization ratio.",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                          fontSize: 15,
                        height: 1.3
                      ),
                    ),
                  ),
                  Switch(
                    value: controller.utilizationAlert.value,
                    onChanged: (v) => controller.utilizationAlert.value = v,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 🔔 Generate Bill Reminder
        Obx(
          () => Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Generate Bill Reminder",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                          fontSize: 15,
                        height: 1.3
                      ),
                    ),
                  ),
                  Switch(
                    value: controller.generateBillReminder.value,
                    onChanged: (v) => controller.generateBillReminder.value = v,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // 💾 Save Account
        _buildStepButtons(textTheme, colorScheme, save: true),
      ],
    );
  }

  // 📍 Reusable TextField
  Widget _textField(
    TextEditingController controller,
    String label,
    TextTheme textTheme,
    ColorScheme colorScheme, {
    String? prefixText,
    TextInputType? keyboardType, VoidCallback? onTap
  }) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.start,
      keyboardType: keyboardType,
      style: textTheme.titleMedium,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }

  // 🔘 Navigation Buttons
  Widget _buildStepButtons(
    TextTheme textTheme,
    ColorScheme colorScheme, {
    bool nextOnly = false,
    bool save = false,
  }) {
    return Row(
      children: [
        if (!nextOnly)
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                controller.previousStep();
              }, // TODO: implement save
              child: Text(
                "Previous",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (!nextOnly) const SizedBox(width: 12),
        if (!save)
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                controller.nextStep();
              }, // TODO: implement save
              child: Text(
                "Next",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        else
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                //controller.nextStep();
              }, // TODO: implement save
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
    );
  }
}
