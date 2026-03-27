import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static String get baseUrl {
    // Для web используем 127.0.0.1 вместо localhost из-за CORS
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    } else {
      return 'http://10.0.2.2:8000/api'; // эмулятор Android
    }
  }

  final Dio dio;

  ApiClient({String? baseUrl})
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? ApiClient.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          validateStatus: (status) {
            // Не выбрасываем исключения на 401, 400 и т.д.
            return status != null && status < 500;
          },
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('📤 API Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onError: (err, handler) {
          print('❌ API Error: ${err.message}');
          return handler.next(err);
        },
        onResponse: (response, handler) {
          print(
            '✅ API Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
      ),
    );
  }
}
