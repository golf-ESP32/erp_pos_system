// D:\erp_pos_system\apps\erp_pos_flutter\lib\features\item\models\item_model.dart
// หน้าที่: กำหนด Data Model ของสินค้า (Item) และแปลงข้อมูลระหว่าง JSON กับวัตถุ Dart

class ItemModel {
  final String id;
  final String code;
  final String name;
  final double price;
  final int stock;

  ItemModel({
    required this.id,
    required this.code,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'price': price,
      'stock': stock,
    };
  }
}