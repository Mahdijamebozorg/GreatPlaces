import 'package:flutter/material.dart';
import 'package:places_app/Helpers/dbHelper.dart';

import 'package:places_app/Providers/Place.dart';

class Places with ChangeNotifier {
  List<Place> _places = [
    Place(
      id: "",
      title: "test",
      details: "a testing list item",
      imageUrl: "assets/images/rome.jpg",
      location: Location(address: "", latitude: 0, longitude: 0),
    ),
    Place(
      id: "",
      title: "test",
      details: "a testing list item",
      imageUrl: "assets/images/rome.jpg",
      location: Location(address: "", latitude: 0, longitude: 0),
    ),
    Place(
      id: "",
      title: "test",
      details: "a testing list item",
      imageUrl: "assets/images/rome.jpg",
      location: Location(address: "", latitude: 0, longitude: 0),
    ),
    Place(
      id: "",
      title: "test",
      details: "a testing list item",
      imageUrl: "assets/images/rome.jpg",
      location: Location(address: "", latitude: 0, longitude: 0),
    ),
    Place(
      id: "",
      title: "test",
      details: "a testing list item",
      imageUrl: "assets/images/rome.jpg",
      location: Location(address: "", latitude: 0, longitude: 0),
    ),
  ];

  List<Place> get places {
    return [..._places];
  }

  Future addPlace(Place newPlace) async {
    _places.add(newPlace);
    DBHelper.insert("user_places", {
      "id": newPlace.id,
      "title": newPlace.title,
      "details": newPlace.details,
      "imageUrl": newPlace.imageUrl, //path to image
      "location": newPlace.location,
    });
    notifyListeners();
  }

  Future loadPlaces() async {
    final data = await DBHelper.getData("user_places");
    _places = data
        .map((place) => Place(
              id: place["id"],
              title: place["title"],
              details: place["details"],
              imageUrl: place["imageUrl"],
              location: place["location"],
            ))
        .toList();
    notifyListeners();
  }

  Future removePlace(String id) async {
    _places.remove(_places[findById(id)]);
    await DBHelper.deleteData("user_places", id);
    notifyListeners();
  }

  int findById(String id) {
    return _places.indexWhere((place) => place.id == id);
  }
}
