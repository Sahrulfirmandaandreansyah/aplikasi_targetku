import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/features/transactions/presentation/providers/transaction_form_provider.dart';

class AddTransactionModal extends ConsumerStatefulWidget {
  final int targetId;
  final double currentBalance; 
  final double targetAmount;   

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
  
  // Formatter untuk validasi & display
  final _currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    // Tambahkan listener untuk format otomatis saat mengetik
    _amountController.addListener(_formatAmount);
  }

  // Logic Format Angka (Rp 10.000)
  void _formatAmount() {
    final text = _amountController.text;
    if (text.isEmpty) return;
    
    // Hapus karakter non-digit
    final plainText = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (plainText.isEmpty) return;
    
    final number = int.tryParse(plainText);
    if (number != null) {
      final formattedText = _currencyFormatter.format(number);
      
      // Update text hanya jika berbeda agar kursor tidak lompat
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
    // 1. Parsing Input (Hapus format Rp sebelum diproses)
    final amountStr = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final double amount = double.tryParse(amountStr) ?? 0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan nominal > 0')));
      return;
    }

    // 2. VALIDASI MAKSIMUM (Mencegah Kelebihan Bayar)
    if (_type == TransactionType.increase) {
      final sisaButuh = widget.targetAmount - widget.currentBalance;
      // Beri toleransi sedikit (misal floating point error), tapi prinsipnya tidak boleh lebih
      if (amount > sisaButuh) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ups! Cukup ${_currencyFormatter.format(sisaButuh)} lagi untuk selesai.'),
            backgroundColor: Colors.orange,
          )
        );
        return; // Batalkan proses
      }
    }
    // 3. VALIDASI PENARIKAN (Mencegah Saldo Minus)
    else if (_type == TransactionType.decrease) {
      if (amount > widget.currentBalance) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saldo tidak cukup untuk ditarik.')));
        return;
      }
    }

    // 4. Eksekusi Simpan
    bool success = false;
    try {
      success = await ref.read(transactionFormNotifierProvider.notifier).addTransaction(
        targetId: widget.targetId,
        amountStr: amountStr, // Kirim angka murni string
        type: _type,
        description: _descController.text,
      );
    } catch (e) {
      // Catch unexpected error
      success = false;
    } finally {
      // 5. Handling UI Setelah Proses
      if (mounted) {
        Navigator.of(context).pop(); // Tutup Modal Dulu
        
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
              // Tidak perlu prefixText 'Rp ' di sini karena sudah ada di controller valuenya
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