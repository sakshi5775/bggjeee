enum ApiStatus { loading, success, error }

class ApiResponse<T> {
  final ApiStatus status;
  final T? data;
  final String? message;
  final ErrorType? errorType;
  final String? errorCode;

  ApiResponse({
    required this.status,
    this.data,
    this.message,
    this.errorType,
    this.errorCode,
  });

  factory ApiResponse.loading() => ApiResponse(status: ApiStatus.loading);

  factory ApiResponse.success(T data, {String? message}) =>
      ApiResponse(status: ApiStatus.success, data: data, message: message);

  factory ApiResponse.error(String message, {ErrorType? type, String? code}) =>
      ApiResponse(
        status: ApiStatus.error,
        message: message,
        errorType: type ?? ErrorType.unknown,
        errorCode: code,
      );

  bool get isLoading => status == ApiStatus.loading;
  bool get isSuccess => status == ApiStatus.success;
  bool get isError => status == ApiStatus.error;
}

enum ErrorType {
  network,
  timeout,
  server,
  unauthorized,
  validation,
  notFound,
  conflict,
  runtime,
  unknown,
}
