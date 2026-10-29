import 'package:flutter/material.dart';
import 'controllers/auth_controller.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChildDevicesApp());
}

class ChildDevicesApp extends StatefulWidget {
  const ChildDevicesApp({super.key});

  @override
  State<ChildDevicesApp> createState() => _ChildDevicesAppState();
}

class _ChildDevicesAppState extends State<ChildDevicesApp> {
  final authController = AuthController();
  bool checkingSession = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final storage = StorageService();
    final loggedIn = await storage.isLoggedIn();

    if (loggedIn) {
      try {
        authController.currentUser =
            await authController.authService.getCurrentUser();
      } catch (_) {
        await authController.logout();
      }
    }

    if (mounted) {
      setState(() {
        checkingSession = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Child Devices',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1769FF),
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF5F7FA),
        ),
      ),
      home: checkingSession
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : authController.isLoggedIn
              ? HomeScreen(authController: authController)
              : LoginScreen(authController: authController),
    );
  }
}