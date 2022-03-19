import 'package:flutter/material.dart';

class UserType {
  final String name;
  final String id;
  List<String> favoritePlaces;

  UserType({required this.name, required this.id, this.favoritePlaces = const []});
}