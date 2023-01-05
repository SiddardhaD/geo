import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MonitorEmployee extends StatefulWidget {
  final int index;
  final bool isLive;
  final double? latitudeLive;
  final double? longitudeLive;
  final double? latitudesrc;
  final double? longitudesrc;
  final double? latitudedes;
  final double? longitudedes;
  const MonitorEmployee(
      {super.key,
      required this.index,
      this.latitudeLive,
      this.longitudeLive,
      required this.isLive,
      this.latitudesrc,
      this.longitudesrc,
      this.latitudedes,
      this.longitudedes});

  @override
  State<MonitorEmployee> createState() => _MonitorEmployeeState();
}

class _MonitorEmployeeState extends State<MonitorEmployee> {
  @override
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};

  Map<PolylineId, Polyline> polylines = {};
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  Set<Polygon> _polygon = HashSet<Polygon>();
  List<LatLng> points = [
    LatLng(17.4328711, 78.3736083),
    LatLng(17.4110794, 78.3902625),
    LatLng(17.5328711, 78.3736083),
  ];
  String addressLine1 = "";
  String addressLine2 = "";
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _liveAddMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(120),
      position: position,
    );
    markers[markerId] = marker;
  }

  @override
  void initState() {
    if (!widget.isLive) {
      _addMarker(LatLng(widget.latitudesrc!, widget.longitudesrc!), "origin",
          BitmapDescriptor.defaultMarkerWithHue(90));
      _addMarker(LatLng(widget.latitudedes!, widget.longitudedes!),
          "destination", BitmapDescriptor.defaultMarkerWithHue(10));
      _addPolyLine();
      getLoginLocaion(widget.latitudesrc!, widget.longitudesrc!);
      getLogoutLocaion(widget.latitudedes!, widget.longitudedes!);
    } else {
      _liveAddMarker(LatLng(widget.latitudeLive!, widget.longitudeLive!),
          "origin", BitmapDescriptor.defaultMarkerWithHue(90));
      // getLoginLocaion(widget.latitudesrc!,widget.longitudesrc!);
      getLiveLocaion(widget.latitudeLive!, widget.longitudeLive!);
    }
    _polygon.add(Polygon(
      // given polygonId
      polygonId: PolygonId('1'),
      // initialize the list of points to display polygon
      points: points,
      // given color to polygon
      fillColor: Colors.green.withOpacity(0.3),
      // given border color to polygon
      strokeColor: Colors.green,
      geodesic: true,
      // given width of border
      strokeWidth: 10,
    ));

    super.initState();
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline =
        Polyline(polylineId: id, width: 5, color: Colors.red, points: [
      LatLng(widget.latitudesrc!, widget.longitudesrc!),
      LatLng(widget.latitudedes!, widget.longitudedes!)
    ]);
    polylines[id] = polyline;
    setState(() {});
  }

  bool isFetched1 = false;
  bool isFetched2 = false;
  Future<void> getLoginLocaion(double lat, double lon) async {
    isFetched1 = true;
    String location = "";
    final coordinates = Coordinates(lat, lon);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      addressLine1 = address[0].addressLine!;
    });

    isFetched1 = false;
  }

  Future<void> getLogoutLocaion(double lat, double lon) async {
    isFetched2 = true;
    String location = "";
    final coordinates = Coordinates(lat, lon);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      addressLine2 = address[0].addressLine!;
    });

    isFetched2 = false;
  }

  Future<void> getLiveLocaion(double lat, double lon) async {
    isFetched2 = true;
    String location = "";
    final coordinates = Coordinates(lat, lon);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      addressLine2 = address[0].addressLine!;
    });

    isFetched2 = false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(17.433028, 78.3728344), zoom: 15),
            onCameraMove: (position) => CameraPosition(
                target: LatLng(17.427043213495722, 78.37636184875586),
                zoom: 15),
            myLocationEnabled: false,
            mapType: MapType.hybrid,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            mapToolbarEnabled: true,
            // polygons : _polygon,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          ),
        ),
        !widget.isLive
            ? isFetched1 == false
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Login Location : $addressLine1"),
                  )
                : Container()
            : Container(),
        !widget.isLive
            ? isFetched2 == false
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Logout Location : $addressLine2"),
                  )
                : Container()
            : isFetched2 == false
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Live Location : $addressLine2"),
                  )
                : Container()
      ]),
    );
  }
}
