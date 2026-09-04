// D:\erp_pos_system\apps\erp_pos_flutter\lib\features\shell\presentation\screens\main_shell_screen.dart
// หน้าที่: เค้าโครงหลักของแอปพลิเคชัน (Shell Layout) รองรับ Responsive (Desktop Sidebar / Mobile Drawer & BottomBar) และเชื่อมต่อ State Management กับ Riverpod

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/navigation_controller.dart';

class MainShellScreen extends ConsumerWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final navState = ref.watch(navigationControllerProvider);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: isDesktop
            ? IconButton(
                icon: Icon(navState.isSidebarExpanded ? Icons.menu_open : Icons.menu),
                onPressed: () => ref.read(navigationControllerProvider.notifier).toggleSidebar(),
              )
            : null,
        title: Row(
          children: [
            const Text('ERP/POS System', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(width: 16),
            Chip(
              avatar: Icon(
                authState.isOnline ? Icons.circle : Icons.offline_bolt,
                color: authState.isOnline ? Colors.green : Colors.orange,
                size: 12,
              ),
              label: Text(
                authState.isOnline ? 'Online' : 'Offline Sync Pending',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'ตั้งค่าลำดับคีย์ (Quick Config)',
            icon: const Icon(Icons.keyboard),
            onPressed: () => context.go('/settings/field-navigation'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person, size: 20)),
                const SizedBox(width: 8),
                if (isDesktop)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(authState.username.isEmpty ? 'Admin User' : authState.username,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(authState.role.isEmpty ? 'Administrator' : authState.role,
                          style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      drawer: isDesktop ? null : Drawer(child: _buildNavigationList(context, ref)),
      body: Row(
        children: [
          if (isDesktop)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: navState.isSidebarExpanded ? 260 : 70,
              child: Material(
                elevation: 2,
                child: _buildNavigationList(context, ref, isExpanded: navState.isSidebarExpanded),
              ),
            ),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: !isDesktop ? _buildBottomNavigationBar(context) : null,
    );
  }

  Widget _buildNavigationList(BuildContext context, WidgetRef ref, {bool isExpanded = true}) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildMenuItem(context, ref, title: '1. หน้าร้าน / ขายสินค้า', icon: Icons.point_of_sale, route: '/pos-sale', isExpanded: isExpanded),
        _buildMenuItem(context, ref, title: '2. จัดการสินค้า/วัตถุดิบ', icon: Icons.inventory_2, route: '/item-master', isExpanded: isExpanded),
        _buildMenuItem(context, ref, title: '3. จัดการคลังและสต็อก', icon: Icons.warehouse, route: '/inventory', isExpanded: isExpanded),
        _buildMenuItem(context, ref, title: '4. รายงานและวิเคราะห์', icon: Icons.analytics, route: '/reports', isExpanded: isExpanded),
        ExpansionTile(
          leading: const Icon(Icons.settings),
          title: isExpanded ? const Text('5. ตั้งค่าระบบ') : const SizedBox.shrink(),
          children: [
            _buildSubMenuItem(context, ref, title: '5.1 ลำดับการคีย์ข้อมูล', route: '/settings/field-navigation', isExpanded: isExpanded),
            _buildSubMenuItem(context, ref, title: '5.2 หน่วยนับและอัตราแปลง', route: '/settings/units', isExpanded: isExpanded),
            _buildSubMenuItem(context, ref, title: '5.3 Prefix และ Auto Code', route: '/settings/prefixes', isExpanded: isExpanded),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, WidgetRef ref, {required String title, required IconData icon, required String route, required bool isExpanded}) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).primaryColor : null),
      title: isExpanded ? Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)) : null,
      selected: isSelected,
      onTap: () {
        ref.read(navigationControllerProvider.notifier).setRoute(route);
        if (!MediaQuery.of(context).size.width.isAtLeast900) {
          Navigator.pop(context); // ปิด Drawer เมื่อเลือกเมนูในโหมด Mobile
        }
        context.go(route);
      },
    );
  }

  Widget _buildSubMenuItem(BuildContext context, WidgetRef ref, {required String title, required String route, required bool isExpanded}) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final isSelected = currentRoute == route;

    return ListTile(
      contentPadding: EdgeInsets.only(left: isExpanded ? 32.0 : 16.0),
      title: isExpanded ? Text(title, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)) : null,
      selected: isSelected,
      onTap: () {
        ref.read(navigationControllerProvider.notifier).setRoute(route);
        if (!MediaQuery.of(context).size.width.isAtLeast900) {
          Navigator.pop(context); // ปิด Drawer เมื่อเลือกเมนูในโหมด Mobile
        }
        context.go(route);
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (currentRoute == '/pos-sale') currentIndex = 0;
    else if (currentRoute == '/item-master') currentIndex = 1;
    else if (currentRoute == '/inventory') currentIndex = 2;
    else if (currentRoute.startsWith('/settings')) currentIndex = 3;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 0) context.go('/pos-sale');
        if (index == 1) context.go('/item-master');
        if (index == 2) context.go('/inventory');
        if (index == 3) context.go('/settings/field-navigation');
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.point_of_sale), label: 'ขาย POS'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'สินค้า'),
        BottomNavigationBarItem(icon: Icon(Icons.warehouse), label: 'สต็อก'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'ตั้งค่า'),
      ],
    );
  }
}

extension ScreenWidthCheck on double {
  bool get isAtLeast900 => this >= 900;
}