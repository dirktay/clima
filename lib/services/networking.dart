import 'package:http/http.dart' as http;

import 'dart:convert';

import '../utilities/debugging.dart';

class NetworkHelper {
  NetworkHelper(this.url);
  final Uri url;

  Future getData() async {
    http.Response response = await http.get(url);
    // kDMprint(response.statusCode);
    // kDMprint(response.body);
    if (response.statusCode == 200) {
      String data = response.body;
      kDMprint(data);
      return jsonDecode(data);
    } else {
      kDMprint(response.statusCode);
    }
  }
}
