// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> loginUsuario(String usuario, String contrasena) async {
  final response = await http.post(
    Uri.parse('http://192.168.1.136:8000/login'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'usuario': usuario, // 👈 CORREGIDO
      'contrasena': contrasena,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['success'] ?? false; // <--- este es el cambio importante
  } else {
    throw Exception('Error al hacer login');
  }
}
