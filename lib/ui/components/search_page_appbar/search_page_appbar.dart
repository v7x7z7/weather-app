import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/ui/ui_theme/app_colors.dart';
import 'package:weather_app/ui/ui_theme/app_style.dart';

import '../../../domain/provider/weather_provider.dart';

class SearchPageAppBar extends StatelessWidget {
  const SearchPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return SafeArea(
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.darkBlueColor,
                size: 26,
              ),
            ),
            SizedBox(
              width: 315,
              height: 35,
              child: TextFormField(
                controller: model.searchController,
                cursorColor: AppColors.darkBlueColor.withOpacity(1),
                decoration: InputDecoration(
                  hintText: 'Введите город/регион',
                  hintStyle: AppStyle.fontStyle.copyWith(
                    fontSize: 14,
                    color: const Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 15,
                  ),
                  fillColor: AppColors.textformColor.withOpacity(0.5),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                model.setCurrentCity(context);
              },
              icon: const Icon(
                Icons.search,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
