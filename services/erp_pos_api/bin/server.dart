// ==============================================================================
// File Path: D:\erp_pos_system\services\erp_pos_api\bin\server.dart
// Description: Entry Point หลักของระบบ Dart Backend (Shelf HTTP Server)
// ==============================================================================
// ==============================================================================
// File Path: D:\erp_pos_system\services\erp_pos_api\bin\server.dart
// ==============================================================================

import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:dotenv/dotenv.dart';

import 'package:erp_pos_api/config/database.dart';
import 'package:erp_pos_api/controllers/item_controller.dart';
import 'package:erp_pos_api/controllers/sync_controller.dart';

void main(List<String> args) async {
  final env = DotEnv()..load();

  final dbConfig = DatabaseConfig();
  try {
    await dbConfig.initialize();
  } catch (e) {
    print('⚠️ [Warning] ไม่สามารถเชื่อมต่อ Database ได้: $e');
  }

  final router = Router();

  // Health Check Endpoint สำหรับ MySQL
  router.get('/api/v1/health', (Request request) async {
    bool dbStatus = false;
    try {
      final conn = await dbConfig.getConnection();
      final result = await conn.query('SELECT 1');
      dbStatus = result.isNotEmpty;
      await conn.close();
    } catch (_) {
      dbStatus = false;
    }

    return Response.ok(
      '{"status": "online", "service": "erp_pos_api", "database": "pb_erp", "connected": $dbStatus}',
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  });

  router.mount('/api/v1/items', ItemController().router.call);
  router.mount('/api/v1/sync', SyncController().router.call);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final port = int.parse(env['PORT'] ?? '8080');
  final server = await io.serve(handler, InternetAddress.anyIPv4, port);

  print('🚀 ERP POS API Server running on http://localhost:${server.port}');
}