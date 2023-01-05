import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_geocoder/model.dart';
import 'package:hive_flutter/adapters.dart';

import '../employeesData.dart';
import 'monitor_screen.dart';
class EachEmployee extends StatefulWidget {
  final int index;
  const EachEmployee({super.key,required this.index});

  @override
  State<EachEmployee> createState() => _EachEmployeeState();
}

class _EachEmployeeState extends State<EachEmployee> {
  @override
  
    bool hiveintializing = true;
    late Box<Employeedata> empLocationBox; 
    late Box<bool> empStatus;
    bool _isLogIn = false;
    String addressLine = "";
   

    void initState() {
      debugPrint("Getting SignIn Location");
      enablingHiveData();
     
      // enableLocation();
      super.initState();
    }
    
    Future<void> enablingHiveData()async{
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
     if(_isLogIn){
        await getLocaion(empLocationBox.get('LoginEntry${widget.index+1}')!.latisrc!,empLocationBox.get('LoginEntry${widget.index+1}')!.longsrc!);
      }
    setState(() {
      hiveintializing = false;
    });
  }
  bool isLocationLoading = false;
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details ${widget.index+1}"),),
      body: Container(
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
          Text("Employee ${widget.index+1}",style: TextStyle(color: Colors.blue),),
          SizedBox(height: 50,),
          TextButton(onPressed: (){
            _isLogIn?
            Navigator.push(  
              context,  
              MaterialPageRoute(builder: (context) => MonitorEmployee(index: widget.index,
              latitudeLive: empLocationBox.get("Live${widget.index+1}")!.liveLati,
              longitudeLive: empLocationBox.get("Live${widget.index+1}")!.liveLong,
              isLive: _isLogIn,
              latitudesrc: empLocationBox.get("LoginEntry${widget.index+1}")!.latisrc,
              longitudesrc: empLocationBox.get("LoginEntry${widget.index+1}")!.longsrc,
              // latitudedes: empLocationBox.get("LogoutEntry${widget.index+1}")!.latides,
              // longitudedes: empLocationBox.get("LogoutEntry${widget.index+1}")!.longdes 
              )),  
            ) : empLocationBox.length>1? Navigator.push(  
              context,  
              MaterialPageRoute(builder: (context) => MonitorEmployee(index: widget.index,
              latitudeLive: empLocationBox.get("Live${widget.index+1}")!.liveLati,
              longitudeLive: empLocationBox.get("Live${widget.index+1}")!.liveLong,
              isLive: _isLogIn,
              latitudesrc: empLocationBox.get("LoginEntry${widget.index+1}")!.latisrc,
              longitudesrc: empLocationBox.get("LoginEntry${widget.index+1}")!.longsrc,
              latitudedes: empLocationBox.get("LogoutEntry${widget.index+1}")!.latides ,
              longitudedes: empLocationBox.get("LogoutEntry${widget.index+1}")!.longdes )),  
            ):debugPrint("Do Nothing");
          }, child: _isLogIn==true? const Text("Live Track"):const Text("Track")),
        _isLogIn==true?
          hiveintializing==false?
            empLocationBox.get('LoginEntry${widget.index+1}')!.loginTime!=null?Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Login Time  = ${empLocationBox.get('LoginEntry${widget.index+1}')!.loginTime} "),
            ):Container():Container() : Text("Duty Not Started/Ended"),
          _isLogIn==true?
          isLocationLoading==false?hiveintializing==false?
            empLocationBox.get('LoginEntry${widget.index+1}')!.loginTime!=null?Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Login Location  = ${addressLine}"),
            ):Container():Container() : Container():Container(),
      ]),),
      );
  }
  Future<void>getLocaion(double lat,double lon)async{
    isLocationLoading = true;
    String location = "";
    final coordinates = Coordinates(lat,lon);
    var address= await Geocoder.local.findAddressesFromCoordinates(coordinates);
    addressLine = address[0].addressLine!;
    
    isLocationLoading = false;
  }
}