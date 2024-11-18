import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final bool obscureText; // New parameter for obscuring text
  final String? Function(String?)? validator ;
  const CustomTextForm({
    super.key,
    required this.hinttext,
    required this.mycontroller,
    this.obscureText = false,
    required this.validator, // Default to false if not provided
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      obscureText: obscureText, // Pass the obscureText value here
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: TextStyle(fontSize: 18, color: Colors.grey[700]),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        filled: true,
        fillColor: Colors.white70,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
