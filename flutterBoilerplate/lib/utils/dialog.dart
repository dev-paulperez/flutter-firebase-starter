import 'package:flutter/material.dart';

abstract class DialogHelper {
  static Future<void> showAlertDialog<T>({
    BuildContext context,
    String story,
    String btnText,
    Function btnAction,
  }) =>
      showDialog<T>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            story,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          contentPadding: const EdgeInsets.all(10.0),
          actions: [
            FlatButton(
              color: Colors.blueGrey,
              child: Text(
                btnText,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: btnAction,
            )
          ],
        ),
      );
}
