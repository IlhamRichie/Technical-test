import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techtest/app/core/utils/validators.dart';
import 'package:techtest/app/data/repositories/auth_repository.dart';
import 'package:techtest/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final IAuthRepository authRepository;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final simulateServerError = false.obs;

  AuthController({required this.authRepository});

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleSimulateError(bool value) {
    simulateServerError.value = value;
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      if (simulateServerError.value) {
        await Future.delayed(const Duration(milliseconds: 500));
        throw Exception('Simulasi: Server SSO menolak otorisasi OAuth (Error 403).');
      }

      final user = await authRepository.loginWithGoogle();
      Get.snackbar(
        'Berhasil Masuk',
        'Selamat datang, ${user.name}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      );
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        'Autentikasi Gagal',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithEmail() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      if (simulateServerError.value) {
        await Future.delayed(const Duration(milliseconds: 600));
        throw Exception('Simulasi: Kredensial tidak valid atau akun dinonaktifkan (Error 401).');
      }

      final user = await authRepository.loginWithEmail(
        emailController.text.trim(),
        passwordController.text,
      );

      Get.snackbar(
        'Berhasil Masuk',
        'Selamat datang kembali, ${user.name}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      );
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        'Login Gagal',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? validateEmail(String? value) => Validators.validateEmail(value);

  String? validatePassword(String? value) => Validators.validatePassword(value);
}
