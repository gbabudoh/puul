import '../models/user_model.dart';
import '../services/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this.apiClient);

  Future<UserModel> register({
    String? phoneNumber,
    String? email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/register',
      data: {
        'phone_number': phoneNumber,
        'email': email,
        'password': password,
      },
    );

    await _apiClient.saveToken(response.data['token']);
    return UserModel.fromJson(response.data['user']);
  }

  Future<UserModel> login({
    String? phoneNumber,
    String? email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      data: {
        'phone_number': phoneNumber,
        'email': email,
        'password': password,
      },
    );

    await _apiClient.saveToken(response.data['token']);
    return UserModel.fromJson(response.data['user']);
  }

  Future<void> logout() async {
    await _apiClient.clearToken();
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get('/auth/me');
    return UserModel.fromJson(response.data);
  }
}
