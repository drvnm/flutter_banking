import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class PrefHelper {
  final EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();

  Future<void> setValue(String key, String value) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString(key, value);
  }

  Future<String?> getValue(String key) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getString(key);
  }

  Future<void> removeValue(String key) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.remove(key);
  }

  Future<bool> setValueEnc(String key, String value) async {
    return await encryptedSharedPreferences.setString(key, value);
  }

  Future<String?> getValueEnc(String key) async {
    return await encryptedSharedPreferences.getString(key);
  }

  Future<bool?> clear() async {
    return await encryptedSharedPreferences.clear();
  }
}
