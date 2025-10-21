import 'package:flutter/material.dart';

class AccountSelectionScreen extends StatefulWidget {
  const AccountSelectionScreen({super.key});

  @override
  State<AccountSelectionScreen> createState() => _AccountSelectionScreenState();
}

class _AccountSelectionScreenState extends State<AccountSelectionScreen> {
  final Map<String, List<Map<String, dynamic>>> categories = {
    'Cash': [
      {'name': 'Bank', 'icon': Icons.account_balance_wallet},
      {'name': 'Cash', 'icon': Icons.money},
      {'name': 'Wallet', 'icon': Icons.wallet_giftcard},
      {'name': 'Checking', 'icon': Icons.credit_card},
      {'name': 'Lending', 'icon': Icons.payments},
      {'name': 'Saving', 'icon': Icons.savings},
      {'name': 'Other', 'icon': Icons.more_horiz},
    ],
    'Credit': [
      {'name': 'Credit Card', 'icon': Icons.credit_card},
      {'name': 'Line of Credit', 'icon': Icons.attach_money},
    ],
    'Investment': [
      {'name': 'Retirement', 'icon': Icons.beach_access},
      {'name': 'Brokerage', 'icon': Icons.show_chart},
      {'name': 'Investment', 'icon': Icons.trending_up},
      {'name': 'Insurance', 'icon': Icons.shield},
      {'name': 'Crypto', 'icon': Icons.currency_bitcoin},
    ],
    'Loans': [
      {'name': 'Loan', 'icon': Icons.account_balance},
      {'name': 'Mortgage', 'icon': Icons.home},
      {'name': 'Borrowing', 'icon': Icons.money_off},
    ],
    'Assets': [
      {'name': 'Property', 'icon': Icons.apartment},
    ],
  };

  final Map<String, String> categorySubtitles = {
    'Cash': 'Bank, wallet, and cash accounts',
    'Credit': 'Credit cards & lines of credit',
    'Investment': 'Stocks, crypto, insurance & retirement',
    'Loans': 'Loans, mortgages, borrowings',
    'Assets': 'Your property and assets',
  };

  final Map<String, IconData> categoryIcons = {
    'Cash': Icons.account_balance_wallet,
    'Credit': Icons.credit_card,
    'Investment': Icons.trending_up,
    'Loans': Icons.account_balance,
    'Assets': Icons.apartment,
  };

  String? selectedAccount;
  final Set<String> expandedCategories = {};

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Account Type'),
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: categories.entries.map((entry) {
            final category = entry.key;
            final options = entry.value;
            final subtitle = categorySubtitles[category] ?? '';
            final sectionIcon = categoryIcons[category];
            final isExpanded = expandedCategories.contains(category);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0.5,
              color: cs.surfaceContainerHighest,
              child: Column(
                children: [
                  // Tile header
                  ListTile(
                    leading: Icon(sectionIcon, color: cs.primary),
                    title: Text(
                      category,
                      style: typography.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      subtitle,
                      style: typography.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    trailing: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: cs.onSurfaceVariant,
                    ),
                    minVerticalPadding: 8,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          expandedCategories.remove(category);
                        } else {
                          expandedCategories.add(category);
                        }
                      });
                    },
                  ),

                  // Grid of options
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.0, // makes tiles square
                        children: options.map((option) {
                          final isSelected = selectedAccount == option['name'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAccount = option['name'];
                              });
                              Navigator.pop(context, {
                                'category': category,
                                'account': option['name'],
                              });
                            },
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  height: constraints.maxWidth, // makes height equal to width
                                  decoration: BoxDecoration(
                                    color: isSelected ? cs.primaryContainer : cs.surfaceVariant,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? cs.primary : cs.outlineVariant,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        option['icon'],
                                        size: 24,
                                        color: isSelected ? cs.onPrimaryContainer : cs.primary,
                                      ),
                                      const SizedBox(height: 4),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          option['name'],
                                          textAlign: TextAlign.center,
                                          style: typography.labelSmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: isSelected ? cs.onPrimaryContainer : cs.onSurface,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    )

                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
