import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class LiveTrack extends StatefulWidget {
  const LiveTrack({super.key});

  @override
  State<LiveTrack> createState() => _LiveTrackState();
}

class _LiveTrackState extends State<LiveTrack> {

  @override
  void initState() {
    
    
    getCurrentLocation();
    getPolyPoints();
    setCustomMarkerIcon();
   
    super.initState();
  }
  bool isIntialize = true;
  LocationData? currentLocation;
  Location location = new Location();
  static const LatLng sourceLocation = LatLng(17.432867, 78.3736163);
  static const LatLng destination = LatLng(17.435867, 78.3786163);
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  List<LatLng> polylineCoordinates = [];


  void getCurrentLocation() async {
    setState(() {
      isIntialize = true;
    });
    // currentLocation = await location.getLocation();
        
    setState(() {
      isIntialize=false;
    });
  // GoogleMapController googleMapController = await _controller.future;
  // location.onLocationChanged.listen(
  //   (newLoc) {
  //     currentLocation = newLoc;
  //     googleMapController.animateCamera(
  //               CameraUpdate.newCameraPosition(
  //                 CameraPosition(
  //                   zoom: 15.5,
  //                   target: LatLng(
  //                     newLoc.latitude!,
  //                     newLoc.longitude!,
  //                   ),
  //                 ),
  //               ),
  //             );
  //     setState(() {});
  //           },
  //         );
     
    
    }
  void setCustomMarkerIcon() {
  BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size:Size(1,1)), "assets/human.png")
      .then(
    (icon) {
      currentLocationIcon = icon;
    },
  );
  }

void getPolyPoints() async {
  PolylinePoints polylinePoints = PolylinePoints();
  GoogleMapController googleMapController = await _controller.future;
  // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     "AIzaSyAQ5H5Uo82sNkQSsD0ezK5hj2uAivN4Vt0", // Your Google Map Key
  //     PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
  //     PointLatLng(destination.latitude, destination.longitude),
  //   );
  // if (result.points.isNotEmpty) {
  //     result.points.forEach(
  //       (PointLatLng point) => polylineCoordinates.add(
  //         LatLng(point.latitude, point.longitude),
  //       ),
  //     );
  //     setState(() {});
  //   }
  polylineCoordinates.add(sourceLocation);
  polylineCoordinates.add(destination);
}
double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
double getDistance() {
    return calculateDistance(17.432867, 78.3736163,17.435867, 78.3786163);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Track"),
      ),
      body: isIntialize==false?GoogleMap(
        
      initialCameraPosition:  CameraPosition(
        target: sourceLocation,
        zoom: 13.5,
      ),
      
      markers: {
        // Marker(
        //   markerId: const MarkerId("currentLocation"),
        //   icon: currentLocationIcon ,
        //   position: LatLng(
        //       currentLocation!.latitude!, currentLocation!.longitude!),
        // ),
         Marker(
          draggable: false,
          onDrag:(value) {
            debugPrint("value is $value");
          },
          onDragStart: (value) {
            debugPrint("value is $value");
          },
          flat: true,
          markerId: MarkerId("source"),
           infoWindow: const InfoWindow(
                  title: 'km',
                  snippet: "KM"
            ),
          position: sourceLocation,
        ),
        // const Marker(
        //   infoWindow: InfoWindow(
        //           title: 'km',
        //           snippet: "KM"
        //              ),
        //   markerId: MarkerId("destination"),
        //   position: destination,
        // ),
      },
      onMapCreated: (mapController) {
        _controller.complete(mapController);
      },
    
      
      polylines: {
      Polyline(
        polylineId: const PolylineId("route"),
        points: polylineCoordinates,
        color: const Color(0xFF7B61FF),
        width: 6,
      ),
    },
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}

