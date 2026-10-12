import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/values/app_constants.dart';
import '../models/item_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiProvider {
  final http.Client client;
  final String baseUrl;
  bool simulateServerError = false;
  bool simulateTimeout = false;

  final List<ItemModel> _mockDatabase = [
    ItemModel(
      id: '1',
      title: 'Enterprise Single Sign-On Module',
      description: 'OAuth2 & OIDC standard identity management',
      category: 'Security',
      price: 199.99,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ItemModel(
      id: '2',
      title: 'Secure Keychain Storage Adapter',
      description: 'Hardware-backed encrypted session persistence',
      category: 'Storage',
      price: 89.50,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ItemModel(
      id: '3',
      title: 'OpenAPI Spec Generator & Validator',
      description: 'Automated contract testing and schema validation',
      category: 'Development',
      price: 149.00,
      createdAt: DateTime.now(),
    ),
  ];

  ApiProvider({http.Client? client, String? baseUrl})
      : client = client ?? http.Client(),
        baseUrl = baseUrl ?? AppConstants.baseUrl;

  Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': AppConstants.apiKey,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  void _checkSimulatedErrors() {
    if (simulateTimeout) {
      throw TimeoutException('Koneksi ke server timeout (Simulasi)');
    }
    if (simulateServerError) {
      throw ApiException('Terjadi kesalahan internal pada server [500] (Simulasi)', 500);
    }
  }

  Future<List<ItemModel>> getItems({String? token}) async {
    _checkSimulatedErrors();

    if (AppConstants.enableMockFallback) {
      await Future.delayed(const Duration(milliseconds: 400));
      return List<ItemModel>.from(_mockDatabase);
    }

    try {
      final response = await client
          .get(Uri.parse('$baseUrl/items'), headers: _headers(token))
          .timeout(AppConstants.requestTimeout);

      return _handleResponse(response, (body) {
        final List<dynamic> data = jsonDecode(body);
        return data.map((json) => ItemModel.fromJson(json)).toList();
      });
    } on SocketException {
      throw ApiException('Tidak dapat terhubung ke server. Periksa koneksi internet.');
    } on TimeoutException {
      throw ApiException('Permintaan ke server memakan waktu terlalu lama (Timeout).');
    }
  }

  Future<ItemModel> createItem(ItemModel item, {String? token}) async {
    _checkSimulatedErrors();

    if (AppConstants.enableMockFallback) {
      await Future.delayed(const Duration(milliseconds: 350));
      final newItem = item.copyWith(
        id: (DateTime.now().millisecondsSinceEpoch).toString(),
        createdAt: DateTime.now(),
      );
      _mockDatabase.insert(0, newItem);
      return newItem;
    }

    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/items'),
            headers: _headers(token),
            body: jsonEncode(item.toJson()),
          )
          .timeout(AppConstants.requestTimeout);

      return _handleResponse(response, (body) => ItemModel.fromJson(jsonDecode(body)));
    } on SocketException {
      throw ApiException('Tidak dapat terhubung ke server. Periksa koneksi internet.');
    } on TimeoutException {
      throw ApiException('Permintaan ke server memakan waktu terlalu lama (Timeout).');
    }
  }

  Future<ItemModel> updateItem(String id, ItemModel item, {String? token}) async {
    _checkSimulatedErrors();

    if (AppConstants.enableMockFallback) {
      await Future.delayed(const Duration(milliseconds: 350));
      final index = _mockDatabase.indexWhere((element) => element.id == id);
      if (index == -1) {
        throw ApiException('Data tidak ditemukan [404]', 404);
      }
      final updated = item.copyWith(id: id);
      _mockDatabase[index] = updated;
      return updated;
    }

    try {
      final response = await client
          .put(
            Uri.parse('$baseUrl/items/$id'),
            headers: _headers(token),
            body: jsonEncode(item.toJson()),
          )
          .timeout(AppConstants.requestTimeout);

      return _handleResponse(response, (body) => ItemModel.fromJson(jsonDecode(body)));
    } on SocketException {
      throw ApiException('Tidak dapat terhubung ke server. Periksa koneksi internet.');
    } on TimeoutException {
      throw ApiException('Permintaan ke server memakan waktu terlalu lama (Timeout).');
    }
  }

  Future<bool> deleteItem(String id, {String? token}) async {
    _checkSimulatedErrors();

    if (AppConstants.enableMockFallback) {
      await Future.delayed(const Duration(milliseconds: 300));
      final index = _mockDatabase.indexWhere((element) => element.id == id);
      if (index == -1) {
        throw ApiException('Data tidak ditemukan [404]', 404);
      }
      _mockDatabase.removeAt(index);
      return true;
    }

    try {
      final response = await client
          .delete(Uri.parse('$baseUrl/items/$id'), headers: _headers(token))
          .timeout(AppConstants.requestTimeout);

      return _handleResponse(response, (_) => true);
    } on SocketException {
      throw ApiException('Tidak dapat terhubung ke server. Periksa koneksi internet.');
    } on TimeoutException {
      throw ApiException('Permintaan ke server memakan waktu terlalu lama (Timeout).');
    }
  }

  T _handleResponse<T>(http.Response response, T Function(String body) parser) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return parser(response.body);
    } else if (response.statusCode == 400) {
      throw ApiException('Permintaan tidak valid: ${_extractErrorMessage(response.body)}', 400);
    } else if (response.statusCode == 401) {
      throw ApiException('Sesi telah berakhir atau tidak sah. Silakan login kembali.', 401);
    } else if (response.statusCode == 404) {
      throw ApiException('Sumber daya tidak ditemukan pada server [404]', 404);
    } else if (response.statusCode >= 500) {
      throw ApiException('Terjadi gangguan pada server [500]. Coba beberapa saat lagi.', response.statusCode);
    } else {
      throw ApiException('Terjadi kesalahan dengan kode ${response.statusCode}');
    }
  }

  String _extractErrorMessage(String body) {
    try {
      final data = jsonDecode(body);
      if (data is Map && data.containsKey('message')) {
        return data['message'].toString();
      }
    } catch (_) {}
    return 'Bad request';
  }
}
