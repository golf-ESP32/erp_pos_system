// ==============================================================================
// File Path: D:\erp_pos_system\services\erp_pos_api\lib\models\item_model.dart
// Description: Data Model สำหรับข้อมูลกลุ่มสินค้า (ItemGroup) และสินค้า (Item)
//              รวมถึงโครงสร้างข้อมูล GS1-13 Barcode และการ Convert ข้อมูลเป็น JSON Map
// ==============================================================================

/// โครงสร้างข้อมูลกลุ่มสินค้า (Item Group)
class ItemGroupModel {
  final String groupCode;
  final String groupName;
  final String prefix; // Prefix 2-3 หลัก สำหรับออกรหัสสินค้า (เช่น "PB", "FD")
  final int currentSeq; // Sequence ล่าสุดที่ใช้ไปแล้ว (1-99999)

  ItemGroupModel({
    required this.groupCode,
    required this.groupName,
    required this.prefix,
    required this.currentSeq,
  });

  /// แปลงข้อมูลจาก PostgreSQL Result Row เป็น Object
  factory ItemGroupModel.fromMap(Map<String, dynamic> map) {
    return ItemGroupModel(
      groupCode: map['group_code'] as String,
      groupName: map['group_name'] as String,
      prefix: map['prefix'] as String,
      currentSeq: map['current_seq'] as int? ?? 0,
    );
  }

  /// แปลงเป็น JSON Map สำหรับส่งออก REST API
  Map<String, dynamic> toJson() {
    return {
      'groupCode': groupCode,
      'groupName': groupName,
      'prefix': prefix,
      'currentSeq': currentSeq,
    };
  }
}

/// โครงสร้างข้อมูลสินค้า (Item Master)
class ItemModel {
  final String? id; // UUID บน Server หรือ Local SQLite ID
  final String itemCode; // รหัสสินค้า 5 หลัก (เช่น "00001") หรือแบบมี Prefix
  final String itemName;
  final String groupCode;
  final String? barcodeGs1; // บาร์โค้ด GS1-13 (13 หลัก)
  final double basePrice;
  final String unitName;
  final bool isSynced;
  final DateTime? createdAt;

  ItemModel({
    this.id,
    required this.itemCode,
    required this.itemName,
    required this.groupCode,
    this.barcodeGs1,
    required this.basePrice,
    required this.unitName,
    this.isSynced = true,
    this.createdAt,
  });

  /// แปลงข้อมูลจาก PostgreSQL Map เป็น ItemModel
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id']?.toString(),
      itemCode: map['item_code'] as String,
      itemName: map['item_name'] as String,
      groupCode: map['group_code'] as String,
      barcodeGs1: map['barcode_gs1'] as String?,
      basePrice: (map['base_price'] as num).toDouble(),
      unitName: map['unit_name'] as String,
      isSynced: map['is_synced'] as bool? ?? true,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'].toString()) : null,
    );
  }

  /// แปลงเป็น JSON Map สำหรับ Response ออกไปหา Client (Flutter)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemCode': itemCode,
      'itemName': itemName,
      'groupCode': groupCode,
      'barcodeGs1': barcodeGs1,
      'basePrice': basePrice,
      'unitName': unitName,
      'isSynced': isSynced,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}