import 'package:flutter/material.dart';
import 'package:maps/models/location_info.dart';
import 'package:maps/services/save_locations.dart';

class ShowSavedData extends StatefulWidget {
  @override
  _ShowSavedDataState createState() => _ShowSavedDataState();
}

class _ShowSavedDataState extends State<ShowSavedData> {
  Services _services = Services();

  @override
  Widget build(BuildContext context) {
    double ScreenHeigt = MediaQuery.of(context).size.height;
    double ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Saved Locations"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _services.getSavedLocations(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            List<LocationInfo> locations = [];
            for (var doc in snapShot.data.docs) {
              locations.add(LocationInfo(
                  firstLocation: doc.data()["latLng1"],
                  secondLocation: doc.data()["latLng2"],
                  distance: doc.data()["distanceBetweenLocations"]));
            }
            return ListView.builder(
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  if (locations.length != null) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.indigo),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "=> The Firt Location is : ${locations[index].firstLocation}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  "=> The Second Location is : ${locations[index].secondLocation}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  "=> The Distance Between This Location is : ${locations[index].distance}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text("Loading"),
                    );
                  }
                });
          } else {
            return Center(
              child: Text("No Saved Locations"),
            );
          }
        },
      ),
    );
  }
}
