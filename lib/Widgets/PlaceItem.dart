import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:places_app/Providers/Place.dart';
import 'package:places_app/Providers/Places.dart';
import 'package:provider/provider.dart';

class PlaceItem extends StatelessWidget {
  final Place _place;
  const PlaceItem(this._place, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //having shadow
    return Card(
      elevation: 15,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      //rounding corners
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: GridTile(
          //photo
          child: Hero(
            tag: _place.id,
            child: FadeInImage(
              fit: BoxFit.fill,
              placeholder: const AssetImage("assets/images/temp.png"),
              image: (kIsWeb
                  ? NetworkImage(_place.imageUrl)
                  : FileImage(File(_place.imageUrl))) as ImageProvider,
            ),
          ),
          //details
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(_place.title),
            subtitle: Text(_place.details),
            trailing: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Provider.of<Places>(context, listen: false)
                        .removePlace(_place.id);
                  },
                  icon: const Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.star),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // child: Stack(
    //   children: [
    //     Image.asset(
    //       _place.imageUrl,
    //       width: constraints.maxWidth,
    //       height: constraints.maxHeight * 0.8,
    //     ),
    //     Positioned(
    //       bottom: 20,
    //       left: 20,
    //       child: Container(
    //         color: Colors.black87,
    //         child: Text(
    //           _place.title,
    //           style: TextStyle(
    //               color: Colors.white,
    //               fontSize: constraints.maxHeight * 0.08),
    //           overflow: TextOverflow.fade,
    //         ),
    //       ),
    //     ),
    //   ],
  }
}
