import 'package:shared_preferences/shared_preferences.dart';

class UserPreferenceService {
  static const String keyIsPremium = 'is_premium';
  static const String keyUserName = 'user_name'; // Key baru
  static const String keyIsFirstRun = 'is_first_run'; // Key baru
  
  static final UserPreferenceService _instance = UserPreferenceService._internal();
  factory UserPreferenceService() => _instance;
  UserPreferenceService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- PREMIUM STATUS ---
  bool get isPremium => _prefs.getBool(keyIsPremium) ?? false;
  Future<void> setPremium(bool value) async {
    await _prefs.setBool(keyIsPremium, value);
  }

  // --- USER PROFILE ---
  String get userName => _prefs.getString(keyUserName) ?? "Teman"; // Default "Teman"
  
  Future<void> setUserName(String name) async {
    await _prefs.setString(keyUserName, name);
  }

  // --- FIRST RUN CHECK ---
  // Default true (artinya ini pertama kali install)
  bool get isFirstRun => _prefs.getBool(keyIsFirstRun) ?? true;

  Future<void> completeOnboarding() async {
    await _prefs.setBool(keyIsFirstRun, false);
  }
}