import 'package:clinetserverapp2/server/employeeDetails_screen.dart';
import 'package:flutter/material.dart';

class ListEmployee extends StatefulWidget {
  const ListEmployee({super.key});

  @override
  State<ListEmployee> createState() => _ListEmployeeState();
}

class _ListEmployeeState extends State<ListEmployee> {
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
                              builder: (context) => EachEmployee(
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
    ;
  }
}
