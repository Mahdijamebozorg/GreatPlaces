import 'package:flutter/material.dart';
import 'package:places_app/Helpers/dbHelper.dart';

import 'package:places_app/Providers/Place.dart';

class Places with ChangeNotifier {
  //a temp list of places
  List<Place> _places = [
    // Place(
    //   "i1",
    //   "test",
    //   "a testing list item",
    //   "assets/images/rome.jpg",
    //   Location(address: "someWhere", latitude: 0, longitude: 0),
    // ),
  ];

  List<Place> get places => [..._places];

  //a temp data table name for testing
  static const String table = "user_palces";

  Future addPlace(Place newPlace) async {
    _places.add(newPlace);
    //save on device
    DBHelper.insert(table, {
      "title": newPlace.title,
      "details": newPlace.details,
      "imageUrl": newPlace.imageUrl, //path to image
      "location": newPlace.location,
    });
    notifyListeners();
  }

  Future updatePlace(Place newPlace) async {
    final int index = _places.indexWhere((place) => place.id == newPlace.id);
    _places[index] = newPlace;
    //save on device
    DBHelper.updateData(
        table,
        {
          "title": newPlace.title,
          "details": newPlace.details,
          "imageUrl": newPlace.imageUrl, //path to image
          "location": newPlace.location,
        },
        newPlace.id);
    notifyListeners();
  }

  Future loadPlaces() async {
    //load from device
    final data = await DBHelper.getData(table);
    _places = data
        .map((place) => Place(
              place.keys.toList()[0],
              place["title"],
              place["details"],
              place["imageUrl"],
              place["location"],
            ))
        .toList();
    notifyListeners();
  }

  Future removePlace(String id) async {
    _places.remove(_places[findById(id)]);
    //remove from device
    await DBHelper.deleteData(table, id);
    notifyListeners();
  }

  int findById(String id) {
    return _places.indexWhere((place) => place.id == id);
  }
}
