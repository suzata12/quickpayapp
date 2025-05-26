import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../utils/mock_data.dart';
import '../widgets/custom_app_bar.dart';

class AddNewBillScreen extends StatefulWidget {
  const AddNewBillScreen({super.key});

  @override
  State<AddNewBillScreen> createState() => _AddNewBillScreenState();
}

class _AddNewBillScreenState extends State<AddNewBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedCategory;
  String? _selectedProvider;
  String? _selectedFrequency;
  bool _saveToQuickAccess = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveBill() {
    setState(() {
      _saveToQuickAccess = true;
    });

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Bill saved successfully!')));
      Navigator.pop(context);
    }
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String? Function(T?)? validator,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue30,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            isExpanded: true,
            decoration: const InputDecoration(border: InputBorder.none),
            hint: Text(placeholder, style: const TextStyle(color: Colors.grey)),
            items:
                items
                    .map(
                      (item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(item.toString()),
                      ),
                    )
                    .toList(),
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Add New Bill'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Bill Category Dropdown with placeholder
              _buildDropdown<String>(
                label: 'Bill Category',
                value: _selectedCategory,
                items: categories,
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator:
                    (value) => value == null ? 'Select a category' : null,
                placeholder: 'Select category',
              ),
              const SizedBox(height: 16),

              // Provider Dropdown with placeholder
              _buildDropdown<String>(
                label: 'Select Provider',
                value: _selectedProvider,
                items: providers,
                onChanged: (value) => setState(() => _selectedProvider = value),
                validator:
                    (value) => value == null ? 'Select a provider' : null,
                placeholder: 'Select provider',
              ),
              const SizedBox(height: 16),

              // Account Number label + field
              const Text(
                'Account Number:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(
                  hintText: 'Enter account number',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Enter account number' : null,
              ),
              const SizedBox(height: 16),

              // Due Date label + field
              const Text(
                'Due Date:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : 'Select due date',
                    style: TextStyle(
                      color: _selectedDate != null ? Colors.black : Colors.grey,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Total Amount label + field
              const Text(
                'Total Amount:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter amount';
                  }
                  final isValid = RegExp(r'^\d+\.?\d{0,2}$').hasMatch(value);
                  return isValid ? null : 'Enter valid number';
                },
              ),
              const SizedBox(height: 16),

              // Frequency Dropdown with placeholder
              _buildDropdown<String>(
                label: 'Frequency',
                value: _selectedFrequency,
                items: frequencies,
                onChanged:
                    (value) => setState(() => _selectedFrequency = value),
                validator: (value) => value == null ? 'Select frequency' : null,
                placeholder: 'Select frequency',
              ),
              const SizedBox(height: 16),

              // Notes label + field (already has label, keep as is)
              const Text(
                'Notes:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write any message here',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Checkbox(
                    value: _saveToQuickAccess,
                    onChanged: (value) {
                      setState(() {
                        _saveToQuickAccess = value ?? false;
                      });
                    },
                    activeColor: AppColors.primaryBlue,
                  ),
                  const Expanded(
                    child: Text(
                      'Save to Quick Access',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveBill,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'SAVE BILL',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.0,
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
