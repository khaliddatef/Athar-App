import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sanad/core/routing/router.dart';


class Sanad extends StatelessWidget {
  const Sanad({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Sanad',
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          // initialRoute: Routes.splashScreen,
          // onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}
