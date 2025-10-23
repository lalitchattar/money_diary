import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/module/merchant/controller/merchant_controller.dart';
import 'package:money_diary/app/module/merchant/view/add_merchant_screen.dart';
import 'merchant_details_screen.dart';

class MerchantListScreen extends GetView<MerchantController> {
  const MerchantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Obx(
          () => Scaffold(
        appBar: AppBar(title: const Text("Merchants"), centerTitle: true),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: controller.isLoading.value
              ? _buildLoader(context, colorScheme)
              : controller.merchants.isEmpty
              ? _buildEmptyState(context, colorScheme, textTheme)
              : _buildMerchantList(context, colorScheme, textTheme),
        ),
        floatingActionButton: controller.merchants.isNotEmpty
            ? FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text("Add Merchant"),
          onPressed: () {
            controller.reset();
            Get.to(() => AddMerchantScreen());
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

  Widget _buildEmptyState(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, size: 100, color: colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              "No Merchants Yet",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Merchants help you organize your transactions.\nCreate your first merchant now!",
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
                Get.to(() => AddMerchantScreen());
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Merchant"),
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

  Widget _buildMerchantList(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        // 🔍 Search Field
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            onChanged: (value) => controller.searchQuery.value = value.trim(),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search merchants...',
              filled: true,
              fillColor: colorScheme.surfaceContainerLow,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colorScheme.primary, width: 1.2),
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // 🧾 Filtered List
        Expanded(
          child: Obx(() {
            final merchants = controller.filteredMerchants;

            if (merchants.isEmpty) {
              return Center(
                child: Text(
                  "No matching merchants found",
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: merchants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final merchant = merchants[index];

                return Card(
                  color: colorScheme.surfaceContainerLow,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side:
                    BorderSide(color: colorScheme.outlineVariant, width: 1),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    splashColor: colorScheme.primary.withOpacity(0.08),
                    highlightColor: colorScheme.primary.withOpacity(0.04),
                    onTap: () {
                      controller.reset();
                      Get.to(() => MerchantDetailsScreen(),
                          arguments: merchant);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                colorScheme.surfaceContainerLow,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: merchant.icon != null &&
                                      merchant.icon!.startsWith('/data')
                                      ? Image.file(
                                    File(merchant.icon!),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.asset(
                                    merchant.icon ??
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
                                    color: merchant.isActive
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  merchant.name,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  merchant.type,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  '${merchant.transactionCount}',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Transaction${merchant.transactionCount > 1 ? 's' : ''}',
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
          }),
        ),
      ],
    );
  }
}
