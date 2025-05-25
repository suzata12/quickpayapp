import 'package:flutter/material.dart';
import '../models/bill.dart';

class SplitBillDialog extends StatefulWidget {
  final Bill bill;

  const SplitBillDialog({required this.bill, Key? key}) : super(key: key);

  @override
  State<SplitBillDialog> createState() => _SplitBillDialogState();
}

class _SplitBillDialogState extends State<SplitBillDialog> {
  // Example: simple split amount input for contacts (mocked)
  double splitAmount = 0.0;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    splitAmount = widget.bill.amount / 2; // default split
    _controller.text = splitAmount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Split Bill: ${widget.bill.title}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Total Amount: \$${widget.bill.amount.toStringAsFixed(2)}'),
          SizedBox(height: 10),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            decoration: InputDecoration(
              labelText: 'Split Amount',
              prefixText: '\$',
            ),
            onChanged: (value) {
              setState(() {
                splitAmount = double.tryParse(value) ?? 0.0;
              });
            },
          ),
          SizedBox(height: 10),
          Text(
            'This will simulate splitting the bill with contacts.',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Just close dialog for now, no backend
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Bill split for \$${splitAmount.toStringAsFixed(2)}',
                ),
              ),
            );
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
