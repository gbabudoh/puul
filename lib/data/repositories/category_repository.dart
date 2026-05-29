import '../models/category_model.dart';
import '../models/content_model.dart';
import '../services/api_client.dart';

class CategoryRepository {
  final ApiClient _apiClient;

  CategoryRepository(this._apiClient);

  Future<List<CategoryModel>> fetchActiveCategories() async {
    final response = await _apiClient.get('/categories');
    return (response.data as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }

  Future<CategoryModel> createCategory({
    required String name,
    required String categoryTag,
    String visibility = 'private',
  }) async {
    final response = await _apiClient.post(
      '/categories',
      data: {
        'name': name,
        'category_tag': categoryTag,
        'visibility': visibility,
      },
    );
    return CategoryModel.fromJson(response.data);
  }

  Future<CategoryModel> getCategoryDetails(String categoryId) async {
    final response = await _apiClient.get('/categories/$categoryId');
    return CategoryModel.fromJson(response.data);
  }

  Future<void> addMember(String categoryId, String userId) async {
    await _apiClient.post(
      '/categories/$categoryId/members',
      data: {'user_id': userId},
    );
  }

  Future<void> removeMember(String categoryId, String userId) async {
    await _apiClient.delete('/categories/$categoryId/members/$userId');
  }

  Future<List<ContentModel>> getCategoryContent(String categoryId) async {
    final response = await _apiClient.get('/categories/$categoryId/content');
    return (response.data as List)
        .map((json) => ContentModel.fromJson(json))
        .toList();
  }

  Future<void> deleteCategory(String categoryId) async {
    await _apiClient.delete('/categories/$categoryId');
  }
}
