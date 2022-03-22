import 'package:flutter/material.dart';

class MapInput extends StatefulWidget {
  const MapInput({Key? key}) : super(key: key);

  @override
  State<MapInput> createState() => _MapInputState();
}

class _MapInputState extends State<MapInput> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, mapPart) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //choose on map
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Icons.map,
                    ),
                  ),
                ),
              ),
              //choose current location
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {},
                  child:const FittedBox(
                    fit: BoxFit.scaleDown,
                    child:  Icon(
                      Icons.map,
                    ),
                  ),
                ),
              ),
            ],
          ),

          //map preview
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                child: const Center(child: Text("No place has chosen!")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
