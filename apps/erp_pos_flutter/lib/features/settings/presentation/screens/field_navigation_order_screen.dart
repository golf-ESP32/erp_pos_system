// D:\erp_pos_system\apps\erp_pos_flutter\lib\features\settings\presentation\screens\field_navigation_order_screen.dart
// หน้าที่: หน้าจอสำหรับให้ผู้ใช้ปรับแต่งลำดับการกด Tab/Enter เพื่อย้าย Focus ของ Form

import 'package:flutter/material.dart';
import '../../../../core/utils/focus_navigation_manager.dart';

class FieldNavigationOrderScreen extends StatefulWidget {
  const FieldNavigationOrderScreen({super.key});

  @override
  State<FieldNavigationOrderScreen> createState() =>
      _FieldNavigationOrderScreenState();
}

class _FieldNavigationOrderScreenState
    extends State<FieldNavigationOrderScreen> {
  final List<FieldNavigationConfig> _configs = [];

  @override
  void initState() {
    super.initState();
    _configs.addAll([
      FieldNavigationConfig(
        fieldKey: 'code',
        stepOrder: 1,
      ),
      FieldNavigationConfig(
        fieldKey: 'name',
        stepOrder: 2,
      ),
      FieldNavigationConfig(
        fieldKey: 'price',
        stepOrder: 3,
      ),
      FieldNavigationConfig(
        fieldKey: 'cost',
        stepOrder: 4,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่าลำดับการเปลี่ยนช่อง Focus'),
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _configs.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = _configs.removeAt(oldIndex);
            _configs.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          final item = _configs[index];
          return Card(
            key: ValueKey(item.fieldKey),
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text('ฟิลด์: ${item.fieldKey}'),
              subtitle: Text('ลำดับ: ${index + 1}'),
              trailing: const Icon(Icons.drag_handle),
            ),
          );
        },
      ),
    );
  }
}