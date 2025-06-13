// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math';

/// DO NOT REMOVE
Future<String> generarPin() async {
  var random = Random();
  String pin = '';
  for (int i = 0; i < 6; i++) {
    pin += (random.nextInt(9) + 1).toString();
  }
  return pin;
}
