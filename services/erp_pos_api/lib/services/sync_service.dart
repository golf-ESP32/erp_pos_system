// ==============================================================================
// File Path: D:\erp_pos_system\services\erp_pos_api\lib\services\sync_service.dart
// Description: จัดการ Sync ข้อมูล Offline Queue ลง pb_items พร้อมค้นหา base_unit_id 
//              จากตาราง pb_units โดยอัตโนมัติ
// ==============================================================================

import 'package:erp_pos_api/config/database.dart';

class SyncService {
  final DatabaseConfig _dbConfig = DatabaseConfig();

Future<List<Map<String, dynamic>>> getAllItems({int limit = 50, int offset = 0}) async {
    final conn = await _dbConfig.getConnection();

    try {
      final results = await conn.query(
        '''
        SELECT 
          i.id,
          i.item_code,
          i.item_name,
          i.cost_price,
          i.selling_price,
          i.unit_group_id,
          ug.unit_group_code,
          ug.unit_group_name,
          i.base_unit_id,
          u.unit_code AS base_unit_code,
          u.unit_name AS base_unit_name,
          i.created_at
        FROM pb_items i
        LEFT JOIN pb_unit_groups ug ON i.unit_group_id = ug.id
        LEFT JOIN pb_units u ON i.base_unit_id = u.id
        ORDER BY i.id DESC
        LIMIT ? OFFSET ?
        ''',
        [limit, offset],
      );

      return results.map((row) {
        return {
          'id': row['id'],
          'itemCode': row['item_code'],
          'itemName': row['item_name'],
          'costPrice': row['cost_price'],
          'sellingPrice': row['selling_price'],
          'unitGroupId': row['unit_group_id'],
          'unitGroupCode': row['unit_group_code'],
          'unitGroupName': row['unit_group_name'],
          'baseUnitId': row['base_unit_id'],
          'baseUnitCode': row['base_unit_code'],
          'baseUnitName': row['base_unit_name'],
          'createdAt': row['created_at']?.toString(),
        };
      }).toList();
    } finally {
      await conn.close();
    }
  }

  Future<Map<String, dynamic>> syncItems(List<dynamic> itemsList) async {
    final conn = await _dbConfig.getConnection();
    final List<String> syncedLocalIds = [];
    final List<Map<String, dynamic>> errors = [];

    try {
      await conn.query('START TRANSACTION');

      // 1. ดึง unit_group_id หลักอันแรก (เช่น COUNT / หน่วยนับทั่วไป)
      final unitGroupQuery = await conn.query(
        'SELECT id FROM pb_unit_groups WHERE is_active = 1 LIMIT 1',
      );

      final defaultUnitGroupId = unitGroupQuery.isNotEmpty 
          ? unitGroupQuery.first['id'] as int 
          : 1;

      // 2. ดึง base_unit_id ที่สัมพันธ์กับ unit_group_id (เลือกตัวที่เป็นหน่วยหลัก base_qty = 1)
      final unitQuery = await conn.query(
        '''
        SELECT id FROM pb_units 
        WHERE unit_group_id = ? AND is_active = 1 
        ORDER BY base_qty ASC 
        LIMIT 1
        ''',
        [defaultUnitGroupId],
      );

      final defaultBaseUnitId = unitQuery.isNotEmpty 
          ? unitQuery.first['id'] as int 
          : 1;

      // 3. วนลูป INSERT รายการสินค้า
      for (var item in itemsList) {
        try {
          final localId = item['localId'] as String;
          final itemName = item['itemName'] as String;
          final basePrice = item['basePrice'] ?? 0.0;
          final itemCode = 'ITEM-$localId';

          final result = await conn.query(
            '''
            INSERT INTO pb_items (
              item_code, 
              item_name, 
              cost_price, 
              selling_price, 
              unit_group_id,
              base_unit_id,
              created_at
            )
            VALUES (?, ?, ?, ?, ?, ?, NOW())
            ''',
            [
              itemCode, 
              itemName, 
              0.00, 
              basePrice, 
              defaultUnitGroupId, 
              defaultBaseUnitId
            ],
          );

          if (result.affectedRows! > 0) {
            syncedLocalIds.add(localId);
          }
        } catch (e) {
          errors.add({
            'localId': item['localId'],
            'error': e.toString(),
          });
        }
      }

      await conn.query('COMMIT');
    } catch (e) {
      await conn.query('ROLLBACK');
      rethrow;
    } finally {
      await conn.close();
    }

    return {
      'status': 'success',
      'syncedCount': syncedLocalIds.length,
      'syncedLocalIds': syncedLocalIds,
      'errors': errors,
    };
  }
}