import 'package:dio/dio.dart';
import 'package:todo/core/constants/api_endpoint.dart';
import 'package:todo/core/network/dio_client.dart';
import 'package:todo/features/todo/model/todo_model.dart';

class TodoRepository {
  final DioClient _dioClient = DioClient();

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
    }
  }
}
