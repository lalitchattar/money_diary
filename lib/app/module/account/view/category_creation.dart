import 'package:flutter/material.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryNameController = TextEditingController();
  String? _categoryType; // Expense / Income
  IconData? _categoryIcon;

  final List<String> _categoryTypes = ['Expense', 'Income'];

  final List<IconData> _iconOptions = [
    Icons.shopping_cart,
    Icons.food_bank,
    Icons.directions_car,
    Icons.home,
    Icons.sports_soccer,
    Icons.movie,
    Icons.fitness_center,
    Icons.school,
    Icons.travel_explore,
    Icons.work,
  ];

  void _openCategoryTypePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final cs = Theme.of(context).colorScheme;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Select Category Type',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
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
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _categoryTypes.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, i) {
                    final type = _categoryTypes[i];
                    return ListTile(
                      title: Text(type),
                      trailing: type == _categoryType
                          ? Icon(Icons.check, color: cs.primary)
                          : null,
                      onTap: () {
                        setState(() => _categoryType = type);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickCategoryIcon() async {
    final selected = await showModalBottomSheet<IconData>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: cs.onSurface.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: Row(
                  children: [
                    Text('Select Icon',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CLOSE'))
                  ],
                ),
              ),
              const Divider(height: 8),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: _iconOptions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final icon = _iconOptions[index];
                    final isSelected = _categoryIcon == icon;
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, icon),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cs.primaryContainer
                              : cs.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? cs.primary : cs.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(icon,
                            color: isSelected
                                ? cs.onPrimaryContainer
                                : cs.onSurface),
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
      setState(() {
        _categoryIcon = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Category Name
              TextFormField(
                controller: _categoryNameController,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: cs.surfaceVariant,
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              // Category Type Picker
              GestureDetector(
                onTap: _openCategoryTypePicker,
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: cs.outline,
                      width: 1.5,
                    ),
                    color: cs.surfaceVariant,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _categoryType ?? "Select Type",
                        style: typography.bodyLarge,
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category Icon Picker
              GestureDetector(
                onTap: _pickCategoryIcon,
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: cs.outline,
                      width: 1.5,
                    ),
                    color: cs.surfaceVariant,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _categoryIcon != null ? "Icon Selected" : "Select Icon",
                        style: typography.bodyLarge,
                      ),
                      if (_categoryIcon != null)
                        Icon(_categoryIcon, color: cs.primary)
                      else
                        const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: cs.primary,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final data = {
                        "categoryName": _categoryNameController.text,
                        "categoryType": _categoryType,
                        "categoryIcon": _categoryIcon,
                      };
                      Navigator.pop(context, data);
                    }
                  },
                  child: Text(
                    "Save",
                    style: typography.bodyLarge?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
