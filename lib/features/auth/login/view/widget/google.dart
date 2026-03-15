import 'package:flutter/material.dart';

class GoogleLoginButton extends StatelessWidget {
 



  GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () async {
          
          },
          child: Container(
            width: 60,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xffECECEC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset("assets/images/googlee.png"),
          ),
        ),
      ],
    );
  }
}
