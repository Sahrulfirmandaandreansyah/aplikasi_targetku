import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:aplikasi_targetku/core/services/user_preference_service.dart';

part 'user_settings_provider.g.dart';

@riverpod
class IsPremium extends _$IsPremium {
  @override
  bool build() {
    // Ambil data awal dari SharedPreferences
    // Pastikan service sudah di-init di main.dart
    return UserPreferenceService().isPremium;
  }

  // Fungsi untuk meng-upgrade user (Simulasi pembelian / Restore)
  Future<void> setPremiumStatus(bool value) async {
    await UserPreferenceService().setPremium(value);
    state = value; // Update state agar UI berubah otomatis
  }
}