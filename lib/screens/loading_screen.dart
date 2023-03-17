import 'package:clima/screens/location_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

import '../utilities/debugging.dart';
import 'api_const.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    // const appId = 'b6907d289e10d714a6e88b30761fae22'; //temp/sample
    // get('https://samples.openweathermap.org/data/2.5/weather?lat=43.91&lon=-78.807&appid=$appId');

    Location location = Location();
    await location.getCurrentLocation();
    kDMprint(location);

    final Uri url = Uri(
      scheme: 'https',
      host: 'api.openweathermap.org',
      path: 'data/2.5/weather',
      query:
          'lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric',
    );
    kDMprint(url);
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

    // double temperature = decodeData['main']['temp'];
    // int weatherId = decodeData['weather'][0]['id'];
    // String locale = decodeData['name'];
    // print(
    //     'temperature: $temperature, weatherId: $weatherId, locale: $locale');

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(
        locationWeather: weatherData,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
        // child: ElevatedButton(
        //   onPressed: () {
        //     getLocationData();
        //   },
        //   child: const Text('Get Location'),
        // ),
      ),
    );
  }
}
