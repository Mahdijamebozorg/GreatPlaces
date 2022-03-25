import 'dart:io';

import 'package:flutter/material.dart';
import 'package:places_app/Helpers/dbHelper.dart';
import 'package:places_app/Providers/Place.dart';

class Places with ChangeNotifier {
  ///saved places in program
  List<Place> _places = [];

  ///a copy list of places
  List<Place> get places => [..._places];

  ///a temp data table name for testing
  static const String table = "user_palces";

  ///add a place to places in sqlite
  Future addPlace(Place newPlace) async {
    _places.add(newPlace);
    //save on device
    await DBHelper.insert(
      table,
      {
        "id": newPlace.id,
        "title": newPlace.title,
        "details": newPlace.details,
        "imageUrl": newPlace.imageUrl, //path to image
        "latitude": newPlace.location.latitude.toString(),
        "longitude": newPlace.location.longitude.toString(),
      },
    );
    notifyListeners();
  }

  ///replace a product with new product
  Future updatePlace(Place newPlace) async {
    final int index = _places.indexWhere((place) => place.id == newPlace.id);
    _places[index] = newPlace;
    //save on device
    await DBHelper.updateData(
        table,
        {
          "id": newPlace.id,
          "title": newPlace.title,
          "details": newPlace.details,
          "imageUrl": newPlace.imageUrl, //path to image
          "latitude": newPlace.location.latitude.toString(),
          "longitude": newPlace.location.longitude.toString(),
        },
        newPlace.id);
    notifyListeners();
  }

  ///load places from sqlite
  Future loadPlaces() async {
    //load from device
    final data = await DBHelper.getData(table);
    if (data.isEmpty) return;
    _places.clear();
    for (Map<String, dynamic> place in data) {
      _places.add(
        Place(
          place["id"],
          place["title"],
          place["details"],
          place["imageUrl"],
          PlaceLocation(
            latitude: double.parse(place["latitude"]),
            longitude: double.parse(place["longitude"]),
          ),
        ),
      );
    }
    notifyListeners();
  }

  ///remove a place from sqlite
  Future removePlace(String id) async {
    final place = _places[findById(id)];

    //remove image
    await File(place.imageUrl).delete();

    //remove from RAM
    _places.remove(place);

    //remove from device
    await DBHelper.deleteData(table, id);

    notifyListeners();
  }

  Future resetAllPlaces() async {
    //delete cache files
    for (var place in _places) {
      await File(place.imageUrl).delete();
    }

    DBHelper.resetData(table);
    // notifyListeners();
  }

  ///find place by its id
  int findById(String id) {
    return _places.indexWhere((place) => place.id == id);
  }
}
