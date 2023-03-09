import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppCommon {
  static String hostname = "http://192.168.1.89:5000";

  showErrorAlertDialog(BuildContext context1, String msg) {
    showDialog(
      context: context1,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Failed"),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        content: Text(msg),
        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  showAlertWithoutTitleDialog(BuildContext context1, String msg) {
    showDialog(
      context: context1,
      builder: (BuildContext context) => AlertDialog(
        content: Text(msg),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
