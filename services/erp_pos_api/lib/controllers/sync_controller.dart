// ==============================================================================
// File Path: D:\erp_pos_system\services\erp_pos_api\lib\controllers\sync_controller.dart
// Description: Controller สำหรับจัดการ Sync ข้อมูลสินค้า Offline Queue ลง MySQL (pb_erp)
// ==============================================================================

import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:erp_pos_api/services/sync_service.dart';

class SyncController {
  final SyncService _syncService = SyncService();

  Router get router {
    final router = Router();

    // POST /api/v1/sync/items
    router.post('/items', (Request request) async {
      try {
        final payloadStr = await request.readAsString();
        final body = jsonDecode(payloadStr) as Map<String, dynamic>;

        final batchId = body['batchId'] as String? ?? 'UNKNOWN_BATCH';
        final itemsToSync = body['items'] as List<dynamic>? ?? [];

        if (itemsToSync.isEmpty) {
          return Response.badRequest(
            body: jsonEncode({
              'status': 'error',
              'message': 'ไม่พบรายการสินค้าที่ส่งมา Sync',
            }),
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }

        final syncResult = await _syncService.syncItems(itemsToSync);

        return Response.ok(
          jsonEncode({
            'batchId': batchId,
            'status': syncResult['status'],
            'syncedCount': syncResult['syncedCount'],
            'syncedLocalIds': syncResult['syncedLocalIds'],
            'errors': syncResult['errors'],
          }),
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({
            'status': 'error',
            'message': 'เกิดข้อผิดพลาดในการ Sync ข้อมูล: ${e.toString()}',
          }),
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }
    });

    return router;
  }
}