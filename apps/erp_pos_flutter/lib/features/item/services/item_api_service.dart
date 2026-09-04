// D:\erp_pos_system\apps\erp_pos_flutter\lib\features\item\services\item_api_service.dart
// หน้าที่: จัดการการเชื่อมต่อ API (HTTP Request) สำหรับดึง เพิ่ม แก้ไข และลบข้อมูลสินค้า

import 'dart:convert';
import 'http/http.dart' as http;
import '../models/item_model.dart';

class ItemApiService {
  final String baseUrl = 'http://localhost:3000/api/items';

  Future<List<ItemModel>> getItems() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => ItemModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> createItem(ItemModel item) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create item');
    }
  }
}