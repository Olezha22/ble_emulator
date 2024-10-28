import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const _connectionNameKey = 'connection_name';
  static const _uuidKey = 'uuid';

  Future<void> saveSettings(String connectionName, String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_connectionNameKey, connectionName);
    await prefs.setString(_uuidKey, uuid);
  }


  Future<String?> getConnectionName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_connectionNameKey);
  }


  Future<String?> getUUID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_uuidKey);
  }
}
