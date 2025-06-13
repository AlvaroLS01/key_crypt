// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
import 'dart:math';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

String generateStrongPassword(int length) {
  const String lowerCase = 'abcdefghijklmnopqrstuvwxyz';
  const String upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String numbers = '0123456789';
  const String specialChars = '!@#\$%^&*()-_=+{}[]|;:<>,.?/~';

  final String allChars = lowerCase + upperCase + numbers + specialChars;
  final Random random = Random.secure();

  String password = '' +
      lowerCase[random.nextInt(lowerCase.length)] +
      upperCase[random.nextInt(upperCase.length)] +
      numbers[random.nextInt(numbers.length)] +
      specialChars[random.nextInt(specialChars.length)];

  for (int i = password.length; i < length; i++) {
    password += allChars[random.nextInt(allChars.length)];
  }

  return password;
}
