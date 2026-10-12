import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/item_model.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Management (CRUD)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Obx(() {
              final user = controller.currentUser.value;
              return Text(
                user != null ? '${user.name} (${user.email})' : 'Sesi Aktif',
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              );
            }),
          ],
        ),
        actions: [
          IconButton(
            key: const Key('logout_button'),
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFF87171)),
            onPressed: controller.confirmLogout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('add_item_fab'),
        onPressed: controller.navigateToAddItem,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Data', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          _buildSimulationBanner(),
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.items.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
                );
              }

              if (controller.errorMessage.isNotEmpty && controller.items.isEmpty) {
                return _buildErrorState();
              }

              final displayItems = controller.filteredItems;
              if (displayItems.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.fetchItems,
                color: const Color(0xFF38BDF8),
                backgroundColor: const Color(0xFF1E293B),
                child: ListView.separated(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 84),
                  itemCount: displayItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = displayItems[index];
                    return _buildItemCard(item);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationBanner() {
    return Container(
      color: const Color(0xFF162032),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.tune_rounded, size: 18, color: Color(0xFFF59E0B)),
          const SizedBox(width: 8),
          const Text(
            'Simulasi Error:',
            style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Row(
            children: [
              const Text('500', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
              Obx(() => Switch(
                    value: controller.simulateServerError.value,
                    onChanged: controller.toggleSimulateError,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: const Color(0xFFEF4444),
                  )),
            ],
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              const Text('Timeout', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
              Obx(() => Switch(
                    value: controller.simulateTimeout.value,
                    onChanged: controller.toggleSimulateTimeout,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: const Color(0xFFF59E0B),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.setSearchQuery,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Cari data...',
          hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
          suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
                  onPressed: controller.clearSearch,
                )
              : const SizedBox.shrink()),
          filled: true,
          fillColor: const Color(0xFF1E293B),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF38BDF8)),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(ItemModel item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.category,
                style: const TextStyle(color: Color(0xFF60A5FA), fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.description,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
              const SizedBox(height: 8),
              Text(
                'Rp ${item.price.toStringAsFixed(2)}',
                style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Color(0xFF38BDF8), size: 20),
              tooltip: 'Edit',
              onPressed: () => controller.navigateToEditItem(item),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFF87171), size: 20),
              tooltip: 'Hapus',
              onPressed: () => controller.confirmAndDeleteItem(item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 64, color: Color(0xFF475569)),
            const SizedBox(height: 16),
            const Text(
              'Belum ada data tersedia',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Silakan tekan tombol tambah untuk membuat entri baru.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 64, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: controller.fetchItems,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
