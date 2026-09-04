// แหล่งที่เก็บไฟล์: D:\erp_pos_system\apps\erp_pos_flutter\lib\data\database
// ชื่อไฟล์: app_database.dart
// หน้าที่ของไฟล์: กำหนดฐานข้อมูลหลักของระบบ ERP POS ด้วย Drift
// ใช้ลงทะเบียนตารางฐานข้อมูลและจัดเตรียมคำสั่งเพิ่ม อ่าน แก้ไข และลบข้อมูลสินค้า

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/products.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Products])
class AppDatabase extends _$AppDatabase {
  // เปิดฐานข้อมูลจริงของแอปพลิเคชัน
  AppDatabase() : super(driftDatabase(name: 'erp_pos'));

  // ใช้สำหรับส่งฐานข้อมูลจำลองเข้ามาในระหว่างการทดสอบ
  AppDatabase.forTesting(super.executor);

  // เวอร์ชันโครงสร้างฐานข้อมูล
  @override
  int get schemaVersion => 1;

  // อ่านสินค้าทั้งหมด
  Future<List<Product>> getAllProducts() {
    return select(products).get();
  }

  // ติดตามการเปลี่ยนแปลงของรายการสินค้าทั้งหมดแบบเรียลไทม์
  Stream<List<Product>> watchAllProducts() {
    return select(products).watch();
  }

  // ค้นหาสินค้าจากรหัสรายการในฐานข้อมูล
  Future<Product?> getProductById(int id) {
    return (select(
      products,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  // ค้นหาสินค้าจากรหัสสินค้า
  Future<Product?> getProductBySku(String sku) {
    return (select(
      products,
    )..where((row) => row.sku.equals(sku))).getSingleOrNull();
  }

  // เพิ่มสินค้าใหม่
  Future<int> createProduct(ProductsCompanion product) {
    return into(products).insert(product);
  }

  // แก้ไขข้อมูลสินค้าและอัปเดตวันเวลาล่าสุด
  Future<bool> updateProduct(Product product) {
    return update(
      products,
    ).replace(product.copyWith(updatedAt: DateTime.now()));
  }

  // ลบสินค้าจากรหัสรายการในฐานข้อมูล
  Future<int> deleteProduct(int id) {
    return (delete(products)..where((row) => row.id.equals(id))).go();
  }
}
