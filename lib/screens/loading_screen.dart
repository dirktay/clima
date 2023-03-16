import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

import '../utilities/debugging.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late double latitude;
  late double longitude;

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    // const appId = 'b6907d289e10d714a6e88b30761fae22'; //temp/sample
    // get('https://samples.openweathermap.org/data/2.5/weather?lat=43.91&lon=-78.807&appid=$appId');
    const apiKey = '68443217e38e0a57bc1968ac0cc7c631';

    Location location = Location();
    await location.getCurrentLocation();
    kDMprint(location);
    latitude = location.latitude;
    longitude = location.longitude;

    final Uri url = Uri(
      scheme: 'https',
      host: 'api.openweathermap.org',
      path: 'data/2.5/weather',
      query: 'lat=$latitude&lon=$longitude&appid=$apiKey',
    );
    kDMprint(url);
    final Uri httpsUri = Uri.https(
      'api.openweathermap.org',
      'data/2.5/weather',
      {'lat': '$latitude', 'lon': '$longitude', 'appid': apiKey},
    );
    kDMprint(httpsUri);
    NetworkHelper networkHelper = NetworkHelper(httpsUri);
    var weatherData = await networkHelper.getData();

    // double temperature = decodeData['main']['temp'];
    // int weatherId = decodeData['weather'][0]['id'];
    // String locale = decodeData['name'];
    // print(
    //     'temperature: $temperature, weatherId: $weatherId, locale: $locale');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            getLocationData();
          },
          child: const Text('Get Location'),
        ),
      ),
    );
  }
}
