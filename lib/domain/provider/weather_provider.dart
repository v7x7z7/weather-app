import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/domain/api/api.dart';
import 'package:weather_app/domain/hive/favorite_history.dart';
import 'package:weather_app/domain/hive/hive_boxes.dart';
import 'package:weather_app/domain/json_convertors/coord.dart';
import 'package:weather_app/domain/json_convertors/weather_data.dart';
import 'package:weather_app/ui/constants/constants.dart';
import 'package:weather_app/ui/resources/app_bg.dart';
import 'package:weather_app/ui/ui_theme/app_colors.dart';
import 'package:weather_app/ui/ui_theme/app_style.dart';

class WeatherProvider extends ChangeNotifier {
  //храниние координат
  static Coord? _coords;
  Coord? get coords => _coords;

  //хранение данных о погоде
  WeatherData? weatherData;

  //хранение текущих данных о погоде
  Current? current;

  //контроллер ввода для поиска
  TextEditingController searchController = TextEditingController();

  Future<WeatherData?> setUp({String? cityName}) async {
    final pref = await SharedPreferences.getInstance();

    cityName = pref.getString('city_name');
    // pref.clear();

    _coords = await Api.getCoords(cityName: cityName ?? 'Ташкент');
    weatherData = await Api.getWeather(coords);
    current = weatherData?.current;
    setCurrentTime();
    setCurrentTemp();
    setSevenDays();
    return weatherData;
  }

  // изменение заднего фона
//https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2
  String? currentBg;

  String setBg() {
    int id = current?.weather?[0].id ?? -1;
    if (id == -1 || current?.sunset == null || current?.dt == null) {
      currentBg = AppBg.shinyDay;
    }

    try {
      if (current?.sunset < current?.dt) {
        if (id >= 200 && id <= 531) {
          currentBg = AppBg.rainyNight;
        } else if (id >= 600 && id <= 622) {
          currentBg = AppBg.snowNight;
        } else if (id >= 701 && id <= 781) {
          currentBg = AppBg.fogNight;
        } else if (id == 800) {
          currentBg = AppBg.shinyNight;
        } else if (id >= 801 && id <= 804) {
          currentBg = AppBg.cloudyNight;
        }
      } else {
        if (id >= 200 && id <= 531) {
          currentBg = AppBg.rainyDay;
        } else if (id >= 600 && id <= 622) {
          currentBg = AppBg.snowDay;
        } else if (id >= 701 && id <= 781) {
          currentBg = AppBg.fogDay;
        } else if (id == 800) {
          currentBg = AppBg.shinyDay;
        } else if (id >= 801 && id <= 804) {
          currentBg = AppBg.cloudyDay;
        }
      }
    } catch (e) {
      return AppBg.shinyDay;
    }

    return currentBg ?? AppBg.shinyDay;
  }

  // текущее время

  String? currentTime;

  String setCurrentTime() {
    final getTime = (current?.dt ?? 0) + (weatherData?.timezoneOffset ?? 0);
    // print(getTime);
    final setTime = DateTime.fromMillisecondsSinceEpoch(getTime * 1000);
    // print(setTime);
    currentTime = DateFormat('HH:mm a').format(setTime);
    print(currentTime);

    return currentTime ?? 'Error';
  }

  // получение текущей иконки в зависимости от погоды
  String iconData() {
    return '${Constants.weatherIconsUrl}${current?.weather?[0].icon}.png';
  }

// текущий статус погоды

  String currentStatus = 'Ошибка';

  String getCurrentStatus() {
    currentStatus = current?.weather?[0].description ?? 'Ошибка';
    return capitalize(currentStatus);
  }

//метод превращения первой буквы слова в заглавную

  String capitalize(String str) => str[0].toUpperCase() + str.substring(1);

// приведение градусов погоды в цельсию

  int kelvin = -273;
  int currentTemp = 0;

//обработка текущей температуры

  int setCurrentTemp() {
    currentTemp = ((current?.temp ?? -kelvin) + kelvin).round();
    return currentTemp;
  }

//max температура

  int maxTemp = 0;

  String setMaxTemp() {
    maxTemp = ((weatherData?.daily?[0].temp?.max ?? -kelvin) + kelvin).round();
    return maxTemp.toString();
  }

//min temp

  int minTemp = 0;

  String setMinTemp() {
    minTemp = ((weatherData?.daily?[0].temp?.min ?? -kelvin) + kelvin).round();
    return minTemp.toString();
  }

// установка дней недели

  final List<String> date = [];
  List<Daily> daily = [];

  void setSevenDays() {
    daily = weatherData!.daily!;
    for (var i = 0; i < daily.length; i++) {
      if (i == 0 && daily.isNotEmpty) {
        date.clear();
      }

      if (i == 0) {
        date.add('Сегодня');
      } else {
        var timeNum = daily[i].dt * 1000;
        var itemDate = DateTime.fromMillisecondsSinceEpoch(timeNum);
        date.add(capitalize(DateFormat('EEEE', 'ru').format(itemDate)));
      }
    }
  }

// установка иконок по дням недели

  final String iconUrlPath = 'http://openweathermap.org/img/wn/';
  String setDailyIcons(int index) {
    final String getIcon = '${weatherData?.daily?[index].weather?[0].icon}';
    final String setIcon = '$iconUrlPath$getIcon.png';
    return setIcon;
  }

  // получение дневной температуры на каждый день
  int dailyTemp = 0;
  int setDailyTemp(int index) {
    dailyTemp =
        ((weatherData?.daily?[index].temp?.morn ?? -kelvin) + kelvin).round();
    return dailyTemp;
  }

  //получение ночной температуры на каждый день

  int nightTemp = 0;
  int setNightTemp(int index) {
    nightTemp =
        ((weatherData?.daily?[index].temp?.night ?? -kelvin) + kelvin).round();
    return nightTemp;
  }

  // получение в массив данных о погодных условиях
  final List<dynamic> weatherValues = [];
  dynamic setValues(int index) {
    weatherValues.add(current?.windSpeed ?? 0);
    weatherValues
        .add(((current?.feelsLike ?? -kelvin) + kelvin).roundToDouble());
    weatherValues.add(current?.humidity ?? 0);
    weatherValues.add((current?.visibility ?? 0) / 1000);
    return weatherValues[index];
  }

// текущее время восхода

  String sunRise = '';

  String setCurrentSunRise() {
    final getSunTime =
        (current?.sunrise ?? 0) + (weatherData?.timezoneOffset ?? 0);
    final setSunRise = DateTime.fromMicrosecondsSinceEpoch(getSunTime * 1000);
    sunRise = DateFormat('HH:mm a').format(setSunRise);

    return sunRise;
  }

  String sunSet = '';

  String setCurrentSunSet() {
    final getSunTime =
        (current?.sunset ?? 0) + (weatherData?.timezoneOffset ?? 0);
    final setSunSet = DateTime.fromMicrosecondsSinceEpoch(getSunTime * 1000);
    sunSet = DateFormat('HH:mm a').format(setSunSet);

    return sunSet;
  }

// установка текущего города
  void setCurrentCity(BuildContext context, {String? cityName}) async {
    if (searchController.text != null && searchController.text != '') {
      cityName = searchController.text;
      final pref = await SharedPreferences.getInstance();
      await pref.setString('city_name', cityName);
      await setUp(cityName: pref.getString('city_name'))
          .then((value) => Navigator.pop(context))
          .then((value) => searchController.clear());
      notifyListeners();
    }
  }

  // добавление в избранное

  Future<void> setFavorite(BuildContext context, {String? cityName}) async {
    var box = Hive.box<FavoriteHistory>(HiveBoxes.favoriteBox);

    box
        .add(
          FavoriteHistory(
            weatherData?.timezone ?? 'Error',
            currentBg ?? AppBg.shinyDay,
            AppColors.darkBlueColor.value,
          ),
        )
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Город $cityName добавлен в избранное',
                style: AppStyle.fontStyle,
              ),
            ),
          ),
        );
  }

  // удаление из избранных 
  Future<void> deleteFav(int index)async{
    var box = Hive.box<FavoriteHistory>(HiveBoxes.favoriteBox);
    box.deleteAt(index);
  }
}
