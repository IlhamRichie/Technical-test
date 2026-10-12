import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://api.juber-technical.test/v1';

  static String get apiKey => dotenv.env['API_KEY'] ?? 'mock-secure-api-key';

  static String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? '';

  static bool get enableMockFallback =>
      dotenv.env['ENABLE_MOCK_FALLBACK']?.toLowerCase() == 'true';

  static const String keyToken = 'auth_token';
  static const String keyUserData = 'auth_user_data';
  static const Duration requestTimeout = Duration(seconds: 10);
}
