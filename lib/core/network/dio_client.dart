

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo/core/constants/api_endpoint.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,

        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),

        headers: {
          'Content-Type': 'application/json',
          'Accept' : 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (option, handler){
          return handler.next(option);
        },
        onResponse: (response, handler){
          return handler.next(response);
        },
        onError: (DioException e, handler){
          print('Network Error: ${e.message}');
          return handler.next(e);
        }
      )
    );
  }

  Dio get dio => _dio;
}