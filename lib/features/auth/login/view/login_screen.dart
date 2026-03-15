import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanad/features/auth/login/view/widget/login_body.dart';
import 'package:sanad/features/auth/login/view_model/controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LoginController(),
      builder: (context, child) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_splash_screen.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: LoginBody(),
          ),
        );
      },
    );
  }
}
