import 'package:dio/dio.dart';
import 'package:todo/core/constants/api_endpoint.dart';
import 'package:todo/core/network/dio_client.dart';
import 'package:todo/features/todo/model/todo_model.dart';

class TodoRepository {
  final DioClient _dioClient = DioClient();

  // Fetch List
  Future<List<TodoModel>> fetchAllTodos() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.todos);

      if (response.statusCode == 200) {
        final List<dynamic> rawList = response.data['data']['data'];

        return rawList.map((json) => TodoModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat daftar Todo');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Terjadi kesalahan jaringan',
      );
    } // DioException
  } //Future Fetch

  Future<bool> createTodo({
    required String title,
    required String description,
    required DateTime dueDate,
    required int categoryId,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.todos,
        data: {
          'title': title,
          'description': description,
          'due_date': dueDate.toUtc().toIso8601String(),
          'category': categoryId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create todo');
    }
  } //future Create
} //TodoRepository
