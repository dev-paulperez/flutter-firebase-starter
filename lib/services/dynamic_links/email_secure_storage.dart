import 'package:shared_preferences/shared_preferences.dart';

/// Used to store and retrieve the user email address
class EmailSecureStore {
  static const String storageUserEmailAddressKey = 'userEmailAddress';

  Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageUserEmailAddressKey, email);
  }

  Future<void> deleteEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageUserEmailAddressKey);
  }

  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(storageUserEmailAddressKey);
  }
}
