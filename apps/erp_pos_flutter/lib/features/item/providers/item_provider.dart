// D:\erp_pos_system\apps\erp_pos_flutter\lib\features\item\providers\item_provider.dart
// หน้าที่: จัดการ State ข้อมูล Item Master โดยใช้ AsyncNotifier (Riverpod Generator)

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/item_model.dart';
import '../repositories/item_repository.dart';

part 'item_provider.g.dart';

@riverpod
class ItemNotifier extends _$ItemNotifier {
  @override
  Future<List<ItemModel>> build() async {
    // โหลดข้อมูลเริ่มต้น
    final repository = ref.watch(itemRepositoryProvider);
    return repository.fetchItems();
  }

  Future<void> addItem(ItemModel newItem) async {
    // กำหนด State เป็น Loading ชั่วคราว (ไม่ต้องใส่ const)
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(itemRepositoryProvider);
      await repository.addItem(newItem);
      
      // ดึงข้อมูลใหม่หลังจากเพิ่มสำเร็จ
      return repository.fetchItems();
    });
  }

  Future<void> refreshItems() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(itemRepositoryProvider).fetchItems();
    });
  }
}