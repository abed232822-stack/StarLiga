import 'package:dio/dio.dart';

abstract class DataState<T> {
  final T? data;
  final DioException? error;
  final String? message;
  const DataState({this.data, this.error, this.message});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed({super.error, super.message});
}