// D:\erp_pos_system\apps\erp_pos_flutter\test\widget_test.dart
// หน้าที่: ชุดทดสอบ Widget (UI Automated Test) สำหรับตรวจสอบการทำงานและโครงสร้างพื้นฐานของแอปพลิเคชัน ERP/POS

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp_pos_flutter/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // รันแอปพลิเคชันโดยห่อด้วย ProviderScope เพื่อรองรับ Riverpod
    await tester.pumpWidget(
      const ProviderScope(
        child: ErpPosApp(),
      ),
    );

    // ตรวจสอบว่าแอปพลิเคชันเรนเดอร์สำเร็จโดยไม่เกิด Crash
    expect(find.byType(ErpPosApp), findsOneWidget);
  });
}