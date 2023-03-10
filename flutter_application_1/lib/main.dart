import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/AppCommon.dart';
import 'package:flutter_application_1/classes/department.dart';
import 'package:flutter_application_1/jobworkpage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Dept());
}

class Dept extends StatelessWidget {
  const Dept({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Department',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController dn = TextEditingController();
  List<String> lstDN = <String>[];
  List<Department> lstDept = [];
  int deptId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadDeptList();
  }

  void LoadDeptList() async {
    String encodedURl = AppCommon.hostname + "/List/GetDepartmentList";

    http.Response response = await http
        .post(Uri.parse(encodedURl), headers: {"Accept": "application/json"});

    var data = json.decode(response.body);
    if (data["StatusVal"] == false) {
      AppCommon().showErrorAlertDialog(context, data["StatusMsg"]);
      return;
    } else {
      var parsedDept = data["Data"].cast<Map<String, dynamic>>();
      List<Department> _LstDept = parsedDept
          .map<Department>((json) => Department.fromJson(json))
          .toList();

      setState(() {
        lstDept = _LstDept;
      });
    }
  }

  void DeleteDepartment(int DeptID) async {
    String encodedURl = AppCommon.hostname +
        "/List/DeleteDepartment?DeptID=" +
        DeptID.toString();

    http.Response response = await http
        .post(Uri.parse(encodedURl), headers: {"Accept": "application/json"});

    var data = json.decode(response.body);
    if (data["StatusVal"] == false) {
      AppCommon().showErrorAlertDialog(context, data["StatusMsg"]);
      return;
    }
    var parsedDept = data["Data"].cast<Map<String, dynamic>>();
    List<Department> _LstDept = parsedDept
        .map<Department>((json) => Department.fromJson(json))
        .toList();

    setState(() {
      lstDept = _LstDept;
    });
  }

  void SaveDN() async {
    String encodedURl = AppCommon.hostname +
        "/DataLoad/SaveDepartment?DeptID=" +
        deptId.toString() +
        "&DeptName=" +
        dn.text;

    http.Response response = await http
        .post(Uri.parse(encodedURl), headers: {"Accept": "application/json"});

    var data = json.decode(response.body);
    if (data["StatusVal"] == false) {
      AppCommon().showErrorAlertDialog(context, data["StatusMsg"]);
      return;
    }

    var parsedDept = data["Data"].cast<Map<String, dynamic>>();
    List<Department> _LstDept = parsedDept
        .map<Department>((json) => Department.fromJson(json))
        .toList();

    setState(() {
      deptId = 0;
      dn.text = "";
      lstDept = _LstDept;
    });
    dn.clear();
    FocusScope.of(context).unfocus();
  }

  deleteItem(int index) {
    setState(() {
      lstDept.removeAt(index);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Department"),
          backgroundColor: Color.fromARGB(255, 62, 90, 81),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  LoadDeptList();
                  dn.clear();
                  FocusScope.of(context).unfocus();
                }),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 13.0, right: 13.0, top: 8.0),
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //       decoration: InputDecoration(
              //           focusColor: Colors.brown,
              //           hintText: "Department Id",
              //           border: OutlineInputBorder(
              //               borderRadius:
              //                   BorderRadius.all(Radius.circular(5.0))))),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                        controller: dn,
                        decoration: InputDecoration(
                            focusColor: Color.fromARGB(255, 62, 90, 81),
                            hintText: "Department Name",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (dn.text != null) return SaveDN();
                        },
                        child: Text(deptId > 0 ? "Update" : "Save")),
                  ),
                  // if (deptId > 0)
                  //   Padding(
                  //     padding: const EdgeInsets.only(left: 8.0),
                  //     child: ElevatedButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           deptId = 0;
                  //           dn.clear();
                  //         });
                  //       },
                  //       child: Text("Cancel"),
                  //     ),
                  //   )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text('You have ${lstDept.length} Items'),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: lstDept.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(lstDept[index].Deptname),
                        leading: IconButton(
                            icon: Icon(
                              Icons.edit_outlined,
                              color: Color.fromARGB(255, 62, 90, 81),
                            ),
                            onPressed: () {
                              setState(() {
                                deptId = lstDept[index].Dept_ID;
                                dn.text = lstDept[index].Deptname;
                              });
                            }),
                        trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline_sharp,
                              color: Color.fromARGB(255, 62, 90, 81),
                            ),
                            onPressed: () {
                              DeleteDepartment(lstDept[index].Dept_ID);
                            }),
                      );
                    }),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Job_Work()));
                },
                child: Text('JW'),
              )
            ],
          ),
        ));
  }
}
