import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAuthRepository>(() => AuthRepository());
    Get.put<SplashController>(SplashController(authRepository: Get.find<IAuthRepository>()));
  }
}
