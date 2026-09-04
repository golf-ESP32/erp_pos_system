// D:\erp_pos_system\apps\erp_pos_flutter\lib\core\router\app_router.dart
// หน้าที่: จัดการเส้นทางหน้าจอ (Routing System) ทั้งหมดภายในแอปพลิเคชันผ่าน GoRouter และ Riverpod

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/item_master/presentation/screens/item_master_screen.dart';
import '../../features/settings/presentation/screens/field_navigation_order_screen.dart';
import '../../features/shell/presentation/screens/main_shell_screen.dart';
import '../../shared/widgets/placeholder_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/pos-sale',
            builder: (context, state) => const PlaceholderScreen(title: '1. หน้าร้าน / ขายสินค้า (POS Sale System)'),
          ),
          GoRoute(
            path: '/item-master',
            builder: (context, state) => const ItemMasterScreen(),
          ),
          GoRoute(
            path: '/inventory',
            builder: (context, state) => const PlaceholderScreen(title: '3. จัดการคลังและสต็อก (Inventory & Stock)'),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const PlaceholderScreen(title: '4. รายงานและวิเคราะห์ (Reports & Analytics)'),
          ),
          GoRoute(
            path: '/settings/field-navigation',
            builder: (context, state) => const FieldNavigationOrderScreen(),
          ),
          GoRoute(
            path: '/settings/units',
            builder: (context, state) => const PlaceholderScreen(title: '5.2 ตั้งค่าหน่วยนับและอัตราแปลง'),
          ),
          GoRoute(
            path: '/settings/prefixes',
            builder: (context, state) => const PlaceholderScreen(title: '5.3 ตั้งค่า Prefix และ Auto Code'),
          ),
        ],
      ),
    ],
  );
});