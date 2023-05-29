import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/ui/ui_theme/app_colors.dart';
import 'package:weather_app/ui/ui_theme/app_style.dart';

import '../../../domain/provider/weather_provider.dart';

class WeatherAppBar extends StatelessWidget {
  const WeatherAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 100),
            Icon(
              Icons.location_on,
              color: AppColors.redColor,
            ),
            GestureDetector(
              onDoubleTap: () {
                model.setFavorite(
                  context,
                  cityName: model.weatherData?.timezone,
                );
              },
              child: Center(
                child: Text(
                  '${model.weatherData?.timezone}',
                  style: AppStyle.fontStyle.copyWith(
                    color: AppColors.darkBlueColor,
                  ),
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              icon: Icon(
                Icons.add,
                color: AppColors.darkBlueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
