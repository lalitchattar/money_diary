import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/module/category/controller/category_controller.dart';
import '../../../custom/widget/validation_message_screen.dart';

class AddCategoryScreen extends GetView<CategoryController> {
  final TextEditingController categoryNameController = TextEditingController();

  AddCategoryScreen({super.key});

  /// 📁 Open bottom sheet to select an icon from assets/icons
  Future<void> _pickIcon(
      BuildContext context, TextTheme textTheme, ColorScheme colorScheme) async {
    final selectedIcon = await showModalBottomSheet<String>(
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
                      'Select Icon',
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
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.icons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final icon = controller.icons[index];
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, icon),
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(icon, height: 25, width: 25,),
                        ),
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

    if (selectedIcon != null) {
      controller.selectedIcon.value = selectedIcon;
    }
  }

  /// 💾 Validate and save category
  Future<void> _saveCategory() async {
    final name = categoryNameController.text.trim();
    controller.name.value = name;
    final errors = <String>[];

    if (name.isEmpty) {
      errors.add("Category name is required");
    } else if (await controller.isNameExists(name, controller.type.value)) {
      errors.add("Category name already exists");
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

    await controller.createCategory(); // Create category
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Add Category"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickIcon(context, textTheme, colorScheme),
              child: Obx(() {
                final icon = controller.selectedIcon.value;

                return Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: colorScheme.surfaceContainerLow,
                      child: icon != null
                          ? Image.asset(icon, width: 60, height: 60)
                          : const Icon(Icons.category, size: 40),
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

            // 🏷️ Category name field
            TextFormField(
              controller: categoryNameController,
              textAlign: TextAlign.start,
              style: textTheme.titleMedium,
              decoration: InputDecoration(
                labelText: "Category Name",
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
                onPressed: _saveCategory,
                child: Text(
                  "Save Category",
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
