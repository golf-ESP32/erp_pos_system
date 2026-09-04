// ============================================================================
// [FILE HEADER]
// 📌 Location: routes/syncRoutes.js
// 📝 Description: Express Router สำหรับรองรับข้อมูลการ Sync ย้อนหลังจาก Client
//    (Offline Mode) ใช้คำสั่ง SQL ON CONFLICT (UPSERT) เพื่ออัปเดตหรือเพิ่มข้อมูล
//    ลง PostgreSQL ป้องกันข้อมูลซ้ำซ้อน
// ============================================================================

const express = require('express');
const router = express.Router();
const pool = require('../db');

// POST: /api/v1/items/sync (รับ Payload จากการ Offline มา Sync)
router.post('/items/sync', async (req, res) => {
  const client = await pool.connect();
  try {
    const {
      item_code,
      item_name,
      item_group_code,
      unit_group_code,
      base_unit_code,
      cost_price,
      selling_price,
      is_stock_item,
      is_active
    } = req.body;

    await client.query('BEGIN');

    // UPSERT: ถ้ามี item_code อยู่แล้วให้อัปเดต ถ้ายังไม่มีให้ Insert
    const upsertQuery = `
      INSERT INTO pb_items (
        item_code, item_name, item_group_code, unit_group_code, 
        base_unit_code, cost_price, selling_price, is_stock_item, is_active, updated_at
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, NOW())
      ON CONFLICT (item_code) DO UPDATE SET
        item_name = EXCLUDED.item_name,
        item_group_code = EXCLUDED.item_group_code,
        unit_group_code = EXCLUDED.unit_group_code,
        base_unit_code = EXCLUDED.base_unit_code,
        cost_price = EXCLUDED.cost_price,
        selling_price = EXCLUDED.selling_price,
        is_stock_item = EXCLUDED.is_stock_item,
        is_active = EXCLUDED.is_active,
        updated_at = NOW();
    `;

    await client.query(upsertQuery, [
      item_code, item_name, item_group_code, unit_group_code,
      base_unit_code, cost_price, selling_price, is_stock_item, is_active
    ]);

    await client.query('COMMIT');
    res.status(200).json({ success: true, message: 'Synced successfully' });
  } catch (err) {
    await client.query('ROLLBACK');
    res.status(500).json({ success: false, message: err.message });
  } finally {
    client.release();
  }
});

module.exports = router;