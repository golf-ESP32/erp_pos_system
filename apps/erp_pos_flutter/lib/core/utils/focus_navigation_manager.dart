// D:\erp_pos_system\apps\erp_pos_flutter\lib\core\utils\focus_navigation_manager.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// คลาสจำลองโครงสร้างตาราง sys_field_navigations
class FieldNavigationConfig {
  final String fieldKey;
  final int stepOrder;
  final bool isSkipOnEnter;
  final bool isSelectAllText;

  FieldNavigationConfig({
    required this.fieldKey,
    required this.stepOrder,
    this.isSkipOnEnter = false,
    this.isSelectAllText = true,
  });
}

/// ตัวจัดการ Focus การกด Enter ย้าย Cursor แบบ System-wide
class FocusNavigationManager {
  final Map<String, FocusNode> _nodes = {};
  final Map<String, TextEditingController> _controllers = {};
  final List<FieldNavigationConfig> configs;

  FocusNavigationManager({required this.configs}) {
    // เรียงลำดับตาม stepOrder จากน้อยไปมาก
    configs.sort((a, b) => a.stepOrder.compareTo(b.stepOrder));
  }

  FocusNode registerFocusNode(String fieldKey) {
    if (!_nodes.containsKey(fieldKey)) {
      final node = FocusNode();
      node.addListener(() {
        if (node.hasFocus) {
          final config = configs.firstWhere(
            (c) => c.fieldKey == fieldKey,
            orElse: () => FieldNavigationConfig(fieldKey: fieldKey, stepOrder: 999),
          );
          if (config.isSelectAllText && _controllers.containsKey(fieldKey)) {
            final controller = _controllers[fieldKey]!;
            controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.text.length,
            );
          }
        }
      });
      _nodes[fieldKey] = node;
    }
    return _nodes[fieldKey]!;
  }

  void registerController(String fieldKey, TextEditingController controller) {
    _controllers[fieldKey] = controller;
  }

  void nextFocus(String currentFieldKey) {
    final activeConfigs = configs.where((c) => !c.isSkipOnEnter).toList();
    final currentIndex = activeConfigs.indexWhere((c) => c.fieldKey == currentFieldKey);

    if (currentIndex != -1 && currentIndex < activeConfigs.length - 1) {
      final nextKey = activeConfigs[currentIndex + 1].fieldKey;
      _nodes[nextKey]?.requestFocus();
    } else if (activeConfigs.isNotEmpty) {
      // Loop กลับไป Field แรกสุด
      _nodes[activeConfigs.first.fieldKey]?.requestFocus();
    }
  }

  KeyEventResult handleKeyPress(String fieldKey, KeyEvent event) {
    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.enter ||
         event.logicalKey == LogicalKeyboardKey.numpadEnter)) {
      nextFocus(fieldKey);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void dispose() {
    for (var node in _nodes.values) {
      node.dispose();
    }
    _nodes.clear();
    _controllers.clear();
  }
}