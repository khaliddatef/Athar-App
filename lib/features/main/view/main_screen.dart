import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sanad/core/helper/helper_functions/build_snack_bar.dart';
import 'package:sanad/core/routing/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../auth/model/auth_user.dart';
import '../../auth/view_model/controller/auth_controller.dart';
import '../../chats_and_community/ui/Widgets/chats_and_community_screen.dart';
import '../../home/view/home_screen.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/helper/responsive_extensions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  late final AuthController _authController;

  final List<Widget> screens = [
    Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.backgroundSplashScreen),
          fit: BoxFit.cover,
        ),
      ),
      child: const HomeScreen(),
    ),
    const MapScreen(),
    Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.backgroundSplashScreen),
          fit: BoxFit.cover,
        ),
      ),
      child: const ChatsAndCommunityScreen(),
    ),
    const AccountScreen(),
  ];

  Widget _svgIcon(BuildContext context, String path, bool isActive) {
    return SvgPicture.asset(
      path,
      width: 22.w(context),
      height: 22.h(context),
      colorFilter: ColorFilter.mode(
        isActive ? AppColors.primaryColor : AppColors.gray,
        BlendMode.srcIn,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _authController = context.read<AuthController>();
    Future.microtask(() => _authController.refreshProfile().catchError((_) {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              color: Colors.black12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w(context),
              vertical: 12.h(context),
            ),
            child: GNav(
              haptic: true,
              curve: Curves.easeOutExpo,
              duration: const Duration(milliseconds: 400),
              gap: 6.w(context),
              color: AppColors.gray,
              activeColor: AppColors.primaryColor,
              iconSize: 22.sp(context),
              tabBackgroundColor: AppColors.primaryColor.withOpacity(0.08),
              tabBorderRadius: 50.r(context),
              tabActiveBorder: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
                width: 1,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w(context),
                vertical: 10.h(context),
              ),
              selectedIndex: currentIndex,
              onTabChange: (index) => setState(() => currentIndex = index),
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  leading: _svgIcon(context, Assets.home, currentIndex == 0),
                  text: 'الرئيسية',
                  textStyle: TextStyles.cairoBold10Primary(context),
                ),
                GButton(
                  icon: Icons.map_outlined,
                  leading: _svgIcon(context, Assets.map, currentIndex == 1),
                  text: 'الخريطة',
                  textStyle: TextStyles.cairoBold10Primary(context),
                ),
                GButton(
                  icon: Icons.chat_bubble_outline,
                  leading: _svgIcon(
                    context,
                    Assets.messageCircle,
                    currentIndex == 2,
                  ),
                  text: 'محادثاتي',
                  textStyle: TextStyles.cairoBold10Primary(context),
                ),
                GButton(
                  icon: Icons.person_outline,
                  leading: _svgIcon(context, Assets.account, currentIndex == 3),
                  text: 'حسابي',
                  textStyle: TextStyles.cairoBold10Primary(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        final user = authController.currentUser;

        if (user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('حسابي')),
            body: const Center(child: Text('لا توجد بيانات مستخدم متاحة')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('حسابي')),
          body: RefreshIndicator(
            onRefresh: authController.refreshProfile,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _ProfileCard(user: user),
                const SizedBox(height: 16),
                _StatsCard(user: user),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: authController.isLoggingOut
                      ? null
                      : () async {
                          await authController.logout();

                          if (!context.mounted) {
                            return;
                          }

                          buildSnackBar(
                            context: context,
                            text: 'تم تسجيل الخروج بنجاح',
                            color: Colors.green,
                          );

                          context.go(AppRouter.klogin);
                        },
                  icon: authController.isLoggingOut
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout),
                  label: Text(
                    authController.isLoggingOut
                        ? 'جارٍ تسجيل الخروج...'
                        : 'تسجيل الخروج',
                  ),
                ),
                if (authController.isRefreshingProfile) ...[
                  const SizedBox(height: 12),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الخريطة")),
      body: const Center(child: Text("هذه شاشة الخريطة")),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.fullName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _InfoRow(label: 'الرقم القومي', value: user.nationalId),
            _InfoRow(label: 'البريد الإلكتروني', value: user.email),
            _InfoRow(label: 'الهاتف', value: user.phone),
            _InfoRow(label: 'الحالة', value: user.status),
            _InfoRow(label: 'المدينة', value: user.city ?? 'غير محددة'),
            _InfoRow(
              label: 'تاريخ الميلاد',
              value: _formatDate(user.dateOfBirth) ?? 'غير محدد',
            ),
            _InfoRow(
              label: 'تاريخ الانضمام',
              value: _formatDate(user.joinDate) ?? 'غير محدد',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('إحصائياتي', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _InfoRow(
              label: 'الحملات المنشأة',
              value: user.stats.campaignsCreated.toString(),
            ),
            _InfoRow(
              label: 'المهام المسندة',
              value: user.stats.assignedTasks.toString(),
            ),
            _InfoRow(label: 'الأوسمة', value: user.stats.badges.toString()),
            _InfoRow(label: 'عدد الساعات', value: user.totalHours.toString()),
            _InfoRow(label: 'النقاط', value: user.points.toString()),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}

String? _formatDate(DateTime? value) {
  if (value == null) {
    return null;
  }

  return value.toIso8601String().split('T').first;
}
