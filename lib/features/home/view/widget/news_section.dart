import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/constants/app_images.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';

class NewsSection extends StatelessWidget {
  const NewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "آخر الأخبار والتنبيهات",
              style: TextStyles.cairoBold18Black2(context),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'عرض الكل',
                style: TextStyles.cairoRegular12Primary(context),
              ),
            ),
          ],
        ),
        verticalSpace(context, height: 16),
        SizedBox(
          height: 120.h(context),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (context, index) =>
                horizontalSpace(context, width: 12),
            itemBuilder: (context, index) {
              return const NewsCard();
            },
          ),
        ),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310.w(context),
      padding: EdgeInsets.symmetric(
        horizontal: 8.w(context),
        vertical: 16.h(context),
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGreenishWhite,
        borderRadius: BorderRadius.circular(12.r(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r(context)),
            child: Image.asset(
              Assets.imageNews,
              width: 80.w(context),
              height: 88.h(context),
              fit: BoxFit.cover,
            ),
          ),
          horizontalSpace(context, width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'حملة التوعية الجديدة في الجيزة',
                  style: TextStyles.cairoBold14Black2(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpace(context, height: 4),
                Text(
                  'شارك في تحسين الوعي \nالمجتمعي في المناطق السكنية',
                  style: TextStyles.cairoRegular12DescriptionGray(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
