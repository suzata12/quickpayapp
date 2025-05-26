import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';

class PayBillForm extends StatefulWidget {
  final void Function()? onPaymentSuccess;

  const PayBillForm({Key? key, this.onPaymentSuccess}) : super(key: key);

  @override
  State<PayBillForm> createState() => _PayBillFormState();
}

class _PayBillFormState extends State<PayBillForm> {
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
    return '***${input.substring(input.length - 3)}';
  }

  bool _isFormValid() {
    return _formKey.currentState?.validate() ?? false;
  }

  void _handleSubmit() {
    if (_isFormValid() && _agreeChecked) {
      if (widget.onPaymentSuccess != null) {
        widget.onPaymentSuccess!();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment Successful!')));
      }
      // Optionally clear form or navigate
      _formKey.currentState?.reset();
      setState(() {
        _agreeChecked = false;
        _selectedCategory = _categories.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () => setState(() {}),
      child: Column(
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
              value: _selectedCategory,
              isExpanded: true,
              items:
                  _categories
                      .map(
                        (value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
              decoration: const InputDecoration(border: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text('Company Name:'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _companyController,
            decoration: const InputDecoration(
              labelText: 'Company Name',
              hintText: 'Enter company name',
              border: OutlineInputBorder(),
            ),
            validator:
                (value) =>
                    (value == null || value.isEmpty)
                        ? 'Please enter company name'
                        : null,
          ),
          const SizedBox(height: 16),
          const Text('Account Name:'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _accountNameController,
            decoration: const InputDecoration(
              labelText: 'Account Name',
              hintText: 'Enter account name',
              border: OutlineInputBorder(),
            ),
            validator:
                (value) =>
                    (value == null || value.isEmpty)
                        ? 'Please enter account name'
                        : null,
          ),
          const SizedBox(height: 16),
          const Text('Amount:'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount',
              hintText: 'Enter amount',
              border: OutlineInputBorder(),
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
            controller: _accountNumberController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Account Number',
              hintText: 'Enter account number',
              border: OutlineInputBorder(),
            ),
            validator:
                (value) =>
                    (value == null || value.length < 4)
                        ? 'Enter valid account number'
                        : null,
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text('Category: $_selectedCategory'),
                  Text('Provider: ${_companyController.text}'),
                  Text('Account Name: ${_accountNameController.text}'),
                  Text('Amount: \$${_amountController.text}'),
                  Text(
                    'Account #: ${_maskedCard(_accountNumberController.text)}',
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
              onPressed:
                  (_agreeChecked && _isFormValid()) ? _handleSubmit : null,
              child: const Text(
                'CONFIRM & PAY',
                style: TextStyle(fontSize: 16, letterSpacing: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
