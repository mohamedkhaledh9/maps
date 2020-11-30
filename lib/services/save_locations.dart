import 'package:cloud_firestore/cloud_firestore.dart';

class Services {
  final firestore = FirebaseFirestore.instance;
  saveLocationData(map) async {
    await firestore.collection("locations").add(map);
  }

  Stream<QuerySnapshot> getSavedLocations() {
    return firestore.collection("locations").snapshots();
  }
}
