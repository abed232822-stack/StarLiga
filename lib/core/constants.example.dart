// ignore_for_file: non_constant_identifier_names
import 'package:dio/dio.dart';

/// Copy this file to `lib/core/constants/constatnts.dart` and configure your endpoints.
final String BaseUrl = 'https://api.yourdomain.com/api/';
final String ImagesBaseUrl = 'https://api.yourdomain.com';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: BaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);
