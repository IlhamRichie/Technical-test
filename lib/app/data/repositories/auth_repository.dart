import '../models/user_model.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/storage_service.dart';

abstract class IAuthRepository {
  Future<UserModel> loginWithGoogle();
  Future<UserModel> loginWithEmail(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<bool> isAuthenticated();
}

class AuthRepository implements IAuthRepository {
  final AuthService _authService;
  final StorageService _storageService;

  AuthRepository({AuthService? authService, StorageService? storageService})
      : _authService = authService ?? AuthService(),
        _storageService = storageService ?? StorageService();

  @override
  Future<UserModel> loginWithGoogle() {
    return _authService.signInWithGoogle();
  }

  @override
  Future<UserModel> loginWithEmail(String email, String password) {
    return _authService.signInWithEmailPassword(email, password);
  }

  @override
  Future<void> logout() {
    return _authService.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() {
    return _authService.getSavedUser();
  }

  @override
  Future<bool> isAuthenticated() {
    return _storageService.hasValidToken();
  }
}
