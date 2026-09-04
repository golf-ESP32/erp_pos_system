// แหล่งที่เก็บไฟล์: D:\erp_pos_system\apps\erp_pos_flutter\lib\data\database\tables
// ชื่อไฟล์: products.dart
// หน้าที่ของไฟล์: กำหนดโครงสร้างตารางสินค้า (Products) สำหรับฐานข้อมูล Drift
// ใช้เก็บข้อมูลสินค้า เช่น รหัสสินค้า ชื่อสินค้า บาร์โค้ด ราคา จำนวนคงเหลือ และสถานะสินค้า

import 'package:drift/drift.dart';

class Products extends Table {
  // รหัสประจำรายการสินค้า สร้างเลขลำดับให้อัตโนมัติ
  IntColumn get id => integer().autoIncrement()();

  // รหัสสินค้า ห้ามซ้ำและห้ามเป็นค่าว่าง
  TextColumn get sku => text().withLength(min: 1, max: 50).unique()();

  // ชื่อสินค้า
  TextColumn get name => text().withLength(min: 1, max: 200)();

  // บาร์โค้ดสินค้า สามารถไม่ระบุได้
  TextColumn get barcode => text().withLength(min: 1, max: 100).nullable()();

  // รายละเอียดเพิ่มเติมของสินค้า
  TextColumn get description => text().nullable()();

  // ราคาทุน เก็บเป็นหน่วยสตางค์เพื่อหลีกเลี่ยงปัญหาทศนิยม
  IntColumn get costPrice => integer().withDefault(const Constant(0))();

  // ราคาขาย เก็บเป็นหน่วยสตางค์เพื่อหลีกเลี่ยงปัญหาทศนิยม
  IntColumn get sellingPrice => integer().withDefault(const Constant(0))();

  // จำนวนสินค้าคงเหลือ
  RealColumn get stockQuantity => real().withDefault(const Constant(0))();

  // หน่วยนับสินค้า เช่น ชิ้น กล่อง แพ็ก หรือกิโลกรัม
  TextColumn get unit => text().withDefault(const Constant('ชิ้น'))();

  // สถานะการใช้งานสินค้า
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  // วันที่และเวลาที่สร้างข้อมูล
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // วันที่และเวลาที่แก้ไขข้อมูลล่าสุด
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
