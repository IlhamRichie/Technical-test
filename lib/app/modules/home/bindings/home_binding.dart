import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAuthRepository>(() => AuthRepository());
    Get.lazyPut<IItemRepository>(() => ItemRepository());
    Get.put<HomeController>(
      HomeController(
        itemRepository: Get.find<IItemRepository>(),
        authRepository: Get.find<IAuthRepository>(),
      ),
    );
  }
}
