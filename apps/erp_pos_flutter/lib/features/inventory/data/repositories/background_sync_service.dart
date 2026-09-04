// D:\erp_pos_system\apps\erp_pos_flutter\lib\features\inventory\data\repositories\background_sync_service.dart
// หน้าที่: จัดการ Sync ข้อมูลคลังสินค้ากับ Server ใน Background ผ่าน Dio

import 'package:dio/dio.dart';
import 'local_database.dart';

class BackgroundSyncService {
  final Dio _dio;
  final LocalDatabase _db;

  BackgroundSyncService(this._dio, this._db);

  Future<void> syncPendingData() async {
    try {
      // ดึงรายการรอ Sync จาก Drift Local Database
      final pendingItems = await _db.getUnsyncedItems();

      for (var item in pendingItems) {
        final response = await _dio.post(
          '/api/v1/inventory/sync',
          data: item.toJson(),
        );

        if (response.statusCode == 200) {
          await _db.markAsSynced(item.id);
        }
      }
    } on DioException catch (e) {
      // จัดการ Error จาก Dio Network
      rethrow;
    }
  }
}