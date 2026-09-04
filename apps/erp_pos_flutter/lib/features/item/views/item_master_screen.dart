// D:\erp_pos_system\apps\erp_pos_flutter\lib\features\item\views\item_master_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/item_provider.dart';

class ItemMasterScreen extends ConsumerStatefulWidget {
  const ItemMasterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ItemMasterScreen> createState() => _ItemMasterScreenState();
}

class _ItemMasterScreenState extends ConsumerState<ItemMasterScreen> {
  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูล State จาก Riverpod Provider
    final itemState = ref.watch(itemProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการข้อมูลสินค้า (Item Master)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(itemProvider.notifier).fetchItems(),
          ),
        ],
      ),
      body: itemState.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('ไม่พบข้อมูลสินค้า'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('รหัส: ${item.code} | ราคา: ${item.price} บาท'),
                trailing: Text('คงเหลือ: ${item.stock}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('เกิดข้อผิดพลาด: $error'),
        ),
      ),
    );
  }
}