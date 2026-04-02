import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  late Dio _dio;
  String? _authToken;

  /// Callback provided by AuthService to refresh tokens when needed.
  Future<bool> Function()? _onRefresh;

  bool _isRefreshing = false;

  /// Queue of requests waiting for token refresh to complete.
  final List<MapEntry<RequestOptions, Completer<Response>>> _queue = [];

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://127.0.0.1:8000/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('📤 API Request: ${options.method} ${options.path}');
          final authHeader = options.headers['Authorization']?.toString() ?? '';
          final masked = authHeader.replaceAll(RegExp(r'Bearer\s+\S{6,}'), 'Bearer ****');
          debugPrint('Auth header: present=${authHeader.isNotEmpty} value=$masked');
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          return handler.next(options);
        },

        onResponse: (response, handler) {
          debugPrint(
            '✅ API Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) async {
          final req = error.requestOptions;
          final status = error.response?.statusCode;
          debugPrint(
            '❌ API Error: ${status} ${req.path}',
          );
          debugPrint('   Error: ${error.message}');

          // Do not attempt to refresh token for refresh endpoint itself
          if (status == 401 && !_isRefreshPath(req.path) && _onRefresh != null) {
            if (!_isRefreshing) {
              _isRefreshing = true;
              try {
                final refreshed = await _onRefresh!();
                _isRefreshing = false;
                if (refreshed) {
                  // retry original request with new token
                  req.headers['Authorization'] = 'Bearer $_authToken';
                  try {
                    final response = await _dio.fetch(req);
                    handler.resolve(response);

                    // retry queued requests
                    for (var entry in _queue) {
                      try {
                        entry.key.headers['Authorization'] = 'Bearer $_authToken';
                        final r = await _dio.fetch(entry.key);
                        entry.value.complete(r);
                      } catch (e) {
                        entry.value.completeError(e);
                      }
                    }
                    _queue.clear();
                    return;
                  } catch (e) {
                    handler.next(error);
                    for (var entry in _queue) {
                      entry.value.completeError(e);
                    }
                    _queue.clear();
                    return;
                  }
                } else {
                  handler.next(error);
                  for (var entry in _queue) {
                    entry.value.completeError(error);
                  }
                  _queue.clear();
                  return;
                }
              } catch (e) {
                _isRefreshing = false;
                handler.next(error);
                for (var entry in _queue) {
                  entry.value.completeError(e);
                }
                _queue.clear();
                return;
              }
            } else {
              // already refreshing — queue this request until done
              final completer = Completer<Response>();
              _queue.add(MapEntry(req, completer));
              try {
                final resp = await completer.future;
                handler.resolve(resp);
                return;
              } catch (e) {
                handler.next(error);
                return;
              }
            }
          }

          return handler.next(error);
        },

      ),
    );
  }

  Dio get dio => _dio;

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  /// Provide a callback that will be invoked to refresh tokens when a 401 is encountered.
  void setRefreshTokenCallback(Future<bool> Function() cb) {
    _onRefresh = cb;
  }

  bool _isRefreshPath(String path) {
    return path.contains('/token/refresh');
  }
}

