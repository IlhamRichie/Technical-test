import '../models/item_model.dart';
import '../providers/api_provider.dart';
import '../../core/services/storage_service.dart';

abstract class IItemRepository {
  Future<List<ItemModel>> getItems();
  Future<ItemModel> createItem(ItemModel item);
  Future<ItemModel> updateItem(String id, ItemModel item);
  Future<bool> deleteItem(String id);
  void setSimulatedError(bool enabled);
  void setSimulatedTimeout(bool enabled);
}

class ItemRepository implements IItemRepository {
  final ApiProvider _apiProvider;
  final StorageService _storageService;

  ItemRepository({ApiProvider? apiProvider, StorageService? storageService})
      : _apiProvider = apiProvider ?? ApiProvider(),
        _storageService = storageService ?? StorageService();

  Future<String?> _getToken() async {
    return await _storageService.getToken();
  }

  @override
  Future<List<ItemModel>> getItems() async {
    final token = await _getToken();
    return await _apiProvider.getItems(token: token);
  }

  @override
  Future<ItemModel> createItem(ItemModel item) async {
    final token = await _getToken();
    return await _apiProvider.createItem(item, token: token);
  }

  @override
  Future<ItemModel> updateItem(String id, ItemModel item) async {
    final token = await _getToken();
    return await _apiProvider.updateItem(id, item, token: token);
  }

  @override
  Future<bool> deleteItem(String id) async {
    final token = await _getToken();
    return await _apiProvider.deleteItem(id, token: token);
  }

  @override
  void setSimulatedError(bool enabled) {
    _apiProvider.simulateServerError = enabled;
  }

  @override
  void setSimulatedTimeout(bool enabled) {
    _apiProvider.simulateTimeout = enabled;
  }
}
