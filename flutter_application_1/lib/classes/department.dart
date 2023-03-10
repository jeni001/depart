class Department {
  int Dept_ID;
  String Deptname;
  Department(this.Dept_ID, this.Deptname);
  factory Department.fromJson(Map<String, dynamic> parsedJson) {
    return Department(
        parsedJson["DEPT_ID"] as int, parsedJson["DEPTNAME"] as String);
  }
}
