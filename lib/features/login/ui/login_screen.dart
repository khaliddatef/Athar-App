import 'package:flutter/material.dart';
import 'package:sanad/core/theme/text_styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'شغلك من اول هنا 🙂',
          textDirection: TextDirection.rtl,
          style: TextStyles.cairoBold32Dark(context),
        ),
      ),
    );
  }
}
