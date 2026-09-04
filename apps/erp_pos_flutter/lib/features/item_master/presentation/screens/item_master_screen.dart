// หน้าที่: หน้าจอจัดการสินค้า ค้นหา เพิ่ม แก้ไข ข้อมูล Master Data สินค้า
// D:\erp_pos_system\apps\erp_pos_flutter\lib\features\item_master\presentation\screens\item_master_screen.dart
import 'package:flutter/material.dart';

// ==========================================
// Models
// ==========================================
class ItemModel {
  final int id;
  final String itemCode;
  final String itemName;
  final String? itemGroupCode;
  final String unitGroupCode;
  final String baseUnitCode;
  final String? barcode;
  final String? description;
  final double costPrice;
  final double sellingPrice;
  final double minStockQty;
  final double? maxStockQty;
  final bool isStockItem;
  final bool isActive;

  ItemModel({
    required this.id,
    required this.itemCode,
    required this.itemName,
    this.itemGroupCode,
    required this.unitGroupCode,
    required this.baseUnitCode,
    this.barcode,
    this.description,
    this.costPrice = 0.0,
    this.sellingPrice = 0.0,
    this.minStockQty = 0.0,
    this.maxStockQty,
    this.isStockItem = true,
    this.isActive = true,
  });
}

// ==========================================
// Mock Data (ใช้ String Code ทั้งหมด)
// ==========================================
final List<Map<String, String>> itemGroupsMock = [
  {'code': 'RAW_MAT', 'name': 'วัตถุดิบหลัก'},
  {'code': 'PACKAGING', 'name': 'บรรจุภัณฑ์'},
  {'code': 'FIN_GOODS', 'name': 'สินค้าสำเร็จรูป'},
  {'code': 'CONSUMABLE', 'name': 'วัสดุสิ้นเปลือง'},
];

final List<Map<String, String>> unitGroupsMock = [
  {'code': 'COUNT', 'name': 'นับชิ้น'},
  {'code': 'LENGTH', 'name': 'ความยาว'},
  {'code': 'PACK', 'name': 'หน่วยบรรจุภัณฑ์'},
  {'code': 'VOLUME', 'name': 'ปริมาตร'},
  {'code': 'WEIGHT', 'name': 'น้ำหนัก'},
];

final List<Map<String, String>> unitsMock = [
  {'code': 'PCS', 'name': 'ชิ้น (PCS)', 'group': 'COUNT'},
  {'code': 'BOX', 'name': 'กล่อง (BOX)', 'group': 'COUNT'},
  {'code': 'CASE', 'name': 'ลัง (CASE)', 'group': 'COUNT'},
  {'code': 'KG', 'name': 'กิโลกรัม (KG)', 'group': 'WEIGHT'},
  {'code': 'GM', 'name': 'กรัม (GM)', 'group': 'WEIGHT'},
  {'code': 'MTR', 'name': 'เมตร (MTR)', 'group': 'LENGTH'},
  {'code': 'LTR', 'name': 'ลิตร (LTR)', 'group': 'VOLUME'},
];

final List<ItemModel> sampleItemsMock = [
  ItemModel(
    id: 1,
    itemCode: 'MAT-FLOUR-01',
    itemName: 'แป้งสาลีทำขนม 1 กก.',
    itemGroupCode: 'RAW_MAT',
    unitGroupCode: 'WEIGHT',
    baseUnitCode: 'KG',
    barcode: '8850001000011',
    costPrice: 35.0,
    sellingPrice: 45.0,
  ),
  ItemModel(
    id: 2,
    itemCode: 'PKG-BOX-S',
    itemName: 'กล่องกระดาษขนาดเล็ก (S)',
    itemGroupCode: 'PACKAGING',
    unitGroupCode: 'COUNT',
    baseUnitCode: 'PCS',
    barcode: '8850002000010',
    costPrice: 3.5,
    sellingPrice: 6.0,
  ),
];

// ==========================================
// Screen Component
// ==========================================
class ItemMasterScreen extends StatefulWidget {
  const ItemMasterScreen({Key? key}) : super(key: key);

  @override
  State<ItemMasterScreen> createState() => _ItemMasterScreenState();
}

class _ItemMasterScreenState extends State<ItemMasterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ItemModel? _selectedItem;

  // Form State
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late TextEditingController _costController;
  late TextEditingController _priceController;
  
  String? _selectedItemGroupCode;
  String? _selectedUnitGroupCode;
  String? _selectedBaseUnitCode;
  bool _isStockItem = true;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // ตั้งค่า Item ตัวแรกเป็น Default
    _selectedItem = sampleItemsMock.first;
    _initFormWithItem(_selectedItem);
  }

  void _initFormWithItem(ItemModel? item) {
    _codeController = TextEditingController(text: item?.itemCode ?? '');
    _nameController = TextEditingController(text: item?.itemName ?? '');
    _barcodeController = TextEditingController(text: item?.barcode ?? '');
    _costController = TextEditingController(text: item?.costPrice.toString() ?? '0.0');
    _priceController = TextEditingController(text: item?.sellingPrice.toString() ?? '0.0');
    
    _selectedItemGroupCode = item?.itemGroupCode ?? itemGroupsMock.first['code'];
    _selectedUnitGroupCode = item?.unitGroupCode ?? unitGroupsMock.first['code'];
    _selectedBaseUnitCode = item?.baseUnitCode ?? unitsMock.first['code'];
    _isStockItem = item?.isStockItem ?? true;
    _isActive = item?.isActive ?? true;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    _nameController.dispose();
    _barcodeController.dispose();
    _costController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการข้อมูลสินค้า (Item Master)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'เพิ่มสินค้าใหม่',
            onPressed: () {
              setState(() {
                _selectedItem = null;
                _initFormWithItem(null);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'บันทึกข้อมูล',
            onPressed: _saveData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'ข้อมูลทั่วไป'),
            Tab(icon: Icon(Icons.straighten), text: 'กลุ่ม & หน่วยนับ'),
            Tab(icon: Icon(Icons.attach_money), text: 'ราคา & สต็อก'),
          ],
        ),
      ),
      body: Row(
        children: [
          // ด้านซ้าย: รายการสินค้า (Master List)
          SizedBox(
            width: 320,
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: sampleItemsMock.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = sampleItemsMock[index];
                  final isSelected = item.id == _selectedItem?.id;
                  return ListTile(
                    selected: isSelected,
                    selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    title: Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('รหัส: ${item.itemCode} | หน่วย: ${item.baseUnitCode}'),
                    onTap: () {
                      setState(() {
                        _selectedItem = item;
                        _initFormWithItem(item);
                      });
                    },
                  );
                },
              ),
            ),
          ),

          // ด้านขวา: ฟอร์มแก้ไขรายละเอียด (Detail Form Tabs)
          Expanded(
            child: Form(
              key: _formKey,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTab1General(),
                  _buildTab2Units(),
                  _buildTab3PricingAndStock(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tab 1: ข้อมูลทั่วไป
  Widget _buildTab1General() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'รหัสสินค้า (item_code)',
              border: OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'กรุณากรอกรหัสสินค้า' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'ชื่อสินค้า (item_name)',
              border: OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'กรุณากรอกชื่อสินค้า' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _barcodeController,
            decoration: const InputDecoration(
              labelText: 'บาร์โค้ดหลัก (barcode)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.qr_code),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedItemGroupCode,
            decoration: const InputDecoration(
              labelText: 'กลุ่มสินค้า (item_group_code)',
              border: OutlineInputBorder(),
            ),
            items: itemGroupsMock.map((g) {
              return DropdownMenuItem<String>(
                value: g['code'],
                child: Text('${g['name']} (${g['code']})'),
              );
            }).toList(),
            onChanged: (val) => setState(() => _selectedItemGroupCode = val),
          ),
        ],
      ),
    );
  }

  // Tab 2: กำหนดกลุ่มหน่วยนับและหน่วยหลัก (เชื่อมโยงผ่าน VARCHAR Code)
  Widget _buildTab2Units() {
    // กรองหน่วยนับที่อยู่ในกลุ่มที่เลือก
    final filteredUnits = unitsMock.where((u) => u['group'] == _selectedUnitGroupCode).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedUnitGroupCode,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'กลุ่มหน่วยนับ (unit_group_code)',
              border: OutlineInputBorder(),
              helperText: 'เลือกกลุ่มเพื่อกำหนดหน่วยนับที่ใช้งานได้',
            ),
            items: unitGroupsMock.map((u) {
              return DropdownMenuItem<String>(
                value: u['code'],
                child: Text('${u['name']} (${u['code']})'),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _selectedUnitGroupCode = val;
                // รีเซ็ต baseUnitCode เมื่อเปลี่ยนกลุ่ม
                final validUnits = unitsMock.where((u) => u['group'] == val).toList();
                if (validUnits.isNotEmpty) {
                  _selectedBaseUnitCode = validUnits.first['code'];
                }
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: filteredUnits.any((u) => u['code'] == _selectedBaseUnitCode)
                ? _selectedBaseUnitCode
                : (filteredUnits.isNotEmpty ? filteredUnits.first['code'] : null),
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'หน่วยนับหลัก (base_unit_code)',
              border: OutlineInputBorder(),
              helperText: 'หน่วยคลังสินค้าฐานสำหรับคำนวณอัตราแปลง',
            ),
            items: filteredUnits.map((u) {
              return DropdownMenuItem<String>(
                value: u['code'],
                child: Text('${u['name']}'),
              );
            }).toList(),
            onChanged: (val) => setState(() => _selectedBaseUnitCode = val),
          ),
        ],
      ),
    );
  }

  // Tab 3: ราคาและสต็อก
  Widget _buildTab3PricingAndStock() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _costController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ราคาทุนมาตรฐาน (cost_price)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ราคาขายมาตรฐาน (selling_price)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('นับสต็อกสินค้า (is_stock_item)'),
            value: _isStockItem,
            onChanged: (val) => setState(() => _isStockItem = val),
          ),
          SwitchListTile(
            title: const Text('สถานะการใช้งาน (is_active)'),
            value: _isActive,
            onChanged: (val) => setState(() => _isActive = val),
          ),
        ],
      ),
    );
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'บันทึกสำเร็จ! [Code: ${_codeController.text}, GroupCode: $_selectedItemGroupCode, UnitGroupCode: $_selectedUnitGroupCode, BaseUnitCode: $_selectedBaseUnitCode]',
          ),
        ),
      );
    }
  }
}