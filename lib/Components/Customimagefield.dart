import 'package:flutter/material.dart';

class CustomImageField extends StatelessWidget {
  final String hinttext; // Text: "Choose a file or drag & drop it here"
  final String subtext; // Text: "JPEG, PNG, PDF, and MP4 formats, up to 50MB"
  final VoidCallback onBrowseFile; // Callback when the field is tapped
  const CustomImageField({
    super.key,
    required this.hinttext,
    required this.subtext,
    required this.onBrowseFile,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBrowseFile, // Entire container is tappable
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1),
          color: Colors.grey[200],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                hinttext,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 8),
              Text(
                subtext,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              SizedBox(height: 8),
              Text(
                "Browse File",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
