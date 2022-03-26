import 'dart:io';
import 'package:flutter/material.dart';
import 'package:places_app/Providers/Place.dart';
import 'package:provider/provider.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName = "/PlaceDetailsScreen";
  const PlaceDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _place = Provider.of<Place>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            //image and title
            Center(
              child: Stack(
                children: [
                  Hero(
                    tag: _place.id,
                    child: Image.file(
                      File(_place.imageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      color: Colors.black45,
                      child: Text(_place.title),
                    ),
                  ),
                ],
              ),
            ),
            //address
            Text(
              _place.location.address,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            //latitude
            Text(
              _place.location.latitude.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            //longitude
            Text(
              _place.location.longitude.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            //details
            Text(
              _place.details,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
