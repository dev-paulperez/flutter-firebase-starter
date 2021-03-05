import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Used to store and retrieve the user email address
class EmailSecureStore {
  static const String storageUserEmailAddressKey = 'userEmailAddress';
  final _secureStorage = const FlutterSecureStorage();
  Future<void> setEmail(String email) async {
    await _secureStorage.write(key: storageUserEmailAddressKey, value: email);
  }

  Future<void> deleteEmail() async {
    await _secureStorage.delete(key: storageUserEmailAddressKey);
  }

  Future<String> getEmail() async {
    return _secureStorage.read(key: storageUserEmailAddressKey);
  }
}
