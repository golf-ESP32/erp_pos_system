-- ==============================================================================
// File Path: D:\erp_pos_system\services\erp_pos_api\database\schema.sql
// Description: DDL Schema สำหรับตารางกลุ่มสินค้า (pbitem_groups) และตารางสินค้า (pbitems)
//              พร้อมการสร้าง Index, Foreign Key และข้อมูลตัวอย่าง (Mock Data) สำหรับทดสอบ
// ==============================================================================

-- 1. สร้าง Extension สำหรับสุ่ม UUID (หากยังไม่มีใน Database)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. สร้างตารางกลุ่มสินค้า (pbitem_groups)
-- ทำหน้าที่เก็บรหัสกลุ่ม และ Sequence ล่าสุดของการออก ItemCode 5 หลัก
CREATE TABLE IF NOT EXISTS pbitem_groups (
    group_code VARCHAR(10) PRIMARY KEY,       -- รหัสกลุ่มสินค้า (เช่น 'BEV', 'SNK', 'DRY')
    group_name VARCHAR(100) NOT NULL,          -- ชื่อกลุ่มสินค้า (เช่น 'เครื่องดื่ม', 'ขนมคบเคี้ยว')
    prefix VARCHAR(5) NOT NULL,                -- Prefix ประจำกลุ่มสำหรับออกรหัส
    current_seq INT NOT NULL DEFAULT 0,        -- ลำดับ Sequence ล่าสุดที่ถูกใช้งานไปแล้ว (0 - 99999)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. สร้างตารางสินค้าหลัก (pbitems)
-- เก็บข้อมูลสินค้า Master Data รองรับทั้งการ Sync จาก Offline เครื่องลูก และ Online
CREATE TABLE IF NOT EXISTS pbitems (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), -- PK แบบ UUID รองรับการสร้างจากเครื่องลูก Offline
    item_code VARCHAR(10) NOT NULL UNIQUE,          -- รหัสสินค้า 5 หลัก (เช่น '00001')
    item_name VARCHAR(150) NOT NULL,                 -- ชื่อสินค้า
    group_code VARCHAR(10) NOT NULL,                 -- FK ไปยัง pbitem_groups
    barcode_gs1 VARCHAR(13) UNIQUE,                  -- บาร์โค้ดสากล GS1-13 (13 หลัก)
    base_price NUMERIC(12, 2) NOT NULL DEFAULT 0.00, -- ราคาขายพื้นฐาน
    unit_name VARCHAR(20) NOT NULL DEFAULT 'ชิ้น',   -- หน่วยนับหลัก
    is_synced BOOLEAN NOT NULL DEFAULT TRUE,         -- สถานะการ Sync ข้อมูลกับเครื่องลูก POS
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Key Constraint
    CONSTRAINT fk_pbitems_group FOREIGN KEY (group_code) 
        REFERENCES pbitem_groups(group_code) 
        ON UPDATE CASCADE 
        ON DELETE RESTRICT
);

-- 4. สร้าง Indexes เพื่อเพิ่มประสิทธิภาพการค้นหา (Performance Tuning)
CREATE INDEX IF NOT EXISTS idx_pbitems_group_code ON pbitems(group_code);
CREATE INDEX IF NOT EXISTS idx_pbitems_barcode_gs1 ON pbitems(barcode_gs1);
CREATE INDEX IF NOT EXISTS idx_pbitems_item_code ON pbitems(item_code);

-- ==============================================================================
-- MOCK DATA (ข้อมูลตัวอย่างสำหรับการทดสอบ)
-- ==============================================================================

-- ล้างข้อมูลเก่าเพื่อทดสอบ (ถ้ามี)
TRUNCATE TABLE pbitems, pbitem_groups RESTART IDENTITY CASCADE;

-- เพิ่มข้อมูลตัวอย่างกลุ่มสินค้า (pbitem_groups)
INSERT INTO pbitem_groups (group_code, group_name, prefix, current_seq) VALUES
('BEV', 'เครื่องดื่ม (Beverages)', 'BEV', 3),
('SNK', 'ขนมและของว่าง (Snacks)', 'SNK', 2),
('DRY', 'อาหารแห้ง (Dry Foods)', 'DRY', 0);

-- เพิ่มข้อมูลตัวอย่างสินค้า (pbitems)
-- บาร์โค้ด GS1-13 คำนวณจาก: Prefix(2191) + ItemCode(5 หลัก) + UnitSeq(001) + CheckDigit(1 หลัก)
INSERT INTO pbitems (id, item_code, item_name, group_code, barcode_gs1, base_price, unit_name, is_synced) VALUES
(uuid_generate_v4(), '00001', 'กาแฟกระป๋องพร้อมดื่ม 180 มล.', 'BEV', '2191000010014', 17.00, 'กระป๋อง', true),
(uuid_generate_v4(), '00002', 'น้ำแร่ธรรมชาติ 600 มล.', 'BEV', '2191000020011', 10.00, 'ขวด', true),
(uuid_generate_v4(), '00003', 'ชาเขียวรสต้นตำรับ 500 มล.', 'BEV', '2191000030018', 20.00, 'ขวด', true),
(uuid_generate_v4(), '00001', 'มันฝรั่งทอดกรอบ รสเกลือ 48g', 'SNK', '2191000010014', 20.00, 'ซอง', true),
(uuid_generate_v4(), '00002', 'ถั่วลิสงอบเกลือ 30g', 'SNK', '2191000020011', 10.00, 'ซอง', true);