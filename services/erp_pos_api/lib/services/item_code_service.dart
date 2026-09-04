// ==============================================================================
// File Path: D:\erp_pos_system\services\erp_pos_api\lib\services\item_code_service.dart
// Description: สร้าง ItemCode 5 หลักแบบอัตโนมัติ โดยอ้างอิงจากรายการที่มีใน pb_items
// ==============================================================================

import 'package:erp_pos_api/config/database.dart';

class ItemCodeService {
  final DatabaseConfig _dbConfig = DatabaseConfig();

  Future<Map<String, String>> generateItemCode(String groupCode) async {
    final conn = await _dbConfig.getConnection();

    try {
      // นับจำนวนสินค้าที่มีรหัสขึ้นต้นด้วย groupCode (เช่น BEV%)
      final results = await conn.query(
        'SELECT COUNT(*) as total FROM pb_items WHERE item_code LIKE ?',
        ['$groupCode%'],
      );

      int nextSeq = 1;
      if (results.isNotEmpty) {
        final total = results.first['total'] as int;
        nextSeq = total + 1;
      }

      final sequenceStr = nextSeq.toString().padLeft(5, '0');
      final itemCode = '$groupCode$sequenceStr';
      final barcode = _generateGS1Barcode(itemCode);

      return {
        'itemCode': itemCode,
        'barcode': barcode,
      };
    } finally {
      await conn.close();
    }
  }

  String _generateGS1Barcode(String code) {
    String rawDigits = code.replaceAll(RegExp(r'\D'), '').padLeft(12, '8').substring(0, 12);
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      int digit = int.parse(rawDigits[i]);
      sum += (i % 2 == 0) ? digit : digit * 3;
    }
    int checkDigit = (10 - (sum % 10)) % 10;
    return '$rawDigits$checkDigit';
  }
}