import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/logger.dart';

class DioClient {
  late final Dio _dio;
  
  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.huggingFaceBaseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(ErrorHandlingInterceptor());
    _dio.interceptors.add(RetryInterceptor(_dio));
  }

  Dio get dio => _dio;
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Logger.debug('REQUEST[${options.method}] => PATH: ${options.path}');
    Logger.debug('Headers: ${options.headers}');
    if (options.data != null) {
      Logger.debug('Data: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.success(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logger.error(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      err.message,
    );
    handler.next(err);
  }
}

class ErrorHandlingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = _getErrorMessage(err);
    
    final modifiedError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: errorMessage,
      message: errorMessage,
    );
    
    handler.next(modifiedError);
  }

  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return '연결 시간이 초과되었습니다';
      case DioExceptionType.sendTimeout:
        return '요청 시간이 초과되었습니다';
      case DioExceptionType.receiveTimeout:
        return '응답 시간이 초과되었습니다';
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);
      case DioExceptionType.cancel:
        return '요청이 취소되었습니다';
      case DioExceptionType.connectionError:
        return '네트워크 연결을 확인해주세요';
      default:
        return '알 수 없는 오류가 발생했습니다';
    }
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '잘못된 요청입니다';
      case 401:
        return '인증이 필요합니다';
      case 403:
        return '접근이 거부되었습니다';
      case 404:
        return '요청한 리소스를 찾을 수 없습니다';
      case 500:
        return '서버 오류가 발생했습니다';
      case 503:
        return '서비스를 일시적으로 사용할 수 없습니다';
      default:
        return '서버 오류가 발생했습니다 (코드: $statusCode)';
    }
  }
}

class RetryInterceptor extends Interceptor {
  final Dio dio;
  int retryCount = 0;

  RetryInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && retryCount < ApiConstants.maxRetryAttempts) {
      retryCount++;
      Logger.info('Retrying request... (Attempt $retryCount/${ApiConstants.maxRetryAttempts})');
      
      await Future.delayed(ApiConstants.retryDelay);
      
      try {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        retryCount = 0;
      } catch (e) {
        handler.next(err);
      }
    } else {
      retryCount = 0;
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
           error.type == DioExceptionType.connectionError ||
           (error.response?.statusCode != null && 
            error.response!.statusCode! >= 500);
  }
}