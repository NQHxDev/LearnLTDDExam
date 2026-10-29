import '../models/device.dart';
import 'api_client.dart';

class DeviceService {
  final ApiClient apiClient;

  DeviceService({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClient();

  Future<List<Device>> getDevices({
    int pageNumber = 1,
    int pageSize = 20,
    String? search,
    String? category,
  }) async {
    final queryParameters = <String, String>{
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
    };

    if (search != null && search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }

    if (category != null && category.trim().isNotEmpty) {
      queryParameters['category'] = category;
    }

    final query = Uri(queryParameters: queryParameters).query;

    final response = await apiClient.get(
      '/Devices?$query',
    );

    final data = response['data'];
    final items = data['items'] as List<dynamic>? ?? [];

    return items
        .map((item) => Device.fromJson(item))
        .toList();
  }

  Future<Device> getDevice(int id) async {
    final response = await apiClient.get('/Devices/$id');
    return Device.fromJson(response['data']);
  }

  Future<Device> createDevice({
    required String name,
    required String description,
    required String category,
    required double price,
    required String brand,
    required String modelNumber,
    required int stockQuantity,
    required int minAge,
    required int maxAge,
    String? imageUrl,
  }) async {
    final response = await apiClient.post(
      '/Devices',
      auth: true,
      body: {
        'name': name,
        'description': description,
        'category': category,
        'price': price,
        'brand': brand,
        'modelNumber': modelNumber,
        'imageUrl': imageUrl,
        'stockQuantity': stockQuantity,
        'minAge': minAge,
        'maxAge': maxAge,
      },
    );

    return Device.fromJson(response['data']);
  }

  Future<void> deleteDevice(int id) async {
    await apiClient.delete(
      '/Devices/$id',
      auth: true,
    );
  }
}