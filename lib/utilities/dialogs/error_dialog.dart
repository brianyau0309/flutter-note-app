import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String content, {
  String title = "An error occurs",
}) =>
    showGenericDialog<void>(
      context: context,
      title: title,
      content: content,
      optionsBuilder: () => {
        "OK": null,
      },
    );
