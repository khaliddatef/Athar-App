// // ignore_for_file: constant_identifier_names

// import 'package:dio/dio.dart';
// import 'package:yalla_kora/core/networking/api_constants.dart';
// import 'package:yalla_kora/core/networking/api_error_model.dart';

// /// ================================
// /// Data Source enum (المكان اللي جه منه الخطأ)
// /// ================================
// enum DataSource {
//   SUCCESS,
//   NO_CONTENT,
//   BAD_REQUEST,
//   FORBIDDEN,
//   UNAUTHORIZED,
//   NOT_FOUND,
//   CONFLICT,
//   INTERNAL_SERVER_ERROR,
//   CONNECT_TIMEOUT,
//   CANCEL,
//   RECEIVE_TIMEOUT,
//   SEND_TIMEOUT,
//   CACHE_ERROR,
//   NO_INTERNET_CONNECTION,
//   DEFAULT,
// }

// /// ================================
// /// Extension to convert DataSource → ApiErrorModel
// /// ================================
// extension DataSourceExtension on DataSource {
//   ApiErrorModel getFailure() {
//     switch (this) {
//       case DataSource.BAD_REQUEST:
//         return ApiErrorModel(message: ApiErrors.badRequestError, code: 400);

//       case DataSource.FORBIDDEN:
//         return ApiErrorModel(message: ApiErrors.forbiddenError, code: 403);

//       case DataSource.UNAUTHORIZED:
//         return ApiErrorModel(message: ApiErrors.unauthorizedError, code: 401);

//       case DataSource.NOT_FOUND:
//         return ApiErrorModel(message: ApiErrors.notFoundError, code: 404);

//       case DataSource.CONFLICT:
//         return ApiErrorModel(message: ApiErrors.conflictError, code: 409);

//       case DataSource.INTERNAL_SERVER_ERROR:
//         return ApiErrorModel(message: ApiErrors.internalServerError, code: 500);

//       case DataSource.CONNECT_TIMEOUT:
//       case DataSource.SEND_TIMEOUT:
//       case DataSource.RECEIVE_TIMEOUT:
//         return ApiErrorModel(message: ApiErrors.timeoutError, code: 408);

//       case DataSource.CANCEL:
//         return ApiErrorModel(message: ApiErrors.defaultError, code: 0);

//       case DataSource.NO_INTERNET_CONNECTION:
//         return ApiErrorModel(message: ApiErrors.noInternetError, code: 0);

//       case DataSource.DEFAULT:
//       default:
//         return ApiErrorModel(message: ApiErrors.defaultError, code: 0);
//     }
//   }
// }

// /// ================================
// /// Error Handler class EXACT like instructor
// /// ================================
// class ErrorHandler implements Exception {
//   late ApiErrorModel apiErrorModel;

//   ErrorHandler.handle(dynamic error) {
//     if (error is DioException) {
//       apiErrorModel = _handleDioError(error);
//     } else {
//       apiErrorModel = DataSource.DEFAULT.getFailure();
//     }
//   }

//   ApiErrorModel _handleDioError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//         return DataSource.CONNECT_TIMEOUT.getFailure();

//       case DioExceptionType.sendTimeout:
//         return DataSource.SEND_TIMEOUT.getFailure();

//       case DioExceptionType.receiveTimeout:
//         return DataSource.RECEIVE_TIMEOUT.getFailure();

//       case DioExceptionType.badCertificate:
//       case DioExceptionType.cancel:
//         return DataSource.CANCEL.getFailure();

//       case DioExceptionType.badResponse:
//         try {
//           return ApiErrorModel.fromJson(error.response?.data);
//         } catch (_) {
//           return DataSource.DEFAULT.getFailure();
//         }

//       case DioExceptionType.connectionError:
//         return DataSource.NO_INTERNET_CONNECTION.getFailure();

//       case DioExceptionType.unknown:
//         return DataSource.DEFAULT.getFailure();
//     }
//   }
// }
