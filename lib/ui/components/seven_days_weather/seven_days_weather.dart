import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/ui/ui_theme/app_colors.dart';
import 'package:weather_app/ui/ui_theme/app_style.dart';

import '../../../domain/provider/weather_provider.dart';

class SevenDaysWeather extends StatelessWidget {
  const SevenDaysWeather({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<WeatherProvider>();
    return Container(
      height: 380,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.sevenDayColor,
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 34,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return SevenDaysWidget(
            text: model.date[index],
            daylyIcon: model.setDailyIcons(index),
            dayTemp: model.setDailyTemp(index),
            nightTemp: model.setNightTemp(index),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: 7,
      ),
    );
  }
}

class SevenDaysWidget extends StatelessWidget {
  const SevenDaysWidget({
    super.key,
    required this.text,
    required this.daylyIcon,
    this.dayTemp = 0,
    this.nightTemp = 0,
  });

  final String text;
  final String daylyIcon;
  final int dayTemp;
  final int nightTemp;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            text,
            style: AppStyle.fontStyle.copyWith(
              color: AppColors.darkBlueColor,
            ),
          ),
        ),
        const SizedBox(width: 30),
        Image.network(
          daylyIcon,
          width: 30,
          height: 30,
        ),
        const SizedBox(width: 20),
        Text(
          '$dayTemp℃',
          style: AppStyle.fontStyle.copyWith(
            color: AppColors.darkBlueColor,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$nightTemp℃',
          style: AppStyle.fontStyle,
        ),
      ],
    );
  }
}
