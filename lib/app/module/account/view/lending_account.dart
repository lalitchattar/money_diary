import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddLendingAccountScreen extends StatefulWidget {
  const AddLendingAccountScreen({super.key});

  @override
  State<AddLendingAccountScreen> createState() => _AddLendingAccountScreenState();
}

class _AddLendingAccountScreenState extends State<AddLendingAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _accountTypeController = TextEditingController(text: "Lending Account");
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  bool showInNetWorth = true;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photo = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Lending Account'),
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
              // Type + Show in Net Worth
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      controller: _accountTypeController,
                      label: "Account Type",
                      hint: "Lending Account",
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

              // Mobile Number
              _buildTextField(
                controller: _mobileNumberController,
                label: "Mobile Number",
                hint: "Enter mobile number",
                cs: cs,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 12),

              // Email
              _buildTextField(
                controller: _emailController,
                label: "Email",
                hint: "Enter email",
                cs: cs,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              // Photo upload + Balance in same row
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickPhoto,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: cs.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.outline, width: 1.5),
                        image: _photo != null
                            ? DecorationImage(image: FileImage(_photo!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _photo == null
                          ? Icon(Icons.camera_alt, size: 40, color: cs.onSurfaceVariant)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _balanceController,
                      label: "Balance",
                      hint: "Enter balance",
                      cs: cs,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: cs.primary,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final data = {
                        "accountType": _accountTypeController.text,
                        "accountName": _accountNameController.text,
                        "mobileNumber": _mobileNumberController.text,
                        "email": _emailController.text,
                        "balance": _balanceController.text,
                        "showInNetWorth": showInNetWorth,
                        "photo": _photo,
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
      validator: (value) => mandatory && (value == null || value.isEmpty) ? "Required" : null,
    );
  }
}
