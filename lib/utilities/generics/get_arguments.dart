import 'package:flutter/material.dart' show BuildContext, ModalRoute;

extension GetArguments on BuildContext {
  T? getArguments<T>() {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final arguments = modalRoute.settings.arguments;
      if (arguments != null && arguments is T) {
        return arguments as T;
      }
    }
    return null;
  }
}
