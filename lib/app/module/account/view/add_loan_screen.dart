import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddLoanAccountScreen extends StatefulWidget {
  const AddLoanAccountScreen({super.key});

  @override
  State<AddLoanAccountScreen> createState() => _AddLoanAccountScreenState();
}

class _AddLoanAccountScreenState extends State<AddLoanAccountScreen> {
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  final _pageController = PageController();
  int _currentStep = 0;

  // Controllers
  final TextEditingController _accountTypeController =
  TextEditingController(text: "Loan Account");
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _institutionNameController =
  TextEditingController();
  final TextEditingController _accountNumberController =
  TextEditingController();
  final TextEditingController _loanStartDateController =
  TextEditingController();
  final TextEditingController _totalLoanAmountController =
  TextEditingController();
  final TextEditingController _currentOutstandingController =
  TextEditingController();
  final TextEditingController _interestRateController =
  TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _compoundingFrequencyController =
  TextEditingController();
  final TextEditingController _paymentFrequencyController =
  TextEditingController();
  final TextEditingController _paymentDueDateController =
  TextEditingController();

  bool showInNetWorth = true;

  final List<String> _frequencyOptions = [
    "Weekly",
    "Bi-Weekly",
    "Monthly",
    "Quarterly",
    "Annually"
  ];

  void _nextStep() {
    if (_currentStep == 0 && _formKeyStep1.currentState!.validate() ||
        _currentStep == 1 && _formKeyStep2.currentState!.validate() ||
        _currentStep == 2 && _formKeyStep3.currentState!.validate()) {
      if (_currentStep < 2) {
        setState(() => _currentStep++);
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else {
        _save();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _save() {
    final data = {
      "accountType": _accountTypeController.text,
      "accountName": _accountNameController.text,
      "institutionName": _institutionNameController.text,
      "accountNumber": _accountNumberController.text,
      "loanStartDate": _loanStartDateController.text,
      "totalLoanAmount": _totalLoanAmountController.text,
      "currentOutstanding": _currentOutstandingController.text,
      "interestRate": _interestRateController.text,
      "duration": _durationController.text,
      "compoundingFrequency": _compoundingFrequencyController.text,
      "paymentFrequency": _paymentFrequencyController.text,
      "paymentDueDate": _paymentDueDateController.text,
      "showInNetWorth": showInNetWorth,
    };
    Navigator.pop(context, data);
  }

  // Date picker for Loan Start Date
  Future<void> _pickLoanStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      _loanStartDateController.text =
      "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    }
  }

  // Bottom sheet picker for frequency
  Future<void> _pickFrequency(TextEditingController controller, String title) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                        child: const Text('CLOSE'))
                  ],
                ),
              ),
              const Divider(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _frequencyOptions.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, i) {
                    final f = _frequencyOptions[i];
                    return ListTile(
                      title: Text(f),
                      trailing: f == controller.text
                          ? Icon(Icons.check, color: cs.primary)
                          : null,
                      onTap: () => Navigator.pop(context, f),
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
      setState(() => controller.text = selected);
    }
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
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly || onTap != null,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: cs.surfaceVariant,
        suffixIcon: onTap != null ? Icon(Icons.calendar_today, color: cs.onSurfaceVariant) : null,
      ),
      validator: (value) => mandatory && (value == null || value.isEmpty) ? "Required" : null,
    );
  }

  Widget _buildStepForm(GlobalKey<FormState> formKey, List<Widget> fields) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: fields,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (_currentStep > 0)
                  OutlinedButton(onPressed: _previousStep, child: const Text("Back")),
                const Spacer(),
                FilledButton(
                    onPressed: _nextStep,
                    child: Text(_currentStep < 2 ? "Next" : "Save"))
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Loan Account"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Step title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              ["Step 1: Basic Info", "Step 2: Loan Details", "Step 3: Payment Info"][_currentStep],
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Step 1
                _buildStepForm(_formKeyStep1, [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                            controller: _accountTypeController,
                            label: "Account Type",
                            hint: "Loan Account",
                            cs: cs,
                            readOnly: true),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
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
                  _buildTextField(
                    controller: _institutionNameController,
                    label: "Institution Name",
                    hint: "Enter institution name",
                    cs: cs,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _accountNameController,
                    label: "Account Name",
                    hint: "Enter account name",
                    cs: cs,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _accountNumberController,
                    label: "Account Number",
                    hint: "Enter account number",
                    cs: cs,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ]),

                // Step 2
                _buildStepForm(_formKeyStep2, [
                  _buildTextField(
                      controller: _loanStartDateController,
                      label: "Loan Start Date",
                      hint: "Select loan start date",
                      cs: cs,
                      onTap: _pickLoanStartDate),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _totalLoanAmountController,
                    label: "Total Loan Amount",
                    hint: "Enter total loan amount",
                    cs: cs,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _currentOutstandingController,
                    label: "Current Outstanding",
                    hint: "Enter current outstanding",
                    cs: cs,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _interestRateController,
                    label: "Interest Rate (%)",
                    hint: "Enter interest rate",
                    cs: cs,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _durationController,
                    label: "Duration (Months)",
                    hint: "Enter duration in months",
                    cs: cs,
                    keyboardType: TextInputType.number,
                  ),
                ]),

                // Step 3
                _buildStepForm(_formKeyStep3, [
                  _buildTextField(
                      controller: _compoundingFrequencyController,
                      label: "Compounding Frequency",
                      hint: "Select compounding frequency",
                      cs: cs,
                      readOnly: true,
                      onTap: () => _pickFrequency(
                          _compoundingFrequencyController, "Select Compounding Frequency")),
                  const SizedBox(height: 12),
                  _buildTextField(
                      controller: _paymentFrequencyController,
                      label: "Payment Frequency",
                      hint: "Select payment frequency",
                      cs: cs,
                      readOnly: true,
                      onTap: () => _pickFrequency(
                          _paymentFrequencyController, "Select Payment Frequency")),
                  const SizedBox(height: 12),
                  _buildTextField(
                      controller: _paymentDueDateController,
                      label: "Payment Due Date",
                      hint: "Select payment due date",
                      cs: cs,
                      readOnly: true,
                      onTap: () => _pickFrequency(
                          _paymentDueDateController, "Select Payment Due Date")),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
