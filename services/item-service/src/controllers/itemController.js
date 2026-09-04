// D:\erp_pos_system\services\item-service\src\controllers\itemController.js
// หน้าที่: จัดการลอจิกทางธุรกิจ (Business Logic) สำหรับคำร้องขอเกี่ยวกับสินค้า ก่อนส่งต่อให้ Database

const itemModel = require('../models/itemModel');

exports.getAllItems = async (req, res) => {
  try {
    const items = await itemModel.findAll();
    res.status(200).json(items);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching items', error: error.message });
  }
};

exports.getItemById = async (req, res) => {
  try {
    const item = await itemModel.findById(req.params.id);
    if (!item) {
      return res.status(404).json({ message: 'Item not found' });
    }
    res.status(200).json(item);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching item', error: error.message });
  }
};

exports.createItem = async (req, res) => {
  try {
    const newItem = await itemModel.create(req.body);
    res.status(201).json(newItem);
  } catch (error) {
    res.status(500).json({ message: 'Error creating item', error: error.message });
  }
};

exports.updateItem = async (req, res) => {
  try {
    const updated = await itemModel.update(req.params.id, req.body);
    res.status(200).json(updated);
  } catch (error) {
    res.status(500).json({ message: 'Error updating item', error: error.message });
  }
};

exports.deleteItem = async (req, res) => {
  try {
    await itemModel.delete(req.params.id);
    res.status(200).json({ message: 'Item deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting item', error: error.message });
  }
};