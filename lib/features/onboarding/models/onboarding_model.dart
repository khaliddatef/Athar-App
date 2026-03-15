import 'package:flutter/material.dart';

enum TitleStyleType { boldBlack, boldDark }

class OnBoardingModel {
  final String image;
  final String title;
  final String description;
  final String buttonText;
  final TitleStyleType titleStyleType;
  final TextAlign titleAlign;

  const OnBoardingModel({
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.titleStyleType,
    required this.titleAlign,
  });
}