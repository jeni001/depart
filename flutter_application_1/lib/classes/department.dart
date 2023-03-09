class Dment {
  int Dept_ID;
  String Deptname;
  Dment(this.Dept_ID, this.Deptname);
  factory Dment.fromJson(Map<String, dynamic> parsedJson) {
    return Dment(
        parsedJson["DEPT_ID"] as int, parsedJson["DEPTNAME"] as String);
  }
}
