import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:places_app/Widgets/EditPlace.dart';
import 'package:provider/provider.dart';

import '../Widgets/PlaceItem.dart';
import 'package:places_app/Providers/Places.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = "/home";

  @override
  Widget build(BuildContext context) {
    final _places = Provider.of<Places>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: _places.loadPlaces(),
        builder: (context, snapshot) =>
            //if waiting
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomScrollView(
                    slivers: [
                      //to have a drawer effect in appBar
                      SliverAppBar(
                        pinned: true,
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.7),
                        expandedHeight: MediaQuery.of(context).size.height *
                            (Platform.isAndroid || Platform.isIOS ? 0.5 : 0.7),
                        flexibleSpace: FlexibleSpaceBar(
                          title: const Text("Places"),
                          background: Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            elevation: 8,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              child: Image.asset(
                                "assets/images/places.jpg",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) => const EditPlace(),
                                  isScrollControlled: true);
                            },
                            color: const Color.fromARGB(255, 9, 236, 199),
                            iconSize: min(
                                MediaQuery.of(context).size.height * 0.06, 50),
                          ),
                        ],
                      ),

                      //updating tiles according to places list
                      _places.places.isEmpty
                          //used because of bug in 0 item sliverGrid
                          ? const SliverSafeArea(
                              sliver: SliverToBoxAdapter(
                                  child:
                                      Center(child: Text("No place added!"))),
                            )
                          : Consumer<Places>(
                              builder: (context, data, child) => SliverGrid(
                                delegate: SliverChildBuilderDelegate(
                                  (_, index) => PlaceItem(data.places[index]),
                                  childCount: _places.places.length,
                                ),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      Platform.isAndroid || Platform.isIOS
                                          ? 1
                                          : 2,
                                  //width/height
                                  childAspectRatio: 3 / 2,
                                  mainAxisSpacing:
                                      MediaQuery.of(context).size.height * 0.03,
                                  crossAxisSpacing:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                              ),
                            ),
                    ],
                  ),
      ),
    );
  }
}
