import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aplikasi_targetku/core/services/user_preference_service.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _startApp() async {
    if (_formKey.currentState!.validate()) {
      // 1. Simpan Nama
      await UserPreferenceService().setUserName(_nameController.text);
      
      // 2. Set First Run jadi False
      await UserPreferenceService().completeOnboarding();

      // 3. Pindah ke Home (Replace agar tidak bisa back)
      if (mounted) {
        context.goNamed('home');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                
                // --- Ilustrasi / Ikon ---
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.rocket_launch_rounded,
                      size: 80,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // --- Teks Sambutan ---
                const Text(
                  "Selamat Datang\ndi TargetKu!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Aplikasi simpel untuk wujudkan barang impianmu satu per satu.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                
                const SizedBox(height: 40),

                // --- Input Nama ---
                const Text(
                  "Siapa nama panggilanmu?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: "Contoh: Budi",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.person_outline, color: Colors.indigo),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama tidak boleh kosong ya";
                    }
                    return null;
                  },
                ),

                const Spacer(),

                // --- Tombol Mulai ---
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _startApp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Mulai Sekarang",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}