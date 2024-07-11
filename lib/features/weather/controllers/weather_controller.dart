import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather/weather.dart';

import '../../../core/error/error_model.dart';
import '../../../core/state/app_state.dart';

class WeatherController extends GetxController {
  final currentState = Rx<AppState>(AppState.initial());
  final position = Rx<Position?>(null);
  final address = Rx<String?>(null);
  final lastRefreshed = Rx<DateTime?>(null);
  final WeatherFactory wf =
      WeatherFactory(dotenv.env['OPEN_WEATHER_MAP_API_KEY']!);
  final weather = Rx<Weather?>(null);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Future onInit() async {
    await getData();

    super.onInit();
  }

  Future getData() async {
    currentState.value = AppState.loading();
    try {
      position.value = await _determinePosition();
      weather.value = await _determineWeather();
      currentState.value = AppState.success();
    } catch (err) {
      currentState.value = AppState.error(
          error: ErrorModel(
              message: 'An error occurred, please try again later.'));
    }
    address.value = weather.value?.areaName;
    lastRefreshed.value = DateTime.now();
  }

  Future<Weather?> _determineWeather() async {
    if (position.value != null) {
      return await wf.currentWeatherByLocation(
          position.value!.latitude, position.value!.longitude);
    }
    return null;
  }

  Future<Position?> _determinePosition() async {
    await checkServiceEnabled();
    await requestPermission();

    return await Geolocator.getCurrentPosition();
  }

  Future requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future checkServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
  }
}
