import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../values/app_constants.dart';

class StorageService extends GetxService {
  final FlutterSecureStorage _secureStorage;

  StorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConstants.keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConstants.keyToken);
  }

  Future<void> saveUserData(String jsonString) async {
    await _secureStorage.write(key: AppConstants.keyUserData, value: jsonString);
  }

  Future<String?> getUserData() async {
    return await _secureStorage.read(key: AppConstants.keyUserData);
  }

  Future<void> clearSession() async {
    await _secureStorage.delete(key: AppConstants.keyToken);
    await _secureStorage.delete(key: AppConstants.keyUserData);
  }

  Future<bool> hasValidToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
