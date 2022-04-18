import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String message,
        {String title = "An error occurs"}) =>
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"))
              ],
            ));
