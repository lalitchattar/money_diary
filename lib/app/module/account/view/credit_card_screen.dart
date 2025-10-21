import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCreditCardScreen extends StatefulWidget {
  const AddCreditCardScreen({super.key});

  @override
  State<AddCreditCardScreen> createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _accountTypeController =
  TextEditingController(text: "Credit Card");
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _institutionNameController =
  TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _creditLimitController = TextEditingController();
  final TextEditingController _outstandingBalanceController =
  TextEditingController();
  final TextEditingController _billingDateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  bool showInNetWorth = true;

  /// Open bottom sheet to select day of month (1st, 2nd …)
  _pickDay(TextEditingController controller) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        final cs = Theme.of(context).colorScheme;

        String getDayWithSuffix(int day) {
          if (day >= 11 && day <= 13) return "${day}th";
          switch (day % 10) {
            case 1:
              return "${day}st";
            case 2:
              return "${day}nd";
            case 3:
              return "${day}rd";
            default:
              return "${day}th";
          }
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title and close button
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Day",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: cs.onSurface),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Grid of days
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 31,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final day = index + 1;
                    final dayText = getDayWithSuffix(day);
                    final isSelected =
                        controller.text == "Every month $dayText";
                    return GestureDetector(
                      onTap: () =>
                          Navigator.pop(context, "Every month $dayText"),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? cs.primary : cs.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? cs.primary : cs.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          dayText,
                          style: TextStyle(
                            color: isSelected ? cs.onPrimary : cs.onSurface,
                            fontWeight: isSelected ? FontWeight.bold : null,
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
        controller.text = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Credit Card'),
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Account Type + Show in Net Worth Row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      controller: _accountTypeController,
                      label: "Account Type",
                      hint: "Credit Card",
                      cs: cs,
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54, width: 1),
                        borderRadius: BorderRadius.circular(12),
                        color: cs.surfaceVariant,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Show in Net Worth",
                            style: typography.bodyMedium?.copyWith(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Switch(
                            value: showInNetWorth,
                            onChanged: (v) => setState(() => showInNetWorth = v),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Account Name
              _buildTextField(
                controller: _accountNameController,
                label: "Account Name",
                hint: "Enter account name",
                cs: cs,
              ),
              const SizedBox(height: 12),

              // Institution Name
              _buildTextField(
                controller: _institutionNameController,
                label: "Institution Name",
                hint: "Enter institution name",
                cs: cs,
              ),
              const SizedBox(height: 12),

              // Card Number (optional)
              _buildTextField(
                controller: _cardNumberController,
                label: "Card Number",
                hint: "XXXX-XXXX-XXXX-XXXX",
                cs: cs,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                mandatory: false,
              ),
              const SizedBox(height: 12),

              // Credit Limit
              _buildTextField(
                controller: _creditLimitController,
                label: "Credit Limit",
                hint: "Enter credit limit",
                cs: cs,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              // Outstanding Balance
              _buildTextField(
                controller: _outstandingBalanceController,
                label: "Outstanding Balance",
                hint: "Enter outstanding balance",
                cs: cs,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              // Billing Date (full width, optional)
              _buildDateField(
                controller: _billingDateController,
                label: "Billing Date",
                cs: cs,
                onTap: () => _pickDay(_billingDateController),
                mandatory: false,
              ),
              const SizedBox(height: 12),

              // Due Date (full width, optional)
              _buildDateField(
                controller: _dueDateController,
                label: "Due Date",
                cs: cs,
                onTap: () => _pickDay(_dueDateController),
                mandatory: false,
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: cs.primary,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final data = {
                        "accountType": _accountTypeController.text,
                        "accountName": _accountNameController.text,
                        "institutionName": _institutionNameController.text,
                        "cardNumber": _cardNumberController.text,
                        "creditLimit": _creditLimitController.text,
                        "outstandingBalance":
                        _outstandingBalanceController.text,
                        "billingDate": _billingDateController.text,
                        "dueDate": _dueDateController.text,
                        "showInNetWorth": showInNetWorth,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required ColorScheme cs,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    bool mandatory = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: cs.surfaceVariant,
      ),
      validator: (value) =>
      mandatory && (value == null || value.isEmpty) ? "Required" : null,
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required ColorScheme cs,
    required VoidCallback onTap,
    bool mandatory = true,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: cs.surfaceVariant,
        suffixIcon: Icon(Icons.calendar_today, color: cs.onSurfaceVariant),
      ),
      validator: (value) =>
      mandatory && (value == null || value.isEmpty) ? "Required" : null,
    );
  }
}
