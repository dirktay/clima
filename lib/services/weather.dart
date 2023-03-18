import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

import 'package:clima/utilities/debugging.dart';
import 'package:clima/services/api_const.dart';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    // final Uri httpUri = Uri.http(
    //   'api.openweathermap.org',
    //   'geo/1.0/direct',
    //   {
    //     'q': cityName,
    //     'limit': '$maxResults',
    //     'appid': apiKey,
    //   },
    // );
    // kDMprint(httpUri);
    final Uri httpsUri = Uri.https(
      'api.openweathermap.org',
      'data/2.5/weather',
      {
        'q':
            cityName, // {city name},{state code},{country code} *state code USA only
        //     'limit': '$maxResults',
        'units': 'metric',
        'appid': apiKey,
      },
    );
    kDMprint(httpsUri);

    NetworkHelper networkHelper = NetworkHelper(httpsUri);
    var weatherData = await networkHelper.getData();

    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    kDMprint(location);

    // const appId = 'b6907d289e10d714a6e88b30761fae22'; //temp/sample
    // get('https://samples.openweathermap.org/data/2.5/weather?lat=43.91&lon=-78.807&appid=$appId');
    // final Uri url = Uri(
    //   scheme: 'https',
    //   host: 'api.openweathermap.org',
    //   path: 'data/2.5/weather',
    //   query:
    //       'lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric',
    // );
    // kDMprint(url);
    final Uri httpsUri = Uri.https(
      'api.openweathermap.org',
      'data/2.5/weather',
      {
        'lat': '${location.latitude}',
        'lon': '${location.longitude}',
        'units': 'metric',
        'appid': apiKey,
      },
    );
    kDMprint(httpsUri);

    NetworkHelper networkHelper = NetworkHelper(httpsUri);
    var weatherData = await networkHelper.getData();

    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
