import 'package:public_chat/_shared/data/language_support_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static PreferencesManager? _instance;

  PreferencesManager._();

  static PreferencesManager get instance {
    _instance ??= PreferencesManager._();
    return _instance!;
  }

  Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userLanguage', language);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userLanguage') ?? defaultLanguage;
  }

  getloginErrorText() {}

  // Add other methods for saving and getting data as needed
}
