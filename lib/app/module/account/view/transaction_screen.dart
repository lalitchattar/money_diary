import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class TransactionEntryScreen extends StatefulWidget {
  const TransactionEntryScreen({super.key});

  @override
  State<TransactionEntryScreen> createState() => _TransactionEntryScreenState();
}

class _TransactionEntryScreenState extends State<TransactionEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedType = 'Expense';

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _fromAccountController = TextEditingController();
  final TextEditingController _toAccountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  List<String> tags = [];
  List<String> attachedFiles = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      _dateController.text = "${date.day}/${date.month}/${date.year}";
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      _timeController.text = time.format(context);
    }
  }

  Future<void> _openBottomSheet(
      String title,
      TextEditingController controller,
      List<String> items,
      ) async {
    final selected = await showModalBottomSheet<String>(
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
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CLOSE'),
                    )
                  ],
                ),
              ),
              const Divider(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, i) {
                    final e = items[i];
                    return ListTile(
                      title: Text(e),
                      onTap: () => Navigator.pop(context, e),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) setState(() => controller.text = selected);
  }

  void _addTag(String tag) {
    if (tag.trim().isEmpty) return;
    setState(() {
      tags.add(tag.trim());
      _tagController.clear();
    });
  }

  void _removeTag(String tag) {
    setState(() => tags.remove(tag));
  }

  Future<void> _attachBill() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Attach Bill",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListTile(
                leading: Icon(Icons.photo_library,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text("Pick from Gallery"),
                onTap: () async {
                  final file = await _picker.pickImage(source: ImageSource.gallery);
                  if (file != null) setState(() => attachedFiles.add(file.name));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text("Take Photo"),
                onTap: () async {
                  final file = await _picker.pickImage(source: ImageSource.camera);
                  if (file != null) setState(() => attachedFiles.add(file.name));
                  Navigator.pop(context);
                },
              ),
              TextButton(
                  onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        surfaceTintColor: cs.surfaceTint,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Button
              Center(
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Expense', label: Text('Expense')),
                    ButtonSegment(value: 'Income', label: Text('Income')),
                    ButtonSegment(value: 'Transfer', label: Text('Transfer')),
                  ],
                  selected: {_selectedType},
                  onSelectionChanged: (v) => setState(() => _selectedType = v.first),
                ),
              ),
              const SizedBox(height: 16),

              // Date and Time Row
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      controller: _dateController,
                      label: 'Date',
                      cs: cs,
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateField(
                      controller: _timeController,
                      label: 'Time',
                      cs: cs,
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _amountController,
                label: 'Amount',
                hint: 'Enter amount',
                cs: cs,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              if (_selectedType != 'Income')
                _buildBottomSheetField(
                  controller: _fromAccountController,
                  label: 'From Account',
                  cs: cs,
                  onTap: () => _openBottomSheet(
                      'Select Account', _fromAccountController, ['Cash', 'Bank', 'Wallet']),
                ),

              if (_selectedType == 'Transfer') const SizedBox(height: 12),

              if (_selectedType == 'Income' || _selectedType == 'Transfer')
                _buildBottomSheetField(
                  controller: _toAccountController,
                  label: 'To Account',
                  cs: cs,
                  onTap: () => _openBottomSheet(
                      'Select Account', _toAccountController, ['Cash', 'Bank', 'Wallet']),
                ),

              const SizedBox(height: 12),

              _buildBottomSheetField(
                controller: _categoryController,
                label: 'Category',
                cs: cs,
                onTap: () => _openBottomSheet(
                    'Select Category', _categoryController, ['Food', 'Travel', 'Bills', 'Salary']),
              ),
              const SizedBox(height: 12),

              if (_selectedType == 'Expense')
                _buildBottomSheetField(
                  controller: _merchantController,
                  label: 'Merchant',
                  cs: cs,
                  onTap: () => _openBottomSheet(
                      'Select Merchant', _merchantController, ['Amazon', 'Swiggy', 'Uber']),
                ),

              if (_selectedType == 'Transfer')
                _buildTextField(
                  controller: _purposeController,
                  label: 'Purpose',
                  hint: 'Enter purpose',
                  cs: cs,
                ),

              // Labels
              const SizedBox(height: 12),
              TextFormField(
                controller: _tagController,
                decoration: InputDecoration(
                  labelText: 'Labels',
                  hintText: 'Add tag',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: cs.surfaceVariant,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _addTag(_tagController.text),
                  ),
                ),
                onFieldSubmitted: _addTag,
              ),
              const SizedBox(height: 8),
              if (tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags
                      .map((tag) => Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () => _removeTag(tag),
                  ))
                      .toList(),
                ),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _notesController,
                label: 'Notes',
                hint: 'Add notes',
                cs: cs,
                mandatory: false,
              ),
              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: _attachBill,
                icon: const Icon(Icons.attach_file),
                label: const Text('Attach Bill'),
              ),

              if (attachedFiles.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children:
                  attachedFiles.map((f) => Chip(label: Text(f))).toList(),
                ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    backgroundColor: cs.primary, // primary color
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Save',
                    style: typography.bodyLarge?.copyWith(
                        color: cs.onPrimary, fontWeight: FontWeight.bold), // onPrimary text color
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required ColorScheme cs,
    TextInputType keyboardType = TextInputType.text,
    bool mandatory = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: cs.surfaceVariant,
      ),
      validator: (v) =>
      mandatory && (v == null || v.isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required ColorScheme cs,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: cs.surfaceVariant,
        suffixIcon: Icon(Icons.calendar_today, color: cs.onSurfaceVariant),
      ),
    );
  }

  Widget _buildBottomSheetField({
    required TextEditingController controller,
    required String label,
    required ColorScheme cs,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: cs.surfaceVariant,
        suffixIcon: Icon(Icons.arrow_drop_down, color: cs.onSurfaceVariant),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
    );
  }
}
