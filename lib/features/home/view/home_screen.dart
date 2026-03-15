
import 'package:flutter/material.dart';
import 'package:sanad/features/home/view/widget/custom_nav.dart';
import 'package:sanad/features/home/view/widget/header_section.dart';
import 'package:sanad/features/home/view/widget/news_section.dart';
import 'package:sanad/features/home/view/widget/sos_button.dart';
import 'package:sanad/features/home/view/widget/status_card.dart';
import 'package:sanad/features/home/view/widget/task_section.dart';
// الشاشة الرئيسية اللي هتحوي كل البوتوم ناف والشاشات

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_splash_screen.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              HeaderSection(),
              SizedBox(height: 20),
              SOSButton(),
              SizedBox(height: 20),
              StatsSection(),
              SizedBox(height: 20),
              NewsSection(),
              SizedBox(height: 20),
              TasksSection(),
            ],
          ),
        ),
      ),
    );
  }
}