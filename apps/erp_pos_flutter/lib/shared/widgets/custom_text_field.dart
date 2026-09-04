// D:\erp_pos_system\apps\erp_pos_flutter\lib\shared\widgets\custom_text_field.dart
import 'package:flutter/material.dart';
import '../../core/utils/focus_navigation_manager.dart';

class CustomTextField extends StatelessWidget {
  final String fieldKey;
  final String labelText;
  final TextEditingController controller;
  final FocusNavigationManager focusManager;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;

  const CustomTextField({
    super.key,
    required this.fieldKey,
    required this.labelText,
    required this.controller,
    required this.focusManager,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final focusNode = focusManager.registerFocusNode(fieldKey);
    focusManager.registerController(fieldKey, controller);

    return Focus(
      onKeyEvent: (node, event) => focusManager.handleKeyPress(fieldKey, event),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}