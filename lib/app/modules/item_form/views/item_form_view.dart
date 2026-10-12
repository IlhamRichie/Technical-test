import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/item_form_controller.dart';

class ItemFormView extends GetView<ItemFormController> {
  const ItemFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Obx(() => Text(
              controller.isEditMode.value ? 'Edit Data' : 'Tambah Data Baru',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      key: const Key('item_title_field'),
                      controller: controller.titleController,
                      style: const TextStyle(color: Colors.white),
                      validator: (val) => controller.validateRequired(val, 'Judul'),
                      decoration: _inputDecoration(
                        label: 'Judul Item',
                        hint: 'Masukkan nama/judul item',
                        icon: Icons.title_rounded,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      key: const Key('item_category_field'),
                      controller: controller.categoryController,
                      style: const TextStyle(color: Colors.white),
                      validator: (val) => controller.validateRequired(val, 'Kategori'),
                      decoration: _inputDecoration(
                        label: 'Kategori',
                        hint: 'Security, Cloud, DevOps, dll',
                        icon: Icons.category_outlined,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      key: const Key('item_price_field'),
                      controller: controller.priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      validator: controller.validatePrice,
                      decoration: _inputDecoration(
                        label: 'Harga (IDR / USD)',
                        hint: 'Contoh: 150000 atau 99.5',
                        icon: Icons.attach_money_rounded,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      key: const Key('item_description_field'),
                      controller: controller.descriptionController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      validator: (val) => controller.validateRequired(val, 'Deskripsi'),
                      decoration: _inputDecoration(
                        label: 'Deskripsi Detail',
                        hint: 'Keterangan lengkap tentang data ini',
                        icon: Icons.description_outlined,
                      ),
                    ),
                    const SizedBox(height: 28),

                    Obx(() => ElevatedButton(
                          key: const Key('save_item_button'),
                          onPressed: controller.isLoading.value ? null : controller.saveItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  controller.isEditMode.value ? 'Simpan Perubahan' : 'Tambah Data',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
      hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFF94A3B8)),
      filled: true,
      fillColor: const Color(0xFF1E293B),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
    );
  }
}
