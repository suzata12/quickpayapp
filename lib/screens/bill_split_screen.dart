import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class BillSplitScreen extends StatefulWidget {
  final double totalAmount;
  const BillSplitScreen({super.key, required this.totalAmount});

  @override
  State<BillSplitScreen> createState() => _BillSplitScreenState();
}

class _BillSplitScreenState extends State<BillSplitScreen> {
  List<Contact> contacts = [];
  List<_SplitEntry> splits = [];

  TextEditingController manualNumberController = TextEditingController();
  TextEditingController manualAmountController = TextEditingController();

  bool loadingContacts = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() {
      loadingContacts = true;
    });
    try {
      if (await Permission.contacts.request().isGranted) {
        final fetchedContacts = await ContactsService.getContacts(
          withThumbnails: false,
        );
        setState(() {
          contacts = fetchedContacts.toList();
        });
      } else {
        // Permission denied
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contacts permission denied')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading contacts: $e')));
    }
    setState(() {
      loadingContacts = false;
    });
  }

  double get totalSplitAmount {
    return splits.fold(0, (sum, item) => sum + item.amount);
  }

  void _addManualSplit() {
    final number = manualNumberController.text.trim();
    final amount = double.tryParse(manualAmountController.text.trim()) ?? 0;

    if (number.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid number and amount')),
      );
      return;
    }

    setState(() {
      splits.add(_SplitEntry(name: number, amount: amount));
      manualNumberController.clear();
      manualAmountController.clear();
    });
  }

  void _addContactSplit(Contact contact) {
    if (contact.phones == null || contact.phones!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact has no phone number')),
      );
      return;
    }
    final phone = contact.phones!.first.value ?? '';

    // Check if already added
    if (splits.any((e) => e.name == phone)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Contact already added')));
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        final amountController = TextEditingController();
        return AlertDialog(
          title: Text('Enter amount for ${contact.displayName}'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'Amount'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final enteredAmount = double.tryParse(amountController.text);
                if (enteredAmount == null || enteredAmount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter a valid amount')),
                  );
                  return;
                }
                setState(() {
                  splits.add(
                    _SplitEntry(
                      name: phone,
                      amount: enteredAmount,
                      displayName: contact.displayName ?? phone,
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.totalAmount - totalSplitAmount;

    return Scaffold(
      appBar: AppBar(title: const Text('Split Bill')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Total Amount: \$${widget.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Remaining: \$${remaining.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: remaining < 0 ? Colors.red : Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child:
                  loadingContacts
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final contact = contacts[index];
                          return ListTile(
                            title: Text(contact.displayName ?? 'No Name'),
                            subtitle:
                                (contact.phones?.isNotEmpty ?? false)
                                    ? Text(contact.phones!.first.value ?? '')
                                    : const Text('No phone number'),
                            trailing: ElevatedButton(
                              child: const Text('Add'),
                              onPressed: () => _addContactSplit(contact),
                            ),
                          );
                        },
                      ),
            ),

            const Divider(),
            const Text('Add Manual Number & Amount'),
            TextField(
              controller: manualNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: manualAmountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            ElevatedButton(
              onPressed: _addManualSplit,
              child: const Text('Add Manual Split'),
            ),

            const SizedBox(height: 20),
            const Text(
              'Splits:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: splits.length,
                itemBuilder: (context, index) {
                  final split = splits[index];
                  return ListTile(
                    title: Text(split.displayName ?? split.name),
                    trailing: Text('\$${split.amount.toStringAsFixed(2)}'),
                    leading: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          splits.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed:
                  remaining == 0 && splits.isNotEmpty
                      ? () {
                        Navigator.pop(context, splits);
                      }
                      : null,
              child: const Text('Confirm Split'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplitEntry {
  final String name; // phone number
  final String? displayName;
  final double amount;

  _SplitEntry({required this.name, required this.amount, this.displayName});
}
