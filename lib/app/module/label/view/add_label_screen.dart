import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/module/label/controller/label_controller.dart';
import 'package:money_diary/app/utils/utility.dart';

import '../../../custom/widget/validation_message_screen.dart';
import '../../../data/model/label_model.dart';

class AddLabelScreen extends GetView<LabelController> {

  AddLabelScreen({super.key});

  Future<void> _pickColor(
      BuildContext context, TextTheme textTheme, ColorScheme colorScheme) async {
    final selected = await showModalBottomSheet<Color>(
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
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Choose a Color',
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
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.colorOptions.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final color = controller.colorOptions[index];
                    final isSelected = controller.selectedColor.value ==
                        controller.colorToHex(color);
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : Colors.transparent,
                            width: isSelected ? 3 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      controller.selectedColor.value = controller.colorToHex(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Add Label"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Centered color picker circle
            GestureDetector(
              onTap: () => _pickColor(context, textTheme, colorScheme),
              child: Obx(() => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: getColorFromHex(controller.selectedColor.value) ??
                      colorScheme.surfaceVariant,
                  border: Border.all(
                    color: getColorFromHex(controller.selectedColor.value) ?? colorScheme.outlineVariant,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: getColorFromHex(controller.selectedColor.value).withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.color_lens,
                  size: 32,
                  color: Colors.white,
                ),
              )),
            ),
            const SizedBox(height: 24),

            // Label name input
            TextFormField(
              controller: controller.labelNameController,
              textAlign: TextAlign.start,
              style: textTheme.titleMedium,
              decoration: InputDecoration(
                labelText: "Label Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 16),
              )
            ),

            const SizedBox(height: 16),

            // Save button (moved just below label name)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: colorScheme.primary,
                ),
                onPressed: () {
                  _saveLabel();
                },
                child: Text(
                  "Save Label",
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

  _saveLabel() async {
    final labelName = controller.labelNameController.text.trim();

    // --- Validation messages ---
    final errors = <String>[];

    if (labelName.isEmpty) {
      errors.add("Label name is required");
    } else if (await controller.isNameExists(labelName)) {
      errors.add("Label name already exists");
    }

    // --- Show validation messages if any ---
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

    // --- Save the label if validation passes ---
    controller.name.value = labelName;
    await controller.createLabel();
    controller.reset();
    FocusScope.of(Get.context!).unfocus();
    Get.back();
  }





}
