import 'package:flutter/foundation.dart';

class Location {
  final double latitude;
  final double longitude;
  final String address;

  Location(
      {required this.latitude, required this.longitude, required this.address});
}

class Place with ChangeNotifier {
  //these should be private
  String _id;
  String _title;
  String _details;
  String _imageUrl;
  Location _location;

  Place(
    this._id,
    this._title,
    this._details,
    this._imageUrl,
    this._location,
  );

  //getter for all data

  //setter for information
}
