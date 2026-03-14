// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:yalla_kora/core/networking/api_service.dart';
// import 'package:yalla_kora/core/networking/dio_factory.dart';
// import 'package:yalla_kora/features/login/data/repo/login_repo.dart';
// import 'package:yalla_kora/features/login/logic/login_cubit.dart';
// import 'package:yalla_kora/features/signup/data/repo/signup_repo.dart';
// import 'package:yalla_kora/features/signup/data/repo/signup_repo_impl.dart';
// import 'package:yalla_kora/features/signup/logic/signup_cubit.dart';

// import '../../features/login/data/repo/login_repo_impl.dart';

// final getIt = GetIt.instance;
// Future<void> setupGetIt() async {
//   Dio dio = DioFactory.getDio();

//   getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

//   //login
//   getIt.registerLazySingleton<LoginRepo>(
//     () => LoginRepoImpl(apiService: getIt()),
//   );
//   getIt.registerLazySingleton<LoginCubit>(() => LoginCubit(getIt()));

//   //signup
//   getIt.registerLazySingleton<SignupRepo>(() => SignupRepoImpl(getIt()));
//   getIt.registerFactory<SignupCubit>(() => SignupCubit(getIt()));
// }
