import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _pin = prefs.getString('ff_pin') ?? _pin;
    });
    _safeInit(() {
      _usuarioid = prefs.getString('ff_usuarioid') ?? _usuarioid;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _pin = '';
  String get pin => _pin;
  set pin(String value) {
    _pin = value;
    prefs.setString('ff_pin', value);
  }

  String _usuarioid = '';
  String get usuarioid => _usuarioid;
  set usuarioid(String value) {
    _usuarioid = value;
    prefs.setString('ff_usuarioid', value);
  }

  String _email = '';
  String get email => _email;
  set email(String value) {
    _email = value;
  }

  String _contrasena = '';
  String get contrasena => _contrasena;
  set contrasena(String value) {
    _contrasena = value;
  }

  String _clave = '';
  String get clave => _clave;
  set clave(String value) {
    _clave = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
