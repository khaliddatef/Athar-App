import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/helper/responsive_extensions.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/routing/router.dart';
import '../../../core/widgets/app_button.dart';
import 'Widgets/dots_indicator.dart';
import 'Widgets/onboarding_page.dart';
import '../models/onboarding_model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnBoardingModel> _pages = const [
    OnBoardingModel(
      image: Assets.onboarding1,
      title: 'صوتك بينقذ حياة',
      description:
          'انضم لكتيبة التوعية و كن جزءاً من التغيير في مجتمعك، ساعدنا في نشر الوعي و بناء المستقبل',
      buttonText: 'التالي',
      titleStyleType: TitleStyleType.boldBlack,
      titleAlign: TextAlign.right,
    ),
    OnBoardingModel(
      image: Assets.onboarding2,
      title: 'الميدان والتكنولوجيا',
      description:
          'تتبع مناطق التوعية، سجل حضورك بالـ GPS، واشتغل حتى لو مفيش إنترنت',
      buttonText: 'التالي',
      titleStyleType: TitleStyleType.boldDark,
      titleAlign: TextAlign.center,
    ),
    OnBoardingModel(
      image: Assets.onboarding3,
      title: 'كن جزءاً من الحل',
      description: 'سجل الان و ابدأ رحلتك التوعوية مع منصة التوعية المصرية',
      buttonText: 'سجل الان',
      titleStyleType: TitleStyleType.boldDark,
      titleAlign: TextAlign.center,
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      GoRouter.of(context).push(AppRouter.klogin);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(Assets.backgroundSplashScreen, fit: BoxFit.cover),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: (index) =>
                          setState(() => _currentPage = index),
                      itemBuilder: (context, index) =>
                          OnBoardingPage(data: _pages[index]),
                    ),
                  ),
                  DotsIndicator(count: _pages.length, current: _currentPage),
                  verticalSpace(context, height: 32),
                  Padding(
                    padding: context.responsivePadding(horizontal: 24),
                    child: AppButton(
                      text: _pages[_currentPage].buttonText,
                      onPressed: _onNext,
                    ),
                  ),
                  verticalSpace(context, height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
