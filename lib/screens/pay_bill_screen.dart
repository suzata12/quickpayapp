import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:quickpay_app/screens/paymet_confirmation_screen.dart';
import '../constants/colors.dart';
import '../widgets/custom_app_bar.dart';

class PayBillScreen extends StatefulWidget {
  const PayBillScreen({super.key});

  @override
  State<PayBillScreen> createState() => _PayBillScreenState();
}

class _PayBillScreenState extends State<PayBillScreen> {
  final _formKey = GlobalKey<FormState>();

  final _companyController = TextEditingController();
  final _amountController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();

  String _selectedCategory = 'Utilities';
  bool _agreeChecked = false;
  final List<String> _categories = [
    'Utilities',
    'Internet',
    'Mobile',
    'Electricity',
    'Water',
  ];

  final List<String> _splitContacts = [
    '04523122627',
    '3456787654323',
    '23456787654',
    '234567754567',
  ];

  @override
  void dispose() {
    _companyController.dispose();
    _amountController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  String _maskedCard(String input) {
    if (input.length < 3) return '***';
    return '${'*' * (input.length - 3)}${input.substring(input.length - 3)}';
  }

  bool _isFormValid() {
    return _formKey.currentState?.validate() ?? false;
  }

  void _onFormChanged() {
    setState(() {});
  }

  Future<void> _selectContact() async {
    final status = await Permission.contacts.request();
    if (status.isGranted) {
      final contacts = await ContactsService.getContacts(withThumbnails: false);
      final phones =
          contacts
              .where((c) => c.phones != null && c.phones!.isNotEmpty)
              .toList();

      showModalBottomSheet(
        context: context,
        builder:
            (_) => ListView.builder(
              itemCount: phones.length,
              itemBuilder: (_, index) {
                final contact = phones[index];
                final phone = contact.phones!.first.value ?? '';
                return ListTile(
                  title: Text(contact.displayName ?? ''),
                  subtitle: Text(phone),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _splitContacts.add(phone);
                    });
                  },
                );
              },
            ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied to access contacts')),
      );
    }
  }

  double _calculateSplitAmount() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final splitCount = _splitContacts.length + 1;
    return amount / splitCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Pay Bill'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          onChanged: _onFormChanged,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaymentOptionForm(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategoryChanged: (val) {
                  setState(() {
                    _selectedCategory = val!;
                  });
                },
                companyController: _companyController,
                accountNameController: _accountNameController,
                amountController: _amountController,
                accountNumberController: _accountNumberController,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectContact,
                child: const Text('Add Contact to Split With'),
              ),
              if (_splitContacts.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Text('Split With:'),
                    ..._splitContacts.map((c) => Text('• $c')),
                  ],
                ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _agreeChecked,
                title: const Text('I agree'),
                onChanged: (value) {
                  setState(() {
                    _agreeChecked = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppColors.primaryBlue,
              ),
              const SizedBox(height: 16),
              if (_agreeChecked && _isFormValid())
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Category: $_selectedCategory'),
                      Text('Provider: ${_companyController.text}'),
                      Text('Account Name: ${_accountNameController.text}'),
                      Text('Amount: \$${_amountController.text}'),
                      Text(
                        'Account #: ${_maskedCard(_accountNumberController.text)}',
                      ),
                      if (_splitContacts.isNotEmpty)
                        Text(
                          'Split Amount per Person: \$${_calculateSplitAmount().toStringAsFixed(2)}',
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              const Text(
                'Secured by 123-bit encryption',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _agreeChecked) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment Successful!')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const PaymentConfirmationScreen(),
                        ),
                      );
                      // Optionally clear form or navigate away here
                    }
                  },
                  child: const Text(
                    'CONFIRM & PAY',
                    style: TextStyle(fontSize: 16, letterSpacing: 1.2),
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

class PaymentOptionForm extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final TextEditingController companyController;
  final TextEditingController accountNameController;
  final TextEditingController amountController;
  final TextEditingController accountNumberController;

  const PaymentOptionForm({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.companyController,
    required this.accountNameController,
    required this.amountController,
    required this.accountNumberController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Category:'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue30,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedCategory,
            isExpanded: true,
            items:
                categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            decoration: const InputDecoration(border: InputBorder.none),
            onChanged: onCategoryChanged,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Company Name:'),
        const SizedBox(height: 8),
        TextFormField(
          controller: companyController,
          decoration: const InputDecoration(
            labelText: 'Company Name',
            hintText: 'Enter company name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter company name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        const Text('Account Name:'),
        const SizedBox(height: 8),
        TextFormField(
          controller: accountNameController,
          decoration: const InputDecoration(
            labelText: 'Account Name',
            hintText: 'Enter account name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter account name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        const Text('Amount:'),
        const SizedBox(height: 8),
        TextFormField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Amount',
            hintText: 'Enter amount',
            border: OutlineInputBorder(),
            filled: false,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            final isValid = RegExp(r'^\d+\.?\d{0,2}$').hasMatch(value);
            return isValid ? null : 'Enter valid number';
          },
        ),
        const SizedBox(height: 16),
        const Text('Account Number:'),
        const SizedBox(height: 8),
        TextFormField(
          controller: accountNumberController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Account Number',
            hintText: 'Enter account number',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.length < 4) {
              return 'Enter valid account number';
            }
            return null;
          },
        ),
      ],
    );
  }
}
