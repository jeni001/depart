import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/main.dart';
import 'package:http/http.dart' as http;

import 'AppCommon.dart';
import 'classes/department.dart';

class Job_Work extends StatefulWidget {
  const Job_Work({super.key});

  @override
  State<Job_Work> createState() => _Job_WorkState();
}

class _Job_WorkState extends State<Job_Work> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadDeptList();
  }

  TextEditingController dn = TextEditingController();
  TextEditingController _dept = TextEditingController();
  List<String> lstDN = <String>[];
  List<Department> lstDept = [];
  int deptId = 0;
  List<String> Dept = <String>['admin', 'developer', 'support'];

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

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Job Work"),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () {
                  // LoadDeptList();
                  // dn.clear();
                  FocusScope.of(context).unfocus();
                }),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 08, top: 08),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            "Job Work:",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 08, top: 08),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            "Discription:",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 08, top: 08),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            "Department:",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: _dept,
                            decoration: InputDecoration(
                              suffixIcon: PopupMenuButton<String>(
                                icon: const Icon(Icons.arrow_drop_down),
                                onSelected: (String value) {
                                  _dept.text = value;
                                },
                                itemBuilder: (BuildContext context) {
                                  return Dept.map<PopupMenuItem<String>>(
                                      (String value) {
                                    return PopupMenuItem(
                                        value: value, child: Text(value));
                                  }).toList();
                                },
                              ),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: ListView.builder(
                        //       shrinkWrap: true,
                        //       physics: const ScrollPhysics(),
                        //       scrollDirection: Axis.vertical,
                        //       itemCount: lstDept.length,
                        //       itemBuilder: (BuildContext context, int index) {
                        //         return ListTile(
                        //           title: Text('lstDept[index].Department'),
                        //           leading: IconButton(
                        //               icon: Icon(
                        //                 Icons.edit_outlined,
                        //                 color: Colors.blueGrey,
                        //               ),
                        //               onPressed: () {
                        //                 setState(() {
                        //                   deptId = lstDept[index].Dept_ID;
                        //                   dn.text = lstDept[index].Deptname;
                        //                 });
                        //               }),
                        //           trailing: IconButton(
                        //               icon: Icon(
                        //                 Icons.delete_outline_sharp,
                        //                 color: Color.fromARGB(255, 62, 90, 81),
                        //               ),
                        //               onPressed: () {
                        //                 // DeleteDepartment(lstDept[index].Dept_ID);
                        //               }),
                        //         );
                        //       }),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
