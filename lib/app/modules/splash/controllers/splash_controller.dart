import 'package:get/get.dart';
import 'package:techtest/app/data/repositories/auth_repository.dart';
import 'package:techtest/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final IAuthRepository authRepository;

  SplashController({required this.authRepository});

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final hasAuth = await authRepository.isAuthenticated();
    if (hasAuth) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
