import 'package:flutter/material.dart';
import 'package:places_app/Providers/Places.dart';
import 'package:places_app/Widgets/PlaceDetailsScreen.dart';
import 'package:provider/provider.dart';
import 'package:places_app/Screens/HomeScreen.dart';

main() {
  runApp(const PlacesApp());
}

class PlacesApp extends StatelessWidget {
  const PlacesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Places(),
        ),
      ],
      // child: SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        routes: {
          HomeScreen.routeName: (_) => const HomeScreen(),
          PlaceDetailsScreen.routeName: (_) => const PlaceDetailsScreen()
        },
        theme: ThemeData(
            backgroundColor: Colors.teal[100],
            scaffoldBackgroundColor: Colors.black54),
      ),
      // ),
    );
  }
}
