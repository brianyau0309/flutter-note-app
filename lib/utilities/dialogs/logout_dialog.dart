import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) async =>
    (await showGenericDialog<bool>(
      context: context,
      title: "Logout",
      content: "Are you sure you want to logout?",
      optionsBuilder: () => {
        "Cancel": false,
        "Logout": true,
      },
    )) ??
    false;
