import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/ui/ui_theme/app_colors.dart';
import 'package:weather_app/ui/ui_theme/app_style.dart';

class MaxMinTemp extends StatelessWidget {
  const MaxMinTemp({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<WeatherProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/arrow_up.svg',
          color: AppColors.redColor,
        ),
        const SizedBox(width: 4),
        Text(
          '${model.setMaxTemp()}°',
          style: AppStyle.fontStyle.copyWith(
            fontSize: 25,
            color: AppColors.darkBlueColor,
          ),
        ),
        const SizedBox(width: 65),
        SvgPicture.asset(
          'assets/icons/arrow_down.svg',
          color: AppColors.darkBlueColor,
        ),
        const SizedBox(width: 4),
        Text(
          '${model.setMinTemp()}°',
          style: AppStyle.fontStyle.copyWith(
            fontSize: 25,
            color: AppColors.darkBlueColor,
          ),
        ),
      ],
    );
  }
}
