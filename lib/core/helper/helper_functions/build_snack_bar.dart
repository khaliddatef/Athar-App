import 'package:flutter/material.dart';

void buildSnackBar({
  required BuildContext context,
  required String text,
  int durationInSec = 3,
  Color? color,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(seconds: durationInSec),
      backgroundColor: color,
    ),
  );
}
