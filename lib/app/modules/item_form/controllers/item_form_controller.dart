import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techtest/app/core/utils/validators.dart';
import 'package:techtest/app/data/models/item_model.dart';
import 'package:techtest/app/data/repositories/item_repository.dart';

class ItemFormController extends GetxController {
  final IItemRepository itemRepository;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();

  final isLoading = false.obs;
  final isEditMode = false.obs;
  ItemModel? existingItem;

  ItemFormController({required this.itemRepository});

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ItemModel) {
      existingItem = args;
      isEditMode.value = true;
      titleController.text = args.title;
      descriptionController.text = args.description;
      categoryController.text = args.category;
      priceController.text = args.price.toString();
    } else {
      categoryController.text = 'General';
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    priceController.dispose();
    super.onClose();
  }

  Future<void> saveItem() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      final price = double.tryParse(priceController.text.trim()) ?? 0.0;

      if (isEditMode.value && existingItem != null) {
        final updated = existingItem!.copyWith(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          category: categoryController.text.trim(),
          price: price,
        );
        await itemRepository.updateItem(existingItem!.id, updated);
        Get.back(result: true);
        Get.snackbar(
          'Berhasil Diperbarui',
          'Perubahan data berhasil disimpan.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
      } else {
        final newItem = ItemModel(
          id: '',
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          category: categoryController.text.trim(),
          price: price,
        );
        await itemRepository.createItem(newItem);
        Get.back(result: true);
        Get.snackbar(
          'Berhasil Ditambahkan',
          'Data baru berhasil tersimpan.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Menyimpan Data',
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

  String? validateRequired(String? value, String fieldName) =>
      Validators.validateRequired(value, fieldName);

  String? validatePrice(String? value) =>
      Validators.validateNumber(value, 'Harga');
}
