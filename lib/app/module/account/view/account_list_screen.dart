import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/module/account/controller/account_controller.dart';
import 'package:money_diary/app/module/account/view/account_type_screen.dart';
import 'package:money_diary/app/module/general/controller/general_settings_controller.dart';
import 'package:money_diary/app/utils/utility.dart';

import '../../../data/model/account_model.dart';


class AccountListScreen extends GetView<AccountController> {

  AccountListScreen({super.key});

  final generalSettingsController = Get.find<GeneralSettingsController>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Accounts"), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoader(colorScheme);
        }

        if (controller.accountGroups.isEmpty) {
          return _buildEmptyState(context, colorScheme, textTheme);
        }

        return _buildAccountList(context, colorScheme, textTheme);
      }),
      floatingActionButton: controller.accountGroups.isNotEmpty
          ? FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Account"),
        onPressed: () {
          Get.to(() => SelectAccountTypeScreen());
        },
      )
          : const SizedBox.shrink(),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildLoader(ColorScheme colorScheme) => Center(
    child: CircularProgressIndicator(
      color: colorScheme.primary,
      strokeWidth: 3,
    ),
  );

  Widget _buildEmptyState(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet,
                size: 100, color: colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              "No Accounts Yet",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Accounts help you manage your finances and track your net worth. Create your first account to get started!",
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Get.to(() => SelectAccountTypeScreen());
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Account"),
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

  Widget _buildAccountList(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value.trim(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search accounts...',
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
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              final accountGroups = controller.filteredAccountGroups;

              if (accountGroups.isEmpty) {
                return Center(
                  child: Text(
                    "No matching accounts found",
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: accountGroups.length,
                itemBuilder: (context, groupIndex) {
                  final group = accountGroups[groupIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        child: Text(
                          group.type,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: group.accounts.length,
                        itemBuilder: (context, index) {
                          final account = group.accounts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildAccountCard(
                              account, context, colorScheme, textTheme,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(
      Account account, BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
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
          FocusScope.of(context).unfocus();
          //controller.reset();
          //Get.to(() => AccountDetailsScreen(), arguments: account);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.surfaceContainerLow,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: account.icon != null && account.icon!.startsWith('/data')
                          ? Image.file(
                        File(account.icon!),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        account.icon ?? 'assets/icons/default_account.png',
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
                        color:
                        account.isActive ? Colors.greenAccent : Colors.redAccent,
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
                      account.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${generalSettingsController.currencySymbol} ${formatToDecimal(account.currentBalance.toString(), generalSettingsController.decimalPlaces.value)}',
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '${account.transactionCount}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Transaction${account.transactionCount > 1 ? 's' : ''}',
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
