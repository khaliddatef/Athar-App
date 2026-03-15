import 'package:flutter/material.dart';


class HeaderAuth extends StatelessWidget {
  const HeaderAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Image.asset(
          "assets/images/sanad.png",
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}