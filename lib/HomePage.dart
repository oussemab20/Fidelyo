import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Components/logo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              CustomLogo(),
              SizedBox(height: 10),

              // First Container
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/addstore');
                },
                child: Container(
                  width: double.infinity,
                  height: 130,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF4E0189),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " ADD SHOP",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF5F06A0),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_circle_right_outlined, color: Colors.white, size: 28),
                                      SizedBox(width: 4),
                                      Text("Shop", style: TextStyle(color: Colors.white, fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.storefront, color: Colors.white, size: 44),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Second Container
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/updatestore');
                },
                child: Container(
                  width: double.infinity,
                  height: 130,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF4E0189),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " MODIFY SHOP",
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF5F06A0),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_circle_right_outlined, color: Colors.white, size: 28),
                                      SizedBox(width: 4),
                                      Text("Shop", style: TextStyle(color: Colors.white, fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.storefront, color: Colors.white, size: 44),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Third Container
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/Clientmanagement');
                },
                child: Container(
                  width: double.infinity,
                  height: 130,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF4E0189),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " CLIENT MANAGEMENT",
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF5F06A0),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_circle_right_outlined, color: Colors.white, size: 28),
                                      SizedBox(width: 4),
                                      Text("Client", style: TextStyle(color: Colors.white, fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add_alt_1_outlined, color: Colors.white, size: 44),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: ()  {
                  Navigator.of(context).pushNamed('/QRCodeScannerPage');
                },
                child: Container(
                  width: double.infinity,
                  height: 130,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF4E0189),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " Payment ",
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF5F06A0),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_circle_right_outlined, color: Colors.white, size: 28),
                                      SizedBox(width: 4),
                                      Text("Scann QR", style: TextStyle(color: Colors.white, fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_scanner, color: Colors.white, size: 44),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  GoogleSignIn googleSignIN = GoogleSignIn();
                  googleSignIN.disconnect();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamed("/login");
                },
                child: Container(
                  width: double.infinity,
                  height: 130,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF000000),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " DISCONNECT ",
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_circle_right_outlined, color: Colors.black, size: 28),
                                      SizedBox(width: 4),
                                      Text("Log Out", style: TextStyle(color: Colors.black, fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, color: Colors.white, size: 44),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Fourth Container



            ],
          ),
        ),
      )),
    );
  }
}
