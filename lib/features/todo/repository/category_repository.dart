import 'package:dio/dio.dart';
import 'package:todo/core/constants/api_endpoint.dart';
import 'package:todo/core/network/dio_client.dart';
import 'package:todo/features/todo/model/category_model.dart';

class CategoryRepository {
  final DioClient _dioClient = DioClient();

  Future<List<CategoryModel>> fetchAllCategories() async {
    try{
      final response = await _dioClient.dio.get(ApiEndpoints.categories);

      if(response.statusCode == 200){
        final List<dynamic> rawList = response.data['data'];

        return rawList.map((json) => CategoryModel.fromJson(json)).toList();
      }else{
        throw Exception('Failed to fetch Category');
      }
    }on DioException catch(e){
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch Category');
    }
  }
}