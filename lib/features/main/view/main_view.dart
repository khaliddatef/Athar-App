import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sanad/core/helper/helper_functions/build_snack_bar.dart';
import 'package:sanad/core/routing/router.dart';
import 'package:sanad/features/auth/model/auth_user.dart';
import 'package:sanad/features/auth/view_model/controller/auth_controller.dart';
import 'package:sanad/features/home/view/home_screen.dart';

// الشاشة الرئيسية اللي هتحوي كل البوتوم ناف والشاشات
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  late final AuthController _authController;

  final List<Widget> screens = [
    const HomeScreen(),
    const MapScreen(),
    const ChatScreen(),
    const AccountScreen(),
  ];

  final List<IconData> icons = [
    Icons.home_outlined,
    Icons.map_outlined,
    Icons.chat_bubble_outline,
    Icons.person,
  ];

  final List<String> labels = ["الرئيسية", "الخريطة", "محادثاتي", "حسابي"];

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
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            icons.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = index;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons[index],
                    color: currentIndex == index ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: currentIndex == index ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // indicator
                  Container(
                    height: 3,
                    width: 20,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? Colors.green
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================
// الشاشات المختلفة
// =====================

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        final user = authController.currentUser;

        if (user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("حسابي")),
            body: const Center(child: Text("لا توجد بيانات مستخدم متاحة")),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text("حسابي")),
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

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("محادثاتي")),
      body: const Center(child: Text("هذه شاشة المحادثات")),
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
