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

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  String selectedType = 'Income';

  List<Category> categories = [
    Category(name: 'Salary', type: 'Income', icon: Icons.attach_money, isActive: true, transactionCount: 5),
    Category(name: 'Groceries', type: 'Expense', icon: Icons.shopping_cart, isActive: true, transactionCount: 12),
    Category(name: 'Bonus', type: 'Income', icon: Icons.card_giftcard, isActive: false, transactionCount: 2),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final filteredCategories = categories.where((c) => c.type == selectedType).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Income', label: Text('Income')),
                ButtonSegment(value: 'Expense', label: Text('Expense')),
              ],
              selected: <String>{selectedType},
              onSelectionChanged: (newSelection) {
                setState(() {
                  selectedType = newSelection.first;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceVariant),
                foregroundColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredCategories.isEmpty
                ? _buildEmptyState(colorScheme, textTheme)
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: filteredCategories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return Card(
                  color: colorScheme.surfaceVariant,
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: colorScheme.outlineVariant, width: 1),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {

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
                                    border: Border.all(color: colorScheme.surface, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  category.name,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
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
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Category"),
        onPressed: () {
          //Navigator.push(context, MaterialPageRoute(builder: (_) => AddCategoryScreen()));
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
              child: Icon(Icons.category, size: 40, color: colorScheme.primary),
            ),
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
              "Categories help you group your expenses and earnings for better tracking. Create your first category today!",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (_) => AddCategoryScreen()));
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Category"),
            ),
          ],
        ),
      ),
    );
  }
}
