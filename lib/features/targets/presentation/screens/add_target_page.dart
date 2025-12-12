import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/core/utils/platform_file_utils.dart'; // Import the new utility
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';
import 'package:aplikasi_targetku/features/targets/presentation/providers/target_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io' if (dart.library.html) 'dart:typed_data';

class AddTargetPage extends ConsumerStatefulWidget {
  // Tambahkan parameter opsional ini
  final TargetEntity? targetToEdit;

  const AddTargetPage({super.key, this.targetToEdit});

  @override
  ConsumerState<AddTargetPage> createState() => _AddTargetPageState();
}

class _AddTargetPageState extends ConsumerState<AddTargetPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _planAmountController;
  
  late PlanFrequency _selectedFrequency;
  String? _selectedImagePath;

  final _currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    // Cek apakah mode Edit atau Baru
    final t = widget.targetToEdit;
    
    _nameController = TextEditingController(text: t?.name ?? '');
    _amountController = TextEditingController(text: t != null ? _currencyFormatter.format(t.targetAmount) : '');
    _planAmountController = TextEditingController(text: t != null ? _currencyFormatter.format(t.plannedAmount) : '');

    _amountController.addListener(_formatAmount);
    _planAmountController.addListener(_formatPlanAmount);
    
    _selectedFrequency = t?.planFrequency ?? PlanFrequency.weekly;
    _selectedImagePath = t?.imageUrl;
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

  void _formatPlanAmount() {
    final text = _planAmountController.text;
    if (text.isEmpty) return;
    final plainText = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (plainText.isEmpty) return;
    final number = int.tryParse(plainText);
    if (number != null) {
      final formattedText = _currencyFormatter.format(number);
      if (text != formattedText) {
        _planAmountController.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _amountController.removeListener(_formatAmount);
    _planAmountController.removeListener(_formatPlanAmount);
    _nameController.dispose();
    _amountController.dispose();
    _planAmountController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      bool success;
      
      final amount = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final plannedAmount = _planAmountController.text.replaceAll(RegExp(r'[^0-9]'), '');
      
      if (widget.targetToEdit == null) {
        // MODE BUAT BARU
        success = await ref.read(targetFormNotifierProvider.notifier).createTarget(
              name: _nameController.text,
              amountStr: amount,
              plannedAmountStr: plannedAmount,
              frequency: _selectedFrequency,
              imagePath: _selectedImagePath,
            );
      } else {
        // MODE EDIT
        success = await ref.read(targetFormNotifierProvider.notifier).editTarget(
              originalTarget: widget.targetToEdit!,
              name: _nameController.text,
              amountStr: amount,
              plannedAmountStr: plannedAmount,
              frequency: _selectedFrequency,
              imagePath: _selectedImagePath,
            );
      }

      if (success && mounted) {
        context.pop(); 
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text(widget.targetToEdit == null ? 'Target dibuat! 🚀' : 'Target diperbarui! ✅'), 
             backgroundColor: Colors.green
           ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(targetFormNotifierProvider).isLoading;
    final isEdit = widget.targetToEdit != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Target' : 'Buat Target Baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. Image Picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade400),
                  image: _selectedImagePath != null && fileExistsSync(_selectedImagePath)
                      ? DecorationImage(
                          image: (
                              _selectedImagePath!.startsWith('http://') ||
                              _selectedImagePath!.startsWith('https://')
                              ? NetworkImage(_selectedImagePath!)
                              : FileImage(File(_selectedImagePath!))
                          ) as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _selectedImagePath == null || !fileExistsSync(_selectedImagePath)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Pilih Foto Impianmu"),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            // 2. Input Nama
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Target', border: OutlineInputBorder(), prefixIcon: Icon(Icons.stars)),
              validator: (val) => val!.isEmpty ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // 3. Input Target Uang
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Rupiah', border: OutlineInputBorder(), prefixIcon: Icon(Icons.monetization_on)),
              validator: (val) => val!.isEmpty ? 'Nominal wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            
            // 4. Frekuensi
            const Text("Rencana Menabung", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildChip(PlanFrequency.daily, "Harian"),
                const SizedBox(width: 8),
                _buildChip(PlanFrequency.weekly, "Mingguan"),
                const SizedBox(width: 8),
                _buildChip(PlanFrequency.monthly, "Bulanan"),
              ],
            ),
            const SizedBox(height: 16),

            // 5. Nominal Rencana
            TextFormField(
              controller: _planAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Nominal Rencana', border: OutlineInputBorder(), prefixIcon: Icon(Icons.savings)),
              validator: (val) => val!.isEmpty ? 'Rencana wajib diisi' : null,
            ),
            const SizedBox(height: 32),

            // 6. Tombol Simpan
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEdit ? 'Simpan Perubahan' : 'Mulai Target Ini! 🚀'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildChip(PlanFrequency value, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedFrequency == value,
      onSelected: (bool selected) { if (selected) setState(() => _selectedFrequency = value); },
    );
  }
}