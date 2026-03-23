import 'package:flutter/material.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'stat_card.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'عدد الساعات',
            value: '120',
            valueStyle: TextStyles.cairoBold24Primary(context),
          ),
        ),
        horizontalSpace(context, width: 15),
        Expanded(
          child: StatCard(
            title: 'انجازاتي',
            value: '450',
            valueStyle: TextStyles.cairoBold24Orange(context),
          ),
        ),
      ],
    );
  }
}
