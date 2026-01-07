import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:aplikasi_targetku/features/settings/presentation/providers/user_profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Isi form dengan nama yang sekarang
    final currentName = ref.read(userNameProvider);
    _controller.text = currentName;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveName() {
    if (_formKey.currentState!.validate()) {
      // Panggil Provider untuk update nama
      ref.read(userNameProvider.notifier).updateName(_controller.text);
      
      // Kembali ke halaman sebelumnya & kasih notif
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama berhasil diubah! ✨"), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ganti Nama Panggilan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _controller,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: "Masukkan nama baru",
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.indigo),
                  ),
                  prefixIcon: const Icon(Icons.person_outline, color: Colors.indigo),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? "Nama tidak boleh kosong" : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveName,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Simpan Perubahan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}