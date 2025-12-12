import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/features/transactions/presentation/providers/transaction_form_provider.dart';

class AddTransactionModal extends ConsumerStatefulWidget {
  final int targetId;
  final double currentBalance; // Tambah parameter ini
  final double targetAmount;   // Tambah parameter ini

  const AddTransactionModal({
    super.key, 
    required this.targetId,
    required this.currentBalance,
    required this.targetAmount,
  });

  @override
  ConsumerState<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends ConsumerState<AddTransactionModal> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  TransactionType _type = TransactionType.increase;
  final _currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_formatAmount);
  }

  void _formatAmount() {
    final text = _amountController.text;
    if (text.isEmpty) return;
    final plainText = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (plainText.isEmpty) return;
    final number = int.tryParse(plainText);
    if (number != null) {
      final formattedText = _currencyFormatter.format(number);
      if (text != formattedText) {
        _amountController.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _amountController.removeListener(_formatAmount);
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // 1. Parsing Input
    final amountStr = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final double amount = double.tryParse(amountStr) ?? 0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan nominal > 0')));
      return;
    }

    // 2. VALIDASI MAKSIMUM (Fitur Baru)
    if (_type == TransactionType.increase) {
      final sisaButuh = widget.targetAmount - widget.currentBalance;
      if (amount > sisaButuh) {
        final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ups! Cukup ${currencyFormatter.format(sisaButuh)} lagi untuk selesai.'),
            backgroundColor: Colors.orange,
          )
        );
        return; // Batalkan proses
      }
    }
    // 3. VALIDASI PENARIKAN (Opsional, jangan tarik lebih dari saldo)
    else if (_type == TransactionType.decrease) {
      if (amount > widget.currentBalance) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saldo tidak cukup untuk ditarik.')));
        return;
      }
    }

    bool success = false;
    try {
      // 4. Eksekusi Simpan
      success = await ref.read(transactionFormNotifierProvider.notifier).addTransaction(
        targetId: widget.targetId,
        amountStr: amountStr,
        type: _type,
        description: _descController.text,
      );
    } finally {
      // 5. PERBAIKAN POPUP (Menggunakan Navigator)
      // Modal harus selalu ditutup setelah attempt submit, baik sukses atau gagal
      if (mounted) {
        Navigator.of(context).pop(); 
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaksi tersimpan! 💰'), backgroundColor: Colors.green),
          );
        } else {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menyimpan transaksi.'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, 
        right: 16, 
        top: 16
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Catat Transaksi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          SegmentedButton<TransactionType>(
            segments: const [
              ButtonSegment(value: TransactionType.increase, label: Text("Nabung (+)")),
              ButtonSegment(value: TransactionType.decrease, label: Text("Tarik (-)")),
            ],
            selected: {_type},
            onSelectionChanged: (Set<TransactionType> newSelection) {
              setState(() {
                _type = newSelection.first;
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                 if (states.contains(MaterialState.selected)) {
                   return _type == TransactionType.increase ? Colors.green.shade100 : Colors.red.shade100;
                 }
                 return null;
              }),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            autofocus: true, // Biar langsung muncul keyboard
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: "Nominal",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          
          TextField(
            controller: _descController,
            decoration: const InputDecoration(labelText: "Catatan (Opsional)", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _type == TransactionType.increase ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Simpan Transaksi"),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}