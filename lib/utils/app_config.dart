import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lernen/utils/helpers.dart';

import 'secure_encryption_util.dart';

class AppConfig {
  static String apiUrl = "";
  static String encryptionKey = "";
  static String authBoxName = "";
  static String aiChatModel = "";
  static String aiImageModel = "";
  static String aiApiKey = "";
  static String keysUrl = "";
  static List<String> aiSupportedImageModels = [];
}

class ConfigStorage {
  static const _secureStorage = FlutterSecureStorage();

  /// Keys for secure storage
  static const _apiUrlKey = 'apiUrl';
  static const _encryptionKeyKey = 'encryptionKey';
  static const _authBoxNameKey = 'authBoxName';
  static const _aiChatModelKey = 'aiChatModel';
  static const _aiImageModelKey = 'aiImageModel';
  static const _aiApiKeyKey = 'aiApiKey';
  static const _keysUrlKey = 'keysUrl';
  static const _supportedImagesKey = 'aiSupportedImageModels';

  /// Load config from secure storage into AppConfig
  static Future<void> loadFromStorage() async {
    AppConfig.apiUrl = await _secureStorage.read(key: _apiUrlKey) ?? "";
    AppConfig.encryptionKey =
        await _secureStorage.read(key: _encryptionKeyKey) ?? "";
    AppConfig.authBoxName =
        await _secureStorage.read(key: _authBoxNameKey) ?? "";
    AppConfig.aiChatModel =
        await _secureStorage.read(key: _aiChatModelKey) ?? "";
    AppConfig.aiImageModel =
        await _secureStorage.read(key: _aiImageModelKey) ?? "";
    AppConfig.keysUrl = await _secureStorage.read(key: _keysUrlKey) ?? "";
    // Read encrypted value from secure storage
    String? storedEncrypted = await _secureStorage.read(key: _aiApiKeyKey);

    if (storedEncrypted != null) {
      AppConfig.aiApiKey = await EncryptionUtil.decryptString(storedEncrypted);
    }
    // stored list (JSON encoded), fallback to empty list
    final imagesJson =
        await _secureStorage.read(key: _supportedImagesKey) ?? "[]";
    AppConfig.aiSupportedImageModels = List<String>.from(
      jsonDecode(imagesJson),
    );
  }

  /// Save AppConfig values to secure storage
  static Future<void> saveToStorage() async {
    String plainApiKey = AppConfig.aiApiKey;

    String encryptedApiKey = await EncryptionUtil.encryptString(plainApiKey);

    await _secureStorage.write(key: _apiUrlKey, value: AppConfig.apiUrl);
    await _secureStorage.write(
      key: _encryptionKeyKey,
      value: AppConfig.encryptionKey,
    );
    await _secureStorage.write(
      key: _authBoxNameKey,
      value: AppConfig.authBoxName,
    );
    await _secureStorage.write(
      key: _aiChatModelKey,
      value: AppConfig.aiChatModel,
    );
    await _secureStorage.write(
      key: _aiImageModelKey,
      value: AppConfig.aiImageModel,
    );
    await _secureStorage.write(key: _aiApiKeyKey, value: encryptedApiKey);
    await _secureStorage.write(key: _keysUrlKey, value: AppConfig.keysUrl);
    await _secureStorage.write(
      key: _supportedImagesKey,
      value: jsonEncode(AppConfig.aiSupportedImageModels),
    );
  }
}

class ConfigService {
  /// Fetch JSON from [url] and update if different
  static Future<void> fetchAndUpdateConfig(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'code': Utils.passKey}),
      );

      // If request succeeds
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Load stored values first
        await ConfigStorage.loadFromStorage();

        // Check and update only if a value changed
        _setIfDifferent("apiUrl", data["apiUrl"] ?? "", (v) {
          AppConfig.apiUrl = v;
        });

        _setIfDifferent("encryptionKey", data["encryptionKey"] ?? "", (v) {
          AppConfig.encryptionKey = v;
        });

        _setIfDifferent("authBoxName", data["authBoxName"] ?? "", (v) {
          AppConfig.authBoxName = v;
        });

        _setIfDifferent("aiChatModel", data["aiLernenChatModel"] ?? "", (v) {
          AppConfig.aiChatModel = v;
        });

        _setIfDifferent("aiImageModel", data["aiImageModel"] ?? "", (v) {
          AppConfig.aiImageModel = v;
        });

        _setIfDifferent("aiApiKey", data["aiApiKey"] ?? "", (v) {
          AppConfig.aiApiKey = v;
        });

        _setIfDifferent("keysUrl", data["keysUrl"] ?? "", (v) {
          AppConfig.keysUrl = v;
        });

        if (data["aiSupportedImageModels"] != null &&
            data["aiSupportedImageModels"] is List) {
          final listFromServer = List<String>.from(
            (data["aiSupportedImageModels"] as List).map((e) => e.toString()),
          );
          if (!listEquals(AppConfig.aiSupportedImageModels, listFromServer)) {
            AppConfig.aiSupportedImageModels = listFromServer;
          }
        }

        // Save updated values
        await ConfigStorage.saveToStorage();
      }
    } catch (e) {
      // network failure -> keep cached values
    }
  }

  /// Update AppConfig field only if value changed
  static void _setIfDifferent(
    String key,
    String newValue,
    void Function(String) assign,
  ) {
    final dynamic oldValue = _readStoredValue(key);
    if (newValue.isNotEmpty && newValue != oldValue) {
      assign(newValue);
    }
  }

  static dynamic _readStoredValue(String key) {
    switch (key) {
      case "apiUrl":
        return AppConfig.apiUrl;
      case "encryptionKey":
        return AppConfig.encryptionKey;
      case "authBoxName":
        return AppConfig.authBoxName;
      case "aiChatModel":
        return AppConfig.aiChatModel;
      case "aiImageModel":
        return AppConfig.aiImageModel;
      case "aiApiKey":
        return AppConfig.aiApiKey;
      case "keysUrl":
        return AppConfig.keysUrl;
      default:
        return "";
    }
  }
}


// {
//   "apiUrl": "https://example.com/api",
//   "encryptionKey": "mySecretKey",
//   "authBoxName": "auth_storage",
//   "aiChatModel": "gpt-4",
//   "aiImageModel": "stable_diffusion",
//   "aiApiKey": "ai-api-key12345",
//   "keysUrl": "https://example.com/keys.json",
//   "aiSupportedImageModels": [
//     "stable_diffusion",
//     "dall-e",
//     "midjourney"
//   ]
// }




// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Load previously saved values first
//   await ConfigStorage.loadFromStorage();

//   // Attempt to fetch remote config (may fail offline)
//   await ConfigService.fetchAndUpdateConfig("https://example.com/config.json");

//   runApp(MyApp());
// }
