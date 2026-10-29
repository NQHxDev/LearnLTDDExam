import '../models/user.dart';
import 'api_client.dart';
import 'storage_service.dart';

class AuthService {
  final ApiClient apiClient;
  final StorageService storageService;

  AuthService({
    ApiClient? apiClient,
    StorageService? storageService,
  })  : apiClient = apiClient ?? ApiClient(),
        storageService = storageService ?? StorageService();

  Future<User> login({
    required String username,
    required String password,
  }) async {
    final response = await apiClient.post(
      '/Auth/login',
      body: {
        'username': username,
        'password': password,
      },
    );

    final data = response['data'];
    final token = data['token'] as String;
    final user = User.fromJson(data['user']);

    await storageService.saveAuth(
      token: token,
      userId: user.id,
      username: user.username,
      role: user.role,
    );

    return user;
  }

  Future<User> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    final response = await apiClient.post(
      '/Auth/register',
      body: {
        'username': username,
        'email': email,
        'password': password,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
      },
    );

    final data = response['data'];
    final token = data['token'] as String;
    final user = User.fromJson(data['user']);

    await storageService.saveAuth(
      token: token,
      userId: user.id,
      username: user.username,
      role: user.role,
    );

    return user;
  }

  Future<User> getCurrentUser() async {
    final response = await apiClient.get(
      '/Auth/me',
      auth: true,
    );

    return User.fromJson(response['data']);
  }

  Future<void> logout() async {
    await storageService.clear();
  }
}