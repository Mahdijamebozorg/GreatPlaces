import 'dart:convert';

import 'package:places_app/APIKeys.dart';
import 'package:http/http.dart' as http;

class LocationHelper {
  static String generateLocationPreview(
      {required double latitude, required double longitude}) {
    return "https://api.neshan.org/v2/static?key=$NESHAN_API_KEY&type=neshan&zoom=16&center=$latitude,$longitude&width=600&height=300&marker=red";
    // return "https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY";
  }

  static Future<String> generateAddressWithLocation(
      {required double latitude, required double longitude}) async {
    final String url =
        "https://api.neshan.org/v4/reverse?lat=$latitude&lng=$longitude";
    final response =
        await http.get(Uri.parse(url), headers: {"Api-Key": NESHAN_API_KEY});
    print(response.body);
    return json.decode(response.body)["formatted_address"];
  }
}
