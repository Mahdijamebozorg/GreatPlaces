import 'package:flutter/foundation.dart';

class PlaceLocation {
  final String address;
  final double latitude;
  final double longitude;

  PlaceLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class Place with ChangeNotifier {
  String _id;
  String _title;
  String _details;
  String _imageUrl;
  PlaceLocation _location;

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

  PlaceLocation get location => _location;

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

  Future chagneLocation(PlaceLocation newLocation) async {
    _location = newLocation;
    notifyListeners();
  }
}
