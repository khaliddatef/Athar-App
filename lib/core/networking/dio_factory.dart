// import 'package:dio/dio.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// import 'package:yalla_kora/core/networking/api_constants.dart';

// class DioFactory {
//   //** */ =>> This class is implemented using the Singleton Pattern <<= ** //

//   DioFactory._(); // => Private Constructor
//   //no object
//   static Dio? dio;
//   static Dio getDio() {
//     Duration timeout = const Duration(seconds: 15);
//     if (dio == null) {
//       dio = Dio(
//         BaseOptions(
//           baseUrl: ApiConstants.baseURL,
//           connectTimeout: timeout,
//           receiveTimeout: timeout,
//         ),
//       );
//       addDioInterceptor();
//     }
//     return dio!;
//   }

//   static void addDioInterceptor() {
//     dio?.interceptors.add(
//       PrettyDioLogger(
//         requestBody: true,
//         requestHeader: true,
//         responseBody: true,
//       ),
//     );
//   }
// }
