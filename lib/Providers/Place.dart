import 'package:flutter/foundation.dart';

class Location {
  final double latitude;
  final double longitude;
  final String address;

  Location(
      {required this.latitude, required this.longitude, required this.address});
}

class Place with ChangeNotifier {
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

  String get id => _id;

  String get title => _title;

  String get details => _details;

  String get imageUrl => _imageUrl;

  Location get location => _location;

  Future chagneTitle(String newTitle) async {
    _title = newTitle;
    notifyListeners();
  }

  Future chagneDetails(String newDetails) async {
    _title = newDetails;
    notifyListeners();
  }

  Future chagneImageUrl(String newImageUrl) async {
    _imageUrl = newImageUrl;
    notifyListeners();
  }

  Future chagneLocation(Location newLocation) async {
    _location = newLocation;
    notifyListeners();
  }
}
