import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techtest/app/data/models/item_model.dart';
import 'package:techtest/app/data/models/user_model.dart';
import 'package:techtest/app/data/repositories/auth_repository.dart';
import 'package:techtest/app/data/repositories/item_repository.dart';
import 'package:techtest/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final IItemRepository itemRepository;
  final IAuthRepository authRepository;

  final items = <ItemModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final currentUser = Rxn<UserModel>();

  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  final simulateServerError = false.obs;
  final simulateTimeout = false.obs;

  HomeController({
    required this.itemRepository,
    required this.authRepository,
  });

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
    fetchItems();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  List<ItemModel> get filteredItems {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> loadCurrentUser() async {
    final user = await authRepository.getCurrentUser();
    currentUser.value = user;
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetched = await itemRepository.getItems();
      items.assignAll(fetched);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Gagal Memuat Data',
        errorMessage.value,
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

  void toggleSimulateError(bool value) {
    simulateServerError.value = value;
    itemRepository.setSimulatedError(value);
  }

  void toggleSimulateTimeout(bool value) {
    simulateTimeout.value = value;
    itemRepository.setSimulatedTimeout(value);
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  Future<void> confirmAndDeleteItem(ItemModel item) async {
    final bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Konfirmasi Hapus',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${item.title}"? Tindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(color: Color(0xFFCBD5E1)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Get.back(result: true),
            child: const Text('Hapus Data'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteItem(item.id);
    }
  }

  Future<void> _deleteItem(String id) async {
    try {
      isLoading.value = true;
      await itemRepository.deleteItem(id);
      items.removeWhere((element) => element.id == id);
      Get.snackbar(
        'Berhasil',
        'Data berhasil dihapus dari server.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal Menghapus',
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

  Future<void> confirmLogout() async {
    final bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Keluar dari Aplikasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Sesi Anda akan dihapus dari Secure Storage. Anda harus login kembali.',
          style: TextStyle(color: Color(0xFFCBD5E1)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Get.back(result: true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await authRepository.logout();
      Get.offAllNamed(Routes.AUTH);
    }
  }

  void navigateToAddItem() async {
    final result = await Get.toNamed(Routes.ITEM_FORM);
    if (result == true) {
      await fetchItems();
    }
  }

  void navigateToEditItem(ItemModel item) async {
    final result = await Get.toNamed(Routes.ITEM_FORM, arguments: item);
    if (result == true) {
      await fetchItems();
    }
  }
}
