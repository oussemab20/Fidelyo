import 'package:flutter/material.dart';

class CustomTextFormAdd extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final bool obscureText; // Parameter for obscuring text
  final String? Function(String?)? validator;
  final int maxLines; // New parameter for maximum lines

  const CustomTextFormAdd({
    super.key,
    required this.hinttext,
    required this.mycontroller,
    this.obscureText = false, // Default to false
    required this.validator,
    this.maxLines = 1, // Default to a single line
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      obscureText: obscureText,
      maxLines: maxLines, // Pass the maxLines value here
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