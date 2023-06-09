import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

import '../services/weather.dart';
import '../utilities/debugging.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, this.locationWeather});

  final dynamic locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late int temperature;
  late String weatherIcon;
  late String weatherMessage;
  late String locale;
  WeatherModel weather = WeatherModel();

  @override
  void initState() {
    super.initState();
    kDMprint('LocationScreen.initState()');
    // kDMprint('widget.locationWeather:\n${widget.locationWeather}');
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        locale = '';
      } else {
        temperature = weatherData['main']['temp'].round();
        var weatherId = weatherData['weather'][0]['id'];
        weatherIcon = weather.getWeatherIcon(weatherId);
        weatherMessage = weather.getMessage(temperature);
        locale = weatherData['name'];
      }
    });
    kDMprint(
        'temperature: $temperature, weatherIcon: $weatherIcon, locale: $locale');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var cityName = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const CityScreen();
                      }));
                      kDMprint('cityName: $cityName');

                      if (cityName == null) {
                        updateUI(null);
                      } else {
                        var weatherData =
                            await weather.getCityWeather(cityName);
                        updateUI(weatherData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      // '${(temperature - 273.15).toStringAsFixed(0)}°',
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      // '☀️',
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  // "It's 🍦 time in $locale!",
                  '$weatherMessage${locale.isEmpty ? '' : ' in $locale'}!',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
