import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/screens/show_saved_data.dart';
import 'dart:math' as math;

import 'package:maps/services/save_locations.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController googleMapController;
  List<Marker> _markers = [];
  List<LatLng> _latLong = [];
  LatLng latLng1;
  LatLng latLng2;
  Services _services = Services();

  onMapCreated(GoogleMapController controller) {
    setState(() {
      googleMapController = controller;
    });
  }

  double distance = 0;

  deg2rad(deg) {
    return deg * (math.pi / 180);
  }

  double latitude1 = 0;
  double longitude1 = 0;
  double latitude2 = 0;
  double longitude2 = 0;

  setMarkLocation(LatLng latLngvalue) {
    setState(() {
      if (_markers.length < 2) {
        _latLong.add(latLngvalue);
        {
          if (_latLong.length == 2) {
            latitude1 = _latLong[0].latitude;
            longitude1 = _latLong[0].longitude;
            print(latitude1);
            print(longitude1);
            latLng1 = _latLong[0];
            latitude2 = _latLong[1].latitude;
            longitude2 = _latLong[1].longitude;
            print(latitude2);
            print(latitude2);
            latLng2 = _latLong[1];
            var R = 6371;
            var dLat = deg2rad(latitude2 - latitude1);
            var dLong = deg2rad(longitude2 - longitude1);
            var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
                math.cos(deg2rad(latitude1)) *
                    math.cos(deg2rad(latitude2)) *
                    math.sin(dLong / 2) *
                    math.sin(dLong / 2);
            var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
            double d = R * c;
            distance = d;
          }
        }
        _markers.add(
          Marker(
            markerId: MarkerId(latLngvalue.toString()),
            position: latLngvalue,
          ),
        );
      } else {
        _markers.clear();
        _latLong.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double ScreenHeigt = MediaQuery.of(context).size.height;
    double ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(30.033333, 31.233334),
            ),
            onTap: setMarkLocation,
            markers: Set.from(_markers),
            onMapCreated: onMapCreated,
            mapType: MapType.normal,
            polygons: (_latLong.length >= 2 && _latLong.length != 0)
                ? Set<Polygon>.of(
                    <Polygon>[
                      Polygon(
                          polygonId: PolygonId("distance"),
                          points: _latLong,
                          strokeColor: Colors.indigo,
                          strokeWidth: 1,
                          fillColor: Colors.indigo,
                          visible: true),
                    ],
                  )
                : null,
          ),
          Opacity(
            opacity: .7,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 12, 10, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowSavedData(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.indigo),
                  width: ScreenWidth * .8,
                  height: ScreenHeigt * .08,
                  alignment: Alignment.topCenter,
                  child: Center(
                      child: Text(
                    "Show Saved Locations",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Opacity(
                  opacity: .6,
                  child: Container(
                      height: ScreenHeigt * .08,
                      width: ScreenWidth * .35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.indigo),
                      child: FlatButton(
                        onPressed: () async {
                          Map<String, String> locationInfo = {
                            "latLng1": latLng1.toString(),
                            "latLng2": latLng2.toString(),
                            "distanceBetweenLocations": distance.toString(),
                          };
                          await _services.saveLocationData(locationInfo);

                          print("First latLong is : ${latLng1.toString()}");
                          print("Second latLong is :${latLng2.toString()}");
                          print(
                              "the distance between this locations is : ${distance.toString()}");
                        },
                        child: Text(
                          "Save Location",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                Opacity(
                  opacity: .7,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.indigo),
                      height: ScreenHeigt * .08,
                      width: ScreenWidth * .35,
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            _markers.clear();
                            _latLong.clear();
                            distance = 0;
                          });
                        },
                        child: Text(
                          "Clear Data",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
