// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:location/location.dart';
// import 'dart:io';

// import '../globals.dart';

// class Login extends StatefulWidget {
//   int index;
//   Login({super.key,required this.index});
//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   @override

//   bool _isLogIn = false;
//   bool _serviceEnabled = false;
//   Location location = new Location();
//   late PermissionStatus _permissionGranted;
//   late LocationData _locationData;
//   bool intializing = false;
//   bool hiveintializing = true;
//   var locationBox;
//   late Coordinates coordinates ;

//   settingAttendance()async{
//     _locationData = await location.getLocation();
//     setState(()  {
//       _isLogIn = !_isLogIn;
//     });
//     debugPrint("Attendance = $_isLogIn");
//     if(_isLogIn==true){
//       DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(_locationData.time!.toInt());
//       locationBox.put('logInTime${widget.index+1}',"$tsdate"); 
//       await locationBox.put('LoginCoordinates${widget.index+1}', Coordinates(lati: _locationData.latitude,long: _locationData.longitude));

//     }else{
//        DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(_locationData.time!.toInt());
//        locationBox.put('logInOutime${widget.index+1}',"$tsdate");
//       await locationBox.put('LogoutCoordinates${widget.index+1}', Coordinates(lati: _locationData.latitude,long: _locationData.longitude));
//     }
    
//   }
// @override
//   void initState() {
//     debugPrint("Getting SignIn Location");
//     enablingHiveData();
//     enableLocation();
//     super.initState();
//   }
  
//   Future<void> enablingHiveData()async{
//     setState(() {
//       hiveintializing = true;
//     });

//     await Hive.openBox('LocationDetails${widget.index+1}'); 
//     locationBox = Hive.box('LocationDetails${widget.index+1}');
      
//     setState(() {
//       hiveintializing = false;
//     });
//   }

  
//  Future<void> enableLocation()async{
//     setState(() {
//       intializing = true;
//     });
//     _serviceEnabled = await location.serviceEnabled();
//         try{
//           if (!_serviceEnabled) {
//             _serviceEnabled = await location.requestService();
//             if (!_serviceEnabled) {
//               return;
//             }
//           }
//           _permissionGranted = await location.hasPermission();
//           if (_permissionGranted == PermissionStatus.denied) {
//             _permissionGranted = await location.requestPermission();
//             if (_permissionGranted != PermissionStatus.granted) {
//               return;
//             }
//           }
//         }catch(e){
//           debugPrint("All Permisions Given");
//         }
        
//     _locationData = await location.getLocation();
//     DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(_locationData.time!.toInt());
//     debugPrint(tsdate.toIso8601String());
//     setState(() {
//       intializing = false;
//     });
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Employee ${widget.index+1}"),),
//       body: Container(child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//         Align(
//           alignment: Alignment.center,
//           child:intializing!=true? _isLogIn==false?TextButton(
//                 child: Text("LogIn"),
//               style: TextButton.styleFrom( primary: Colors.white,backgroundColor: Colors.blue,),
//                 onPressed:() {
//                    settingAttendance();
//                 },
//               ):TextButton(
//                 child: Text("LogOut"),
//               style: TextButton.styleFrom( primary: Colors.white,backgroundColor: Colors.red,),
//                 onPressed:() {
//                    settingAttendance();
//                 },
//               ) : CircularProgressIndicator(),
//         ),
//         intializing!=true?_isLogIn==false?Align(
//           alignment: Alignment.center,
//           child: Column(children: [
//             Text("LogOut Time")
//           ]),
//         ):Align(
//           alignment: Alignment.center,
//           child: Column(children: [
//             Text("LogIn Time")
//           ]),
//         ):Container(),
//         // Expanded(child: ListView.builder(
//         //   itemCount: 3,
//         //   itemBuilder: (BuildContext context, int index) {
//         //     return Container(
//         //       padding: EdgeInsets.only(left:25,right: 25,top:20),
//         //       height: MediaQuery.of(context).size.height/8,
//         //       child: Column(children: [
//               hiveintializing==false?locationBox.get('logInTime${widget.index+1}')!=null?Text("LoginTime = ${locationBox.get('logInTime${widget.index+1}')}"):Container():Container(),
//               hiveintializing==false?locationBox.get('logInOutime${widget.index+1}')!=null?Text("logInOutime = ${locationBox.get('logInOutime${widget.index+1}')}"):Container():Container(),
//           //     ]),
//           //   );
//           // }),)
//       ]),),
//       );
//   }
// }

// class Loc{
//   double? lat;
//   double? long;
// }

import 'dart:convert';

import 'package:clinetserverapp2/employeesData.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:location/location.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class Login extends StatefulWidget {
  int index;
  Login({super.key,required this.index});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override

  bool _isLogIn = false;
  bool _serviceEnabled = false;
  bool _isLoginPressed = false;
  bool _isLogoutPressed = false;
  Location location = new Location();
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  bool intializing = false;
  bool hiveintializing = true;
  late Box<Employeedata> empLocationBox;
  late Box<bool> empStatus;
  Map<PolylineId, Polyline> polylines = {};
  //  List<Coordinates> coordinates = [];



  settingAttendance()async{
    
    _locationData = await location.getLocation();
    setState(()  {
      _isLogIn = !_isLogIn;
    });
    debugPrint("Attendance = $_isLogIn");
    if(_isLogIn){
      _isLoginPressed = true;
      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(_locationData.time!.toInt());
      await empLocationBox.put('LoginEntry${widget.index+1}', Employeedata(longsrc: _locationData.longitude,latisrc:  _locationData.latitude,loginTime: tsdate.toString(),status: 1));
      empStatus.put('EMP${widget.index+1}Status', true);
      final coordinates = Coordinates(_locationData.latitude,_locationData.longitude);
      final address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      debugPrint("Update Login : Done${address[0].addressLine}");

  
    }else{
      _isLogoutPressed = true;
       DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(_locationData.time!.toInt());
      await empLocationBox.put('LogoutEntry${widget.index+1}', Employeedata(longdes: _locationData.longitude,latides:  _locationData.latitude,logoutTime: tsdate.toString(),status: 0),);
      empStatus.put('EMP${widget.index+1}Status', false);
      final coordinates = Coordinates(_locationData.latitude,_locationData.longitude);
      final address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      debugPrint("Update Logout : Done${address[0].addressLine}");
    }
  }
  // Future<void> GetAddressFromLatLong(Position position)async {
    // List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  //   print(placemarks);
  //   Placemark place = placemarks[0];
  //   Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  //   setState(()  {
  //   });
  // }
@override
  void initState() {
    debugPrint("Getting SignIn Location");
    openBox();
    enableLocation();
    super.initState();
  }
  
  Future<void> openBox()async{
    setState(() {
      hiveintializing = true;
    });
    try{
      await Hive.openBox<Employeedata>('employee${widget.index+1}');
      empLocationBox = Hive.box('employee${widget.index+1}');
      
    }catch(e){
      debugPrint("box already openned");
      }
    try{
      await Hive.openBox<bool>('empstatus${widget.index+1}');
      empStatus = Hive.box('empstatus${widget.index+1}');
    }catch(e){
      debugPrint("Staus box already openned");
    }
    try{
      _isLogIn  = empStatus.get('EMP${widget.index+1}Status')!;
    }catch(e){
      empStatus.put('EMP${widget.index+1}Status',false);
    }
      
    setState(() {
      hiveintializing = false;
    });
  }

  Future<void> closeBox()async{
    empLocationBox.close();
  }

  
 Future<void> enableLocation()async{
    setState(() {
      intializing = true;
    });
    _serviceEnabled = await location.serviceEnabled();
        try{
          if (!_serviceEnabled) {
            _serviceEnabled = await location.requestService();
            if (!_serviceEnabled) {
              return;
            }
          }
          _permissionGranted = await location.hasPermission();
          if (_permissionGranted == PermissionStatus.denied) {
            _permissionGranted = await location.requestPermission();
            if (_permissionGranted != PermissionStatus.granted) {
              return;
            }
          }
        }catch(e){
          debugPrint("All Permisions Given");
        }
        
    _locationData = await location.getLocation();
    location.enableBackgroundMode(enable: true);
    onLocationChnage();
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(_locationData.time!.toInt());
    debugPrint(tsdate.toIso8601String());
    setState(() {
      intializing = false;
    });
  }
  onLocationChnage(){
    location.onLocationChanged.listen((LocationData loc) {
      debugPrint("Current location ${widget.index+1}: ${loc.latitude}, ${loc.longitude}");

      try{
        setState(() {
          var lat = loc.latitude!;
          var lon = loc.longitude!;
          empLocationBox.put("Live${widget.index+1}", Employeedata(liveLati:loc.latitude,liveLong: loc.longitude ));
        });
      }catch(e){
        debugPrint("Updating Failed");
      }
      });

  }
   _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: [LatLng(17.433028,78.3728344 ),LatLng(17.427043213495722,78.37636184875586)]);
    polylines[id] = polyline;
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Employee ${widget.index+1}"),),
      body: Container(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Align(
          alignment: Alignment.center,
          child:intializing!=true? _isLogIn==false?TextButton(
                child: Text("LogIn"),
              style: TextButton.styleFrom( primary: Colors.white,backgroundColor: Colors.blue,),
                onPressed:() {
                   settingAttendance();
                },
              ):TextButton(
                child: Text("LogOut"),
              style: TextButton.styleFrom( primary: Colors.white,backgroundColor: Colors.red,),
                onPressed:() {
                   settingAttendance();
                },
              ) : CircularProgressIndicator(),
        ),
      ]),),
      );
  }
}

class Loc{
  double? lat;
  double? long;
}