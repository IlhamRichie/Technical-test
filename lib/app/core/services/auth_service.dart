import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/models/user_model.dart';
import '../values/app_constants.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storageService;
  bool _isGoogleInitialized = false;

  AuthService({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  Future<void> _ensureGoogleInitialized() async {
    if (_isGoogleInitialized) return;
    try {
      await GoogleSignIn.instance.initialize(
        clientId: AppConstants.googleClientId.isNotEmpty
            ? AppConstants.googleClientId
            : null,
      );
      _isGoogleInitialized = true;
    } catch (_) {
      // Ignored for environments without native Google Services configuration
    }
  }

  Future<UserModel> signInWithGoogle({bool forceMock = false}) async {
    if (!forceMock && AppConstants.googleClientId.isNotEmpty) {
      try {
        await _ensureGoogleInitialized();
        final GoogleSignInAccount account = await GoogleSignIn.instance.authenticate();
        final token = account.authentication.idToken ??
            'google-oauth-token-${DateTime.now().millisecondsSinceEpoch}';

        final user = UserModel(
          id: account.id,
          name: account.displayName ?? 'Google User',
          email: account.email,
          avatarUrl: account.photoUrl,
          token: token,
        );

        await _persistUserSession(user);
        return user;
      } catch (e) {
        return _mockGoogleSignIn();
      }
    } else {
      return _mockGoogleSignIn();
    }
  }

  Future<UserModel> _mockGoogleSignIn() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final token = 'jwt-secure-google-sso-${DateTime.now().millisecondsSinceEpoch}';
    final user = UserModel(
      id: 'google-uid-10293847',
      name: 'M. Ilham Rigan Agachi',
      email: 'maachigan@gmail.com',
      avatarUrl: 'https://avatars.githubusercontent.com/u/maachigan',
      token: token,
    );
    await _persistUserSession(user);
    return user;
  }

  Future<UserModel> signInWithEmailPassword(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final token = 'jwt-email-token-${DateTime.now().millisecondsSinceEpoch}';
    final user = UserModel(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@').first,
      email: email,
      token: token,
    );
    await _persistUserSession(user);
    return user;
  }

  Future<void> _persistUserSession(UserModel user) async {
    if (user.token != null) {
      await _storageService.saveToken(user.token!);
    }
    await _storageService.saveUserData(jsonEncode(user.toJson()));
  }

  Future<UserModel?> getSavedUser() async {
    final userData = await _storageService.getUserData();
    if (userData != null && userData.isNotEmpty) {
      try {
        return UserModel.fromJson(jsonDecode(userData));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    await _storageService.clearSession();
  }
}
