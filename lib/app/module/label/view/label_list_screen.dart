import 'package:flutter/material.dart';

class Category {
  final String name;
  final String type; // "Income" or "Expense"
  final IconData icon;
  final bool isActive;
  final int transactionCount;

  Category({
    required this.name,
    required this.type,
    required this.icon,
    this.isActive = true,
    this.transactionCount = 0,
  });
}

class LabelListScreen extends StatefulWidget {
  const LabelListScreen({super.key});

  @override
  State<LabelListScreen> createState() => _LabelListScreenState();
}

class _LabelListScreenState extends State<LabelListScreen> {
  String selectedType = 'Income';

  List<Category> categories = [
 //   Category(name: 'Salary', type: 'Income', icon: Icons.attach_money, isActive: true, transactionCount: 5),
   // Category(name: 'Groceries', type: 'Expense', icon: Icons.shopping_cart, isActive: true, transactionCount: 12),
    //Category(name: 'Bonus', type: 'Income', icon: Icons.card_giftcard, isActive: false, transactionCount: 2),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final filteredCategories = categories.where((c) => c.type == selectedType).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Labels"),
        centerTitle: true,
        elevation: 0,
      ),
      body: filteredCategories.isEmpty
          ? _buildEmptyState(colorScheme, textTheme)
          : ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: filteredCategories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final category = filteredCategories[index];

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: colorScheme.outlineVariant, width: 1),
            ),
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primaryContainer.withOpacity(0.3),
                    child: Icon(category.icon, color: colorScheme.onPrimaryContainer),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: category.isActive ? Colors.greenAccent : Colors.redAccent,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                category.name,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                  const SizedBox(height: 4),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onTap: () {
                // Handle tap
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Category"),
        onPressed: () {
          // Navigate to add category screen
        },
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: colorScheme.surfaceVariant,
              child: Icon(Icons.label, size: 40, color: colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              "No Labels Yet",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Labels help you group your expenses and earnings for better tracking. Create your first label today!",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                // Navigate to add label screen
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Label"),
            ),
          ],
        ),
      ),
    );
  }
}
