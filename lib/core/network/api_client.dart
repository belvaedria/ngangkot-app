import 'package:dio/dio.dart';

class ApiClient {
  // Untuk Flutter Web di Chrome, Laravel lokal bisa diakses
  // menggunakan alamat loopback laptop.
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }
}