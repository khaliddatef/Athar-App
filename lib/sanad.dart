import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sanad/core/routing/router.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

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

          locale: const Locale('ar'),

          supportedLocales: const [
            Locale('ar'),
          ],

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
// class Sanad extends StatelessWidget {
//   const Sanad({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp.router(
//           title: 'Sanad',
//           debugShowCheckedModeBanner: false,
//           routerConfig: AppRouter.router,
//           // initialRoute: Routes.splashScreen,
//           // onGenerateRoute: AppRouter.generateRoute,
//         );
//       },
//     );
//   }
// }
