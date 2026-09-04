// D:\erp_pos_system\apps\erp_pos_flutter\lib\main.dart
// หน้าที่: จุดเริ่มต้นการทำงานของแอปพลิเคชัน (Entry Point) กำหนดการตั้งค่า ProviderScope, Theme และ GoRouter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  // บังคับให้ Flutter Binding ทำงานเสร็จสมบูรณ์ก่อนเริ่มแอป (รองรับการตั้งค่าบอร์ด POS/Hardware/Async tasks ในอนาคต)
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // หุ้มด้วย ProviderScope เพื่อรองรับ State Management ของ Riverpod ทั้งแอปพลิเคชัน
    const ProviderScope(
      child: ErpPosApp(),
    ),
  );
}

class ErpPosApp extends ConsumerWidget {
  const ErpPosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ดึงโครงสร้าง GoRouter ผ่าน appRouterProvider
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'ERP/POS Enterprise System',
      debugShowCheckedModeBanner: false,
      
      // ตั้งค่าระบบ Theme รองรับทั้ง Light และ Dark Mode
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // ปรับตามโหมดของระบบปฏิบัติการ
      
      // เชื่อมต่อการสลับหน้าจอด้วย GoRouter
      routerConfig: router,
    );
  }
}