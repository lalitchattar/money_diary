import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/module/category/controller/category_controller.dart';

class CategoryListScreen extends GetView<CategoryController> {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text("Categories"), centerTitle: true),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: controller.isLoading.value
              ? _buildLoader(context, colorScheme)
              : controller.categories.isEmpty
              ? _buildEmptyState(context, colorScheme, textTheme)
              : _buildCategoryList(context, colorScheme, textTheme),
        ),
        floatingActionButton: controller.categories.isNotEmpty
            ? FloatingActionButton.extended(
                icon: const Icon(Icons.add),
                label: const Text("Add Category"),
                onPressed: () async {
                  controller.reset();
                  //Get.to(() => AddMerchantScreen());
                },
              )
            : null,
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Widget _buildLoader(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: CircularProgressIndicator(
        color: colorScheme.primary,
        strokeWidth: 3,
      ),
    );
  }

  /// --- Empty State View ---
  Widget _buildEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, size: 100, color: colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              "No Category Yet",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Categories help you organize your transactions.\nCreate your first category now!",
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                controller.reset();
                //Get.to(() => AddMerchantScreen());
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Category"),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: controller.categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final category = controller.categories[index];

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
            highlightColor: colorScheme.primary.withOpacity(0.04),
            onTap: () {
              controller.reset();
              //Get.to(() => MerchantDetailsScreen(), arguments: merchant);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Leading image with status halo
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: colorScheme.surfaceContainerLow,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            category.icon ??
                                'assets/images/default_merchant.png',
                            width: 80,
                            height: 80,
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
                            color: category.isActive
                                ? Colors.greenAccent
                                : Colors.redAccent,
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

                  // Name + Type column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          category.type, // subtitle for merchant type
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Transaction count badge
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '${category.transactionCount}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Transaction${category.transactionCount > 1 ? 's' : ''}',
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
      },
    );
  }
}
