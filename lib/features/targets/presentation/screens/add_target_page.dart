import 'dart:io'; 
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/core/utils/platform_file_utils.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';
import 'package:aplikasi_targetku/features/targets/presentation/providers/target_form_provider.dart';

class AddTargetPage extends ConsumerStatefulWidget {
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
    final t = widget.targetToEdit;
    
    _nameController = TextEditingController(text: t?.name ?? '');
    _amountController = TextEditingController(
      text: t != null ? _currencyFormatter.format(t.targetAmount) : ''
    );
    _planAmountController = TextEditingController(
      text: t != null ? _currencyFormatter.format(t.plannedAmount) : ''
    );

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
        success = await ref.read(targetFormNotifierProvider.notifier).createTarget(
              name: _nameController.text,
              amountStr: amount,
              plannedAmountStr: plannedAmount,
              frequency: _selectedFrequency,
              imagePath: _selectedImagePath,
            );
      } else {
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

  // Helper untuk membuat Input Field yang cantik
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.indigo), // Warna ikon ungu
      filled: true,
      fillColor: Colors.grey.shade50, // Background abu-abu muda
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // Hilangkan garis border default
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.indigo, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(targetFormNotifierProvider).isLoading;
    final isEdit = widget.targetToEdit != null;

    ImageProvider? imageProvider;
    if (_selectedImagePath != null) {
      if (kIsWeb) {
        imageProvider = NetworkImage(_selectedImagePath!);
      } else {
        if (fileExistsSync(_selectedImagePath)) {
          imageProvider = FileImage(File(_selectedImagePath!));
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white, // Background putih bersih
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Target' : 'Buat Target Baru',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // --- IMAGE PICKER ---
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50, // Warna ungu sangat muda
                  borderRadius: BorderRadius.circular(20),
                  image: imageProvider != null
                      ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                      : null,
                  border: imageProvider == null 
                    ? Border.all(color: Colors.indigo.shade100, width: 2) // Border halus
                    : null,
                ),
                child: imageProvider == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_rounded, size: 48, color: Colors.indigo.shade300),
                          const SizedBox(height: 12),
                          Text(
                            "Pilih Foto Impianmu",
                            style: TextStyle(
                              color: Colors.indigo.shade300, 
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 30),

            // --- FORM INPUT ---
            TextFormField(
              controller: _nameController,
              decoration: _buildInputDecoration('Nama Target', Icons.stars_rounded),
              validator: (val) => val!.isEmpty ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration('Target Rupiah', Icons.monetization_on_outlined),
              validator: (val) => val!.isEmpty ? 'Nominal wajib diisi' : null,
            ),
            const SizedBox(height: 30),
            
            // --- FREKUENSI ---
            const Text("Rencana Menabung", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildChip(PlanFrequency.daily, "Harian"),
                  const SizedBox(width: 10),
                  _buildChip(PlanFrequency.weekly, "Mingguan"),
                  const SizedBox(width: 10),
                  _buildChip(PlanFrequency.monthly, "Bulanan"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _planAmountController,
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration('Nominal per Periode', Icons.savings_outlined),
              validator: (val) => val!.isEmpty ? 'Rencana wajib diisi' : null,
            ),
            const SizedBox(height: 40),

            // --- TOMBOL SIMPAN ---
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo, 
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        isEdit ? 'Simpan Perubahan' : 'Mulai Target Ini! 🚀',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildChip(PlanFrequency value, String label) {
    final isSelected = _selectedFrequency == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.indigo,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.bold
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? Colors.indigo : Colors.grey.shade300),
      ),
      onSelected: (bool selected) { if (selected) setState(() => _selectedFrequency = value); },
    );
  }
}