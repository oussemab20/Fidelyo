import 'package:flutter/material.dart';

class CustomLogo1 extends StatelessWidget {
  const CustomLogo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Center(child: Image.asset('assets/LOGO.png')),
    );
  }
}

