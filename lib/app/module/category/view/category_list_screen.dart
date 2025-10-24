import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/module/category/controller/category_controller.dart';

import 'add_category_screen.dart';

class CategoryListScreen extends GetView<CategoryController> {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Categories"), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoader(colorScheme);
        } else {
          // Always show list, even if filtered list is empty
          return _buildCategoryList(colorScheme, textTheme);
        }
      }),
      floatingActionButton: Obx(() {
        if (controller.categories.isEmpty) return const SizedBox.shrink();
        return FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text("Add Category"),
          onPressed: () {
            FocusScope.of(context).unfocus(); // ✅ closes keyboard
            controller.reset();
             Get.to(() => AddCategoryScreen());
          },
        );
      }),
      resizeToAvoidBottomInset: false,
    );
  }

  /// --- Loader ---
  Widget _buildLoader(ColorScheme colorScheme) => Center(
    child: CircularProgressIndicator(
      color: colorScheme.primary,
      strokeWidth: 3,
    ),
  );

  /// --- Empty State ---
  Widget _buildEmptyState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_rounded, size: 100, color: colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              "No Category Yet",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Categories help you organize your transactions.\nCreate your first category now!",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                FocusScope.of(Get.context!).unfocus();
                controller.reset();
                // Get.to(() => AddCategoryScreen());
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Category"),
            ),
          ],
        ),
      ),
    );
  }

  /// --- Category List ---
  Widget _buildCategoryList(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        // ✅ Top Filters
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Obx(() => SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Expense', label: Text('Expense')),
                  ButtonSegment(value: 'Income', label: Text('Income')),
                ],
                selected: {controller.selectedType.value},
                onSelectionChanged: (selected) {
                  controller.selectedType.value = selected.first;
                  controller.applyFilter();
                },
              )),
              const SizedBox(height: 8),
              TextField(
                onChanged: controller.filterCategories,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search categories...',
                  filled: true,
                  fillColor: colorScheme.surfaceContainerLow,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colorScheme.primary, width: 1.2),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ✅ Category Items
        Expanded(
          child: Obx(() {
            final categories = controller.filteredCategories;

            if (categories.isEmpty) {
              return Center(
                child: Text(
                  "No matching categories found",
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCategoryItem(
                    category.name,
                    category.type,
                    category.transactionCount,
                    category.icon,
                    category.isActive,
                    colorScheme,
                    textTheme,
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }


  /// --- Category Item ---
  Widget _buildCategoryItem(
      String name,
      String type,
      int transactionCount,
      String? icon,
      bool isActive,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Card(
      color: colorScheme.surfaceContainerLow,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        splashColor: colorScheme.primary.withOpacity(0.08),
        onTap: () {
          FocusScope.of(Get.context!).unfocus();
          controller.reset();
          // Get.to(() => CategoryDetailsScreen());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.surfaceContainerLow,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        icon ?? 'assets/images/default_merchant.png',
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                        isActive ? Colors.greenAccent : Colors.redAccent,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      type,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '$transactionCount',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Transaction${transactionCount > 1 ? 's' : ''}',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
