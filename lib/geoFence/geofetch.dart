import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geofence_flutter/geofence_flutter.dart';

class GeoFence extends StatefulWidget {
  const GeoFence({super.key});

  @override
  State<GeoFence> createState() => _GeoFenceState();
}

class _GeoFenceState extends State<GeoFence> {
  StreamSubscription<GeofenceEvent>? geofenceEventStream;
  String geofenceEvent = '';

  TextEditingController latitudeController = new TextEditingController();
  TextEditingController longitudeController = new TextEditingController();
  TextEditingController radiusController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geoencing"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Geofence Event: " + geofenceEvent,
            ),
            TextField(
              controller: latitudeController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter pointed latitude'),
            ),
            TextField(
              controller: longitudeController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter pointed longitude'),
            ),
            TextField(
              controller: radiusController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter radius meter'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text("Start"),
                  onPressed: () async {
                    print("start");
                    await Geofence.startGeofenceService(
                        pointedLatitude: latitudeController.text,
                        pointedLongitude: longitudeController.text,
                        radiusMeter: radiusController.text,
                        eventPeriodInSeconds: 10);
                    if (geofenceEventStream == null) {
                      geofenceEventStream = Geofence.getGeofenceStream()
                          ?.listen((GeofenceEvent event) {
                        print(event.toString());
                        setState(() {
                          geofenceEvent = event.toString();
                        });
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 10.0,
                ),
                TextButton(
                  child: Text("Stop"),
                  onPressed: () {
                    print("stop");
                    Geofence.stopGeofenceService();
                    // geofenceEventStream?.cancel();
                    geofenceEventStream!.cancel();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    latitudeController.dispose();
    longitudeController.dispose();
    radiusController.dispose();

    super.dispose();
  }
}
