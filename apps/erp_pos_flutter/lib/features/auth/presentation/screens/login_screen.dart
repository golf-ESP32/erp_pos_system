// D:\erp_pos_system\apps\erp_pos_flutter\lib\features\auth\presentation\screens\login_screen.dart
// หน้าที่: หน้าจอลงชื่อเข้าใช้งานระบบ (Login Screen)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/focus_navigation_manager.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedBranch = 'สาขาหลัก (Main Branch)';
  
  late FocusNavigationManager _focusManager;

  @override
  void initState() {
    super.initState();
    _focusManager = FocusNavigationManager(
      configs: [
        FieldNavigationConfig(fieldKey: 'username', stepOrder: 1),
        FieldNavigationConfig(fieldKey: 'password', stepOrder: 2),
      ],
    );
  }

  @override
  void dispose() {
    _focusManager.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final success = ref.read(authControllerProvider.notifier).login(
      _usernameController.text,
      _passwordController.text,
      _selectedBranch,
    );
    if (success) {
      context.go('/item-master');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอก Username และ Password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.storefront, size: 64, color: Color(0xFF1E88E5)),
                    const SizedBox(height: 16),
                    Text(
                      'ERP/POS SYSTEM',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          authState.isOnline ? Icons.wifi : Icons.wifi_off,
                          size: 16,
                          color: authState.isOnline ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          authState.isOnline ? 'Online Sync Active' : 'Offline Mode (Local SQLite)',
                          style: TextStyle(
                            color: authState.isOnline ? Colors.green : Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedBranch,
                      decoration: const InputDecoration(
                        labelText: 'สาขา / Shift',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'สาขาหลัก (Main Branch)', child: Text('สาขาหลัก (Main Branch)')),
                        DropdownMenuItem(value: 'สาขา 2 (Rama 9)', child: Text('สาขา 2 (Rama 9)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedBranch = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      fieldKey: 'username',
                      labelText: 'Username',
                      controller: _usernameController,
                      focusManager: _focusManager,
                      prefixIcon: const Icon(Icons.person),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      fieldKey: 'password',
                      labelText: 'Password',
                      controller: _passwordController,
                      focusManager: _focusManager,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}