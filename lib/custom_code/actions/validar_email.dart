// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart';
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

bool validarEmail(String email) {
  if (email.contains(' ')) return false;
  if (!email.contains('@')) return false;
  final parts = email.split('@');
  if (parts.length != 2) return false;
  final local = parts[0];
  final domain = parts[1];
  if (local.isEmpty || local.length > 64) return false;
  if (domain.isEmpty || domain.length > 255) return false;
  if (local.startsWith('.') || local.endsWith('.')) return false;
  if (!RegExp(r'^[A-Za-z0-9.]+$').hasMatch(local)) return false;
  final localParts = local.split('.');
  if (localParts.any((p) => p.isEmpty)) return false;
  if (domain.startsWith('-') || domain.endsWith('-')) return false;
  final domainParts = domain.split('.');
  if (domainParts.length < 2) return false;
  for (final part in domainParts) {
    if (part.startsWith('-') || part.endsWith('-')) return false;
    if (!RegExp(r'^[A-Za-z0-9-]+$').hasMatch(part)) return false;
  }
  return true;
}
