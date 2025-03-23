import 'package:fidelyo/Components/Button.dart';
import 'package:fidelyo/HomePage.dart';
import 'package:fidelyo/Register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'PaymentScreen.dart';
import 'Components/logo.dart';
import 'ForgetPassword.dart';

import 'PaymentScreen.dart';
import 'QRCodeScannerPage.dart';
import 'Store/AddOffers.dart';
import 'Store/AddStore.dart';

import 'Store/ClientManagement.dart';
import 'Store/EditOffers.dart';
import 'Store/UpdateStore.dart';
import 'app_colors.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Enable Firebase debug logging (catch authentication errors)
  FirebaseAuth.instance.setPersistence(Persistence.LOCAL); // Example setting persistence

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('========================= User is currently signed out!');
      } else {
        print('========================= User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified) ?HomePage() : Login(),
      routes: {
        '/register': (context) => Register(),
        '/login': (context) => Login(),
        '/homepage': (context) => HomePage(),
        '/forgetpassword': (context) => Forgetpassword(),
        '/addstore': (context) => Addstore(),
        '/updatestore': (context) => Updatestore(),
        'addoffers': (context) => Addoffers(shopUid: '',),
        'editoffers': (context) => Editoffers(offerId: '',),
        '/Clientmanagement': (context) => Clientmanagement(),
        '/QRCodeScannerPage': (context) => QRCodeScannerPage(),
        '/PaymentScreen': (context) => PaymentScreen(cardID: '',),



      },
    );
  }
}


