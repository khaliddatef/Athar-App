import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanad/features/auth/login/view_model/controller/login_controller.dart';
import 'package:sanad/features/auth/register/view/widget/register_body.dart';
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
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
            child: RegisterBody(),
          ),
        );
      },
    );
  }
}

