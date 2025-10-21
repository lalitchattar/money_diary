import 'package:flutter/material.dart';

class AddLabelScreen extends StatefulWidget {
  const AddLabelScreen({super.key});

  @override
  State<AddLabelScreen> createState() => _AddLabelScreenState();
}

class _AddLabelScreenState extends State<AddLabelScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _labelNameController = TextEditingController();
  Color? _selectedColor;
  IconData? _selectedIcon;

  // List of material colors to choose from
  final List<Color> _colorOptions = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
  ];

  // List of icons to choose from
  final List<IconData> _iconOptions = [
    Icons.star,
    Icons.favorite,
    Icons.work,
    Icons.home,
    Icons.shopping_cart,
    Icons.school,
    Icons.fitness_center,
    Icons.music_note,
    Icons.travel_explore,
    Icons.local_cafe,
  ];

  // Open bottom sheet for color selection
  _pickColor() async {
    final selected = await showModalBottomSheet<Color>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Select Color",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        )),
                    IconButton(
                      icon: Icon(Icons.close, color: cs.onSurface),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Grid of colors
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _colorOptions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final color = _colorOptions[index];
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, color),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? cs.primary : Colors.transparent,
                            width: isSelected ? 3 : 0,
                          ),
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

    if (selected != null) {
      setState(() {
        _selectedColor = selected;
      });
    }
  }

  // Open bottom sheet for icon selection
  _pickIcon() async {
    final selected = await showModalBottomSheet<IconData>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Select Icon",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        )),
                    IconButton(
                      icon: Icon(Icons.close, color: cs.onSurface),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Grid of icons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _iconOptions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final icon = _iconOptions[index];
                    final isSelected = _selectedIcon == icon;
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, icon),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? cs.primaryContainer : cs.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? cs.primary : cs.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          icon,
                          color: isSelected ? cs.onPrimaryContainer : cs.onSurface,
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

    if (selected != null) {
      setState(() {
        _selectedIcon = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Label"),
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Label Name
              TextFormField(
                controller: _labelNameController,
                decoration: InputDecoration(
                  labelText: "Label Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: cs.surfaceVariant,
                ),
                validator: (value) => value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              // Label Color
              GestureDetector(
                onTap: _pickColor,
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
                        _selectedColor != null ? "Color Selected" : "Select Color",
                        style: typography.bodyLarge,
                      ),
                      if (_selectedColor != null)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _selectedColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Label Icon
              GestureDetector(
                onTap: _pickIcon,
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
                        _selectedIcon != null ? "Icon Selected" : "Select Icon",
                        style: typography.bodyLarge,
                      ),
                      if (_selectedIcon != null)
                        Icon(
                          _selectedIcon,
                          color: cs.primary,
                        ),
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
                        "labelName": _labelNameController.text,
                        "color": _selectedColor,
                        "icon": _selectedIcon,
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
