import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDTMdyLC8AsQ1ogjZ-duD3ZSfA3xEhTItI",
            authDomain: "keycrypt-454ed.firebaseapp.com",
            projectId: "keycrypt-454ed",
            storageBucket: "keycrypt-454ed.firebasestorage.app",
            messagingSenderId: "75223222314",
            appId: "1:75223222314:web:e8cc2e1c03a2c42bf35b53",
            measurementId: "G-0E48KEHLEV"));
  } else {
    await Firebase.initializeApp();
  }
}
