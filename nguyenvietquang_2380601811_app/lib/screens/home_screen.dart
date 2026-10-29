import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'devices_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController;

  const HomeScreen({
    super.key,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Devices'),
        actions: [
          IconButton(
            onPressed: () async {
              await authController.logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(
                    authController: authController,
                  ),
                ),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Xin chào, ${user.fullName}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text('Vai trò: ${user.role}'),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.devices),
              ),
              title: const Text('Quản lý thiết bị'),
              subtitle: const Text('Xem danh sách thiết bị'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DevicesScreen(
                      authController: authController,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.video_call),
              ),
              title: const Text('Video Call'),
              subtitle: const Text('Tính năng LiveKit sẽ tích hợp tiếp'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Video Call đang được chuẩn bị'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}