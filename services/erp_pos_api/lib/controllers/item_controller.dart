// ==============================================================================
// File Path: D:\erp_pos_system\services\erp_pos_api\lib\controllers\item_controller.dart
// Description: Controller จัดการ Endpoint เกี่ยวกัับสินค้า (GET /items, GET /generate-code)
// ==============================================================================

import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:erp_pos_api/services/item_code_service.dart';
import 'package:erp_pos_api/services/item_service.dart';

class ItemController {
  final ItemCodeService _itemCodeService = ItemCodeService();
  final ItemService _itemService = ItemService();

  Router get router {
    final router = Router();

    // GET /api/v1/items - ดึงรายการสินค้าทั้งหมด
    router.get('/', (Request request) async {
      final limitStr = request.url.queryParameters['limit'] ?? '50';
      final offsetStr = request.url.queryParameters['offset'] ?? '0';

      final limit = int.tryParse(limitStr) ?? 50;
      final offset = int.tryParse(offsetStr) ?? 0;

      try {
        final items = await _itemService.getAllItems(limit: limit, offset: offset);

        return Response.ok(
          jsonEncode({
            'status': 'success',
            'total': items.length,
            'data': items,
          }),
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({
            'status': 'error',
            'message': 'ไม่สามารถดึงข้อมูลสินค้าได้: ${e.toString()}',
          }),
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }
    });

    // GET /api/v1/items/generate-code?groupCode=BEV
    router.get('/generate-code', (Request request) async {
      final groupCode = request.url.queryParameters['groupCode'] ?? 'GEN';

      try {
        final result = await _itemCodeService.generateItemCode(groupCode);

        return Response.ok(
          jsonEncode({
            'status': 'success',
            'data': result,
          }),
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({
            'status': 'error',
            'message': 'ไม่สามารถสร้าง ItemCode ได้: ${e.toString()}',
          }),
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }
    });

    return router;
  }
}