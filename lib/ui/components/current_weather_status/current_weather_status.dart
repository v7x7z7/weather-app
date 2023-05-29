import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/ui/ui_theme/app_colors.dart';
import 'package:weather_app/ui/ui_theme/app_style.dart';

class CurrentWeatherStatus extends StatelessWidget {
  const CurrentWeatherStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          model.iconData(),
          scale: 1.1,
          width: 50,
          // color: Colors.black,
        ),
        const SizedBox(width: 25),
        Text(
          model.getCurrentStatus(),
          style: AppStyle.fontStyle.copyWith(
            color: AppColors.darkBlueColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
