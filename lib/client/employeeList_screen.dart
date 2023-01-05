import 'dart:io';

import 'package:flutter/material.dart';

import 'loginSreen.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  @override
  var path = Directory.current.path;

  void initState() {
    super.initState();
  }

  // Future<void> enableHive()async{
  //   Hive
  //   ..init(path)
  //   ..registerAdapter(CoordinatesAdapter());
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List"),
      ),
      body: Container(
        child: Column(children: [
          // Align(alignment: Alignment.center,child: const Text("Our Employees")),
          Expanded(
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 20),
                    height: MediaQuery.of(context).size.height / 8,
                    child: TextButton(
                      child: Text("Employee ${index + 1}"),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.blue,
                        elevation: 20,
                        minimumSize: Size(100, 50),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login(
                                    index: index,
                                  )),
                        );
                      },
                    ),
                  );
                }),
          ),
        ]),
      ),
    );
  }
}
