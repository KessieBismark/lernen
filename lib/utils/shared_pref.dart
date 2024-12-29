import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  // Private constructor to prevent instantiation
  SharedPreferencesUtil._();

  // String Operations
  static Future<bool> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Integer Operations
  static Future<bool> saveInteger(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(key, value);
  }

  static Future<int?> getInteger(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // Double Operations
  static Future<bool> saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  // Boolean Operations
  static Future<bool> saveBoolean(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }

  static Future<bool> getBoolean(String key,
      {bool defaultValue = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(key) ?? defaultValue;
    } catch (e) {
      print('Error accessing SharedPreferences: $e');
      return defaultValue;
    }
  }

  // List of Strings Operations
  static Future<bool> saveStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(key, value);
  }

  static Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  // Remove a specific key
  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  // Clear all preferences
  static Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}

// // Example Usage
// class ExampleUsage {
//   void exampleMethods() async {
//     // Saving data
//     await SharedPreferencesUtil.saveString('username', 'johndoe');
//     await SharedPreferencesUtil.saveInteger('age', 30);
//     await SharedPreferencesUtil.saveBoolean('isLoggedIn', true);
//     await SharedPreferencesUtil.saveStringList(
//         'hobbies', ['reading', 'coding']);

//     // Retrieving data
//     String? username = await SharedPreferencesUtil.getString('username');
//     int? age = await SharedPreferencesUtil.getInteger('age');
//     bool? isLoggedIn = await SharedPreferencesUtil.getBoolean('isLoggedIn');
//     List<String>? hobbies =
//         await SharedPreferencesUtil.getStringList('hobbies');

//     // Removing a specific key
//     await SharedPreferencesUtil.remove('username');

//     // Clearing all preferences
//     await SharedPreferencesUtil.clear();
//   }
// }
