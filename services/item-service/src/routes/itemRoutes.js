//D:\erp_pos_system\services\item-service\src\routes\itemRoutes.js

const express = require('express');
const router = express.Router();
const itemController = require('../controllers/itemController');

// GET /api/items - ดึงรายการสินค้าทั้งหมด
router.get('/', itemController.getAllItems);

// GET /api/items/:id - ดึงข้อมูลสินค้าตาม ID
router.get('/:id', itemController.getItemById);

// POST /api/items - เพิ่มสินค้าใหม่
router.post('/', itemController.createItem);

// PUT /api/items/:id - แก้ไขข้อมูลสินค้า
router.put('/:id', itemController.updateItem);

// DELETE /api/items/:id - ลบสินค้า
router.delete('/:id', itemController.deleteItem);

module.exports = router;