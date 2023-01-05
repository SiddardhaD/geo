import 'dart:io';

import 'package:clinetserverapp2/server/eachEmp_screen.dart';
import 'package:clinetserverapp2/track/live.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'client/employeeList_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'employeesData.dart';
import 'geoFence/geofetch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneInsure',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var path = Directory.current.path;

  @override
  void initState() {
    enableHive();
    enableHiveClass();
    super.initState();
  }

  Future<void> enableHiveClass() async {
    Hive
      ..init(path)
      ..registerAdapter(EmployeedataAdapter());
  }

  enableHive() async {
    await Hive.initFlutter();
    debugPrint("Hive Intializtion us Done");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmployeeList()),
                );
              },
              child: const Text("Client"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListEmployee()),
                );
              },
              child: const Text("Server"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GeoFence()),
                );
              },
              child: const Text("Fence"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LiveTrack()),
                );
              },
              child: const Text("Live Track"),
            ),
            TextButton(
              child: Text("Invoke Map"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () async {
                await launchUrl(
                    Uri.parse("google.navigation:q=17.433028, 78.3908344"));
              },
            )
          ],
        ),
      ),
    );
  }
}
