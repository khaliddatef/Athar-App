import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/constants/app_images.dart';

class ScheduledTaskCard extends StatelessWidget {
  final String time;
  final String remainingTime;
  final String locationName;
  final String taskType;

  const ScheduledTaskCard({
    super.key,
    required this.time,
    required this.remainingTime,
    required this.locationName,
    required this.taskType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.responsivePadding(horizontal: 14, vertical: 16),
      decoration: ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r(context)),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Right (RTL start): Icon + Location info
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Map pin icon circle
                Container(
                  width: 40.w(context),
                  height: 40.w(context),
                  decoration: ShapeDecoration(
                    color: AppColors.iconBackgroundGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      Assets.imageMapPin,
                      width: 24.w(context),
                      height: 24.w(context),
                    ),
                  ),
                ),
                horizontalSpace(context, width: 8),
                // Location name + task type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      locationName,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14.sp(context),
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      taskType,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.secondaryGray,
                        fontSize: 10.sp(context),
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Left (RTL end): Time info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 12.sp(context),
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  remainingTime,
                  style: TextStyle(
                    color: AppColors.secondaryGray,
                    fontSize: 10.sp(context),
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// -------------------------
/// اسم الصفحة المقترح: ScheduledTasksPage
/// -------------------------

class ScheduledTasksPage extends StatelessWidget {
  const ScheduledTasksPage({super.key});

  // بيانات تجريبية — استبدلها بالداتا الحقيقية
  static const List<Map<String, String>> _tasks = [
    {
      'time': 'AM 10:00',
      'remaining': 'متبقي 2س',
      'location': 'منطقة أكتوبر السكنية',
      'type': 'مهمة ميدانية سريعة',
    },
    {
      'time': 'PM 2:30',
      'remaining': 'متبقي 6س',
      'location': 'حي المعادي - شارع 9',
      'type': 'دعم لوجستي و توزيع',
    },
    // أضف المزيد حسب الحاجة
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: ListView.separated(
        padding: context.responsivePadding(horizontal: 16, vertical: 16),
        itemCount: _tasks.length,
        // ignore: unnecessary_underscores
        separatorBuilder: (_, __) => verticalSpace(context, height: 12),
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ScheduledTaskCard(
            time: task['time']!,
            remainingTime: task['remaining']!,
            locationName: task['location']!,
            taskType: task['type']!,
          );
        },
      ),
    );
  }
}
