import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/hive/favorite_history.dart';
import 'package:weather_app/domain/hive/hive_boxes.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/ui/resources/app_bg.dart';
import 'package:weather_app/ui/ui_theme/app_colors.dart';
import 'package:weather_app/ui/ui_theme/app_style.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<Box<FavoriteHistory>>(
        valueListenable:
            Hive.box<FavoriteHistory>(HiveBoxes.favoriteBox).listenable(),
        builder: (context, value, _) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              return FavoriteCard(
                index: index,
                value: value,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: value.length,
          );
        },
      ),
    );
  }
}

class FavoriteCard extends StatelessWidget {
  const FavoriteCard({
    super.key,
    required this.index,
    required this.value,
  });
  final int index;

  final Box<FavoriteHistory> value;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(
            value.getAt(index)?.bg ?? AppBg.shinyDay,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CurrentFavoriteItems(index: index, value: value),
          IconButton(
            onPressed: () {
              model.deleteFav(index);
            },
            icon: Icon(
              Icons.delete,
              color: AppColors.redColor,
            ),
          ),
        ],
      ),
    );
  }
}

class CurrentFavoriteItems extends StatelessWidget {
  const CurrentFavoriteItems({
    super.key,
    required this.index,
    required this.value,
  });
  final int index;

  final Box<FavoriteHistory> value;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          value.getAt(index)?.cityName ?? 'Error',
          style: AppStyle.fontStyle.copyWith(
            fontSize: 18,
            color: AppColors.darkBlueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
