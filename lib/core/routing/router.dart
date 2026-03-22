import 'package:go_router/go_router.dart';
import 'package:sanad/features/auth/forget/forget_view.dart';
import 'package:sanad/features/auth/login/view/login_screen.dart';
import 'package:sanad/features/auth/register/view/register_screen.dart';
import 'package:sanad/features/home/view/home_screen.dart';
import 'package:sanad/features/main/view/main_screen.dart';
import 'package:sanad/features/onboarding/ui/on_boarding_screen.dart';
import 'package:sanad/features/splash/ui/splash_screen.dart';

class AppRouter {
  static const kstart = '/star';
  static const klogin = '/login';
  static const kregister = '/register';
  static const kforget = '/forget';
  static const kmain = '/main';
  static const khome = '/home';
  static const konboarding = '/onboarding';

  static final GoRouter router = GoRouter(
    initialLocation: kstart,
    routes: [
      GoRoute(
        path: konboarding,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(path: kstart, builder: (context, state) => const SplashScreen()),
      GoRoute(path: kforget, builder: (context, state) => const ForgetView()),
      GoRoute(path: kmain, builder: (context, state) => const MainScreen()),
      GoRoute(path: khome, builder: (context, state) => const HomeScreen()),
      GoRoute(path: klogin, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: kregister,
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
}
