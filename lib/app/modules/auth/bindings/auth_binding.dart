import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAuthRepository>(() => AuthRepository());
    Get.put<AuthController>(AuthController(authRepository: Get.find<IAuthRepository>()));
  }
}
