// ==============================================================================
// File Path: D:\erp_pos_system\services\erp_pos_api\lib\services\item_service.dart
// Description: Service สำหรับจัดการดึงข้อมูลรายการสินค้าพร้อม Relational Unit Metadata
// ==============================================================================

import 'package:erp_pos_api/config/database.dart';

class ItemService {
  final DatabaseConfig _dbConfig = DatabaseConfig();

  /// ดึงรายการสินค้าทั้งหมด พร้อมชื่อหน่วยนับหลัก (Base Unit) และกลุ่มหน่วยนับ (Unit Group)
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
}