// ไฟล์: test_database.dart
// คำอธิบาย: ทดสอบการเชื่อมต่อและเพิ่มข้อมูลตัวอย่างลงในฐานข้อมูล

import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'app_database.dart';

Future<void> testDatabase() async {
  final db = AppDatabase();

  debugPrint('--- เริ่มต้นทดสอบฐานข้อมูล ---');

  // เพิ่มสินค้าตัวอย่าง
  const product = ProductsCompanion(
    sku: const Value('P002'),
    name: const Value('สินค้าทดสอบ 2'),
    sellingPrice: const Value(10000), // 100 บาท
  );

  final id = await db.createProduct(product);
  debugPrint('เพิ่มสินค้าสำเร็จ, ID คือ: $id');

  // ดึงข้อมูลออกมาตรวจสอบ
  final allProducts = await db.getAllProducts();
  debugPrint('รายการสินค้าทั้งหมดในฐานข้อมูล:');
  for (final p in allProducts) {
    debugPrint('ID: ${p.id}, SKU: ${p.sku}, Name: ${p.name}, Price: ${p.sellingPrice}');
  }

  await db.close();
  debugPrint('--- ทดสอบเสร็จสิ้น ---');
}