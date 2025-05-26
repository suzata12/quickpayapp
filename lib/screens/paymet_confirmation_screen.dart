import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirmation"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 10),
            const Text(
              "Payment Successful!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // DETAILS CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _InfoRow(label: "Bill", value: "Electricity"),
                    _InfoRow(label: "Provider", value: "ABC Company"),
                    _InfoRow(label: "Amount Paid", value: "\$350.00"),
                    _InfoRow(label: "Paid From", value: "Wallet"),
                    _InfoRow(label: "Date", value: "April 11, 2025"),
                    _InfoRow(label: "Transaction ID", value: "TXN#123456789"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.download,
                  label: "Download",
                  onPressed: () {
                    downloadReceipt(context);
                  },
                ),
                _ActionButton(
                  icon: Icons.share,
                  label: "Share",
                  onPressed: () {
                    shareReceipt(context);
                  },
                ),
                _ActionButton(
                  icon: Icons.alarm,
                  label: "Reminder",
                  onPressed: () {
                    setReminder(context);
                  },
                ),
              ],
            ),

            const Spacer(),

            // BACK BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Download receipt as PDF
  Future<void> downloadReceipt(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build:
            (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Payment Receipt", style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text("Bill: Electricity"),
                pw.Text("Provider: ABC Company"),
                pw.Text("Amount Paid: \$350.00"),
                pw.Text("Paid From: Wallet"),
                pw.Text("Date: April 11, 2025"),
                pw.Text("Transaction ID: TXN#123456789"),
              ],
            ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/receipt.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Receipt downloaded to documents folder.")),
    );
  }

  // Placeholder for Share functionality
  void shareReceipt(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Sharing receipt...")));
    // To implement: use share_plus
  }

  // Placeholder for Reminder functionality
  void setReminder(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Reminder set!")));
    // To implement: use flutter_local_notifications
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
            color: Colors.blueAccent,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }
}
