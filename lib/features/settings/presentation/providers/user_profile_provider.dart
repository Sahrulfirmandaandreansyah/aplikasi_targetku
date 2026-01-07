import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:aplikasi_targetku/core/services/user_preference_service.dart';

part 'user_profile_provider.g.dart';

@riverpod
class UserName extends _$UserName {
  @override
  String build() {
    // Ambil data awal dari penyimpanan lokal
    return UserPreferenceService().userName;
  }

  Future<void> updateName(String newName) async {
    // 1. Simpan ke HP
    await UserPreferenceService().setUserName(newName);
    // 2. Update State (agar UI berubah otomatis)
    state = newName;
  }
}