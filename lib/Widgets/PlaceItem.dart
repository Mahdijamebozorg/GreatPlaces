import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:places_app/Providers/Place.dart';

class PlaceItem extends StatelessWidget {
  final Place _place;
  const PlaceItem(this._place, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //having shadow
    return Card(
      elevation: 15,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
      ),
      //rounding corners
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        child: GridTile(
          //photo
          child: Hero(
            tag: _place.id,
            child: FadeInImage(
              fit: BoxFit.fill,
              placeholder: const AssetImage("assets/images/temp.png"),
              image: (kIsWeb
                  ? NetworkImage(_place.imageUrl)
                  : AssetImage(_place.imageUrl)) as ImageProvider,
            ),
          ),
          //details
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(_place.title),
            subtitle: Text(_place.details),
            trailing:
                IconButton(onPressed: () {}, icon: const Icon(Icons.star)),
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
