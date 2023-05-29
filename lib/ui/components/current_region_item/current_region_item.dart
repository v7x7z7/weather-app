import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/ui/ui_theme/app_colors.dart';
import 'package:weather_app/ui/ui_theme/app_style.dart';

import '../../../domain/provider/weather_provider.dart';

class CurrentRegionIem extends StatelessWidget {
  const CurrentRegionIem({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: AssetImage(
            model.setBg(),
          ),
          fit: BoxFit.cover,
        ),
      ),
      width: 382,
      height: 96,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CurrentRegionTimeZone(
            currentCity: model.weatherData?.timezone,
            currentZone: model.weatherData?.timezone,
          ),
          CurrentRegionTemp(
            icon: model.iconData(),
            currentTemp: model.setCurrentTemp(),
          ),
        ],
      ),
    );
  }
}

class CurrentRegionTemp extends StatelessWidget {
  const CurrentRegionTemp({
    super.key,
    required this.icon,
    required this.currentTemp,
  });
  final String icon;
  final int currentTemp;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(icon),
        Text(
          '$currentTemp ℃',
          style: AppStyle.fontStyle.copyWith(
            fontSize: 18,
            color: AppColors.darkBlueColor,
          ),
        ),
      ],
    );
  }
}

class CurrentRegionTimeZone extends StatelessWidget {
  const CurrentRegionTimeZone({
    super.key,
    required this.currentCity,
    required this.currentZone,
  });

  final String? currentCity, currentZone;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Текущее место',
          style: AppStyle.fontStyle.copyWith(
            color: AppColors.darkBlueColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          currentZone ?? 'Error',
          style: AppStyle.fontStyle.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.darkBlueColor,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          currentCity ?? 'Error',
          style: AppStyle.fontStyle.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.darkBlueColor,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
