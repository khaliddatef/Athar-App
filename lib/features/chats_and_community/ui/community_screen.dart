import 'package:flutter/material.dart';

import '../../../core/helper/responsive_extensions.dart';
import '../../../core/helper/spacing.dart';
import 'widget_community/add_post_button.dart';
import 'widget_community/announcement_card.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: context.responsivePadding(vertical: 16.h(context)),
          children: [
            const AnnouncementCard(
              title: 'إعلان من الإدارة',
              body: 'موعد حملة الجيزة الكبرى تغير إلى الجمعة 20 مارس',
              timeAgo: 'منذ ساعتين',
            ),
            verticalSpace(context, height: 12),
            verticalSpace(context, height: 72),
          ],
        ),

        AddPostButton(
          onTap: () {},
        ),
      ],
    );
  }
}
