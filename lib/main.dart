import 'package:fidelyo/Components/Button.dart';
import 'package:fidelyo/HomePage.dart';
import 'package:fidelyo/Register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Components/logo.dart';
import 'ForgetPassword.dart';
import 'Store/AddStore.dart';
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
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified) ?HomePage() : Login(),
      routes: {
        '/register': (context) => Register(),
        '/login': (context) => Login(),
        '/homepage': (context) => HomePage(),
        '/forgetpassword': (context) => Forgetpassword(),
        '/addstore': (context) => Addstore(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 30, right: 30, left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                CustomLogo(),
                SizedBox(height: 50),
                Text(
                  'Welcome !',
                  style: TextStyle(
                    fontSize: 38,
                    color: Color(0xFF341355),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Please select whether you are a '
                      'customer, shop owner, or app '
                      'administrator',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF4E0189),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(380, 90),
                    backgroundColor: Color(0xFF341355),
                  ),
                  child: Text(
                    'CUSTOMER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(380, 90),
                    backgroundColor: Color(0xFF4E0189),
                  ),
                  child: Text(
                    'SHOP OWNER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(380, 90),
                    backgroundColor: Color(0xFF4E0189),
                  ),
                  child: Text(
                    'ADMINISTRATOR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            CustombuttonAuth(
              Title: "Next ",
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ],
        ),
      ),
    );
  }
}
