// ==============================================================================
// File Path: D:\erp_pos_system\services\erp_pos_api\lib\config\database.dart
// Description: จัดการ Connection Pool สำหรับ MySQL / MariaDB (pb_erp)
// ==============================================================================

import 'package:mysql1/mysql1.dart';
import 'package:dotenv/dotenv.dart';

class DatabaseConfig {
  static final DatabaseConfig _instance = DatabaseConfig._internal();
  factory DatabaseConfig() => _instance;
  DatabaseConfig._internal();

  ConnectionSettings? _settings;

  Future<void> initialize() async {
    try {
      final env = DotEnv()..load();
      
      _settings = ConnectionSettings(
        host: env['DB_HOST'] ?? '127.0.0.1',
        port: int.parse(env['DB_PORT'] ?? '3306'),
        db: env['DB_NAME'] ?? 'pb_erp',
        user: env['DB_USER'] ?? 'pb_api',
        password: env['DB_PASSWORD'] ?? '1234',
      );

      // ทดสอบเชื่อมต่อครั้งแรก
      final conn = await MySqlConnection.connect(_settings!);
      await conn.close();

      print('🐬 [Database] MySQL/MariaDB (pb_erp) Connected successfully.');
    } catch (e) {
      print('❌ [Database Error] Failed to connect to MySQL: $e');
      rethrow;
    }
  }

  Future<MySqlConnection> getConnection() async {
    if (_settings == null) {
      throw StateError('❌ DatabaseConfig ยังไม่ได้เรียกใช้งาน initialize()');
    }
    return await MySqlConnection.connect(_settings!);
  }
}