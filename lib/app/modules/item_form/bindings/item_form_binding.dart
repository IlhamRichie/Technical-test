import 'package:get/get.dart';
import '../../../data/repositories/item_repository.dart';
import '../controllers/item_form_controller.dart';

class ItemFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IItemRepository>(() => ItemRepository());
    Get.put<ItemFormController>(
      ItemFormController(itemRepository: Get.find<IItemRepository>()),
    );
  }
}
