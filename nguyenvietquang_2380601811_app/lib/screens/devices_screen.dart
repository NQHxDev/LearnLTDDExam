import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/device_controller.dart';
import '../widgets/device_card.dart';
import 'device_form_screen.dart';

class DevicesScreen extends StatefulWidget {
  final AuthController authController;

  const DevicesScreen({
    super.key,
    required this.authController,
  });

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final deviceController = DeviceController();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    deviceController.loadDevices();
  }

  Future<void> _search() async {
    await deviceController.loadDevices(
      search: searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.authController.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thiết bị'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeviceFormScreen(
                      deviceController: deviceController,
                    ),
                  ),
                );

                deviceController.loadDevices();
              },
            ),
        ],
      ),
      body: ListenableBuilder(
        listenable: deviceController,
        builder: (_, __) {
          if (deviceController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => deviceController.loadDevices(
              search: searchController.text,
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm thiết bị...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onSubmitted: (_) => _search(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _search,
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (deviceController.errorMessage != null)
                  Text(
                    deviceController.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                if (deviceController.devices.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                      child: Text('Không có thiết bị'),
                    ),
                  ),
                ...deviceController.devices.map(
                  (device) => DeviceCard(
                    device: device,
                    isAdmin: isAdmin,
                    onDelete: isAdmin
                        ? () async {
                            final deleted =
                                await deviceController.deleteDevice(device.id);

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  deleted
                                      ? 'Đã xóa thiết bị'
                                      : 'Xóa thiết bị thất bại',
                                ),
                              ),
                            );
                          }
                        : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}