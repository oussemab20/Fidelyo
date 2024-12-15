import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';

import 'package:fidelyo/Components/TextFormFiledadd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Components/Button.dart';
import '../Components/Customimagefield.dart';
import '../app_colors.dart';
import 'addoffers.dart';  // Import the Addoffers page

class Addstore extends StatefulWidget {
  const Addstore({super.key});

  @override
  State<Addstore> createState() => _AddstoreState();
}

class _AddstoreState extends State<Addstore> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();

  File? _selectedFile; // Shop image
  File? _logoFile; // Shop logo image
  CollectionReference shops = FirebaseFirestore.instance.collection('shops');

  // Initialize Cloudinary
  final cloudinary = Cloudinary.full(
    apiKey: '197697484636332',
    apiSecret: '6IJy9p6ST3Dqn6W8CA94VjgFRes',
    cloudName: 'dbuvyidvu',
  );

  Future<void> addUser() async {
    if (_selectedFile == null || _logoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select all images")),
      );
      return;
    }

    try {
      // Get the logged-in user's UID
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final uid = user.uid;

      // Upload the main shop image to Cloudinary
      final shopImageResponse = await cloudinary.uploadResource(
        CloudinaryUploadResource(
          filePath: _selectedFile!.path,
          resourceType: CloudinaryResourceType.image,
        ),
      );

      // Upload the shop logo to Cloudinary
      final logoImageResponse = await cloudinary.uploadResource(
        CloudinaryUploadResource(
          filePath: _logoFile!.path,
          resourceType: CloudinaryResourceType.image,
        ),
      );

      if (shopImageResponse.isSuccessful && logoImageResponse.isSuccessful) {
        final shopImageUrl = shopImageResponse.secureUrl!;
        final logoImageUrl = logoImageResponse.secureUrl!;

        // Add shop details to Firestore, including the owner's UID
        final shopDoc = await shops.add({
          "name": name.text,
          "shopImage": shopImageUrl,
          "logo": logoImageUrl,
          "location": location.text,
          "description": description.text,
          "ownerUid": uid, // Associate the shop with the logged-in user
          "createdAt": DateTime.now(), // Optional: track creation date
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Shop added successfully!")),
        );

        // Navigate to Addoffers page and pass the shopId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Addoffers(shopUid: shopDoc.id), // Pass shop ID
          ),
        );

        // Clear the form
        setState(() {
          name.clear();
          location.clear();
          description.clear();
          _selectedFile = null;
          _logoFile = null;
        });
      } else {
        final errorMessage = shopImageResponse.error != null
            ? shopImageResponse.error.toString()
            : "Unknown error occurred";
        throw Exception("Failed to upload images to Cloudinary: $errorMessage");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add shop: $e")),
      );
    }
  }

  void _onBrowseShopImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String fileExtension = pickedFile.path.split('.').last.toLowerCase();

      // Validate file type
      if (!['jpg', 'jpeg', 'png'].contains(fileExtension)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unsupported file type")),
        );
        return;
      }

      // Validate file size (50MB limit)
      if (File(pickedFile.path).lengthSync() > 50 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File size exceeds the 50MB limit")),
        );
        return;
      }

      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No file selected")),
      );
    }
  }

  void _onBrowseLogoImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String fileExtension = pickedFile.path.split('.').last.toLowerCase();

      // Validate file type
      if (!['jpg', 'jpeg', 'png'].contains(fileExtension)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unsupported file type")),
        );
        return;
      }

      // Validate file size (50MB limit)
      if (File(pickedFile.path).lengthSync() > 50 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File size exceeds the 50MB limit")),
        );
        return;
      }

      setState(() {
        _logoFile = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No file selected")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add A Shop"),
        backgroundColor: AppColors.textPrimary, // Replace with your desired hex color value
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formstate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text("Shop Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: CustomTextFormAdd(
                  hinttext: "Enter Shop Name",
                  mycontroller: name,
                  validator: (val) {
                    if (val == "") {
                      return "Name can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text("Shop image", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              if (_selectedFile == null)
                Padding(
                  padding: EdgeInsets.all(10),
                  child: CustomImageField(
                    hinttext: "Choose a file for shop image",
                    subtext: "JPEG, PNG formats only, up to 50MB",
                    onBrowseFile: _onBrowseShopImage,
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Image.file(_selectedFile!, width: 200, height: 150, fit: BoxFit.cover),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _selectedFile = null; // Remove the selected image
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text("Shop Logo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              if (_logoFile == null)
                Padding(
                  padding: EdgeInsets.all(10),
                  child: CustomImageField(
                    hinttext: "Choose a file for shop logo",
                    subtext: "JPEG, PNG formats only, up to 50MB",
                    onBrowseFile: _onBrowseLogoImage,
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Image.file(_logoFile!, width: 200, height: 150, fit: BoxFit.cover),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _logoFile = null; // Remove the logo image
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text("Shop Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: CustomTextFormAdd(
                  hinttext: "Enter Shop Description",
                  mycontroller: description,
                  validator: (val) {
                    if (val == "") {
                      return "Description can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text("Shop Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: CustomTextFormAdd(
                  hinttext: "Enter Shop Location",
                  mycontroller: location,
                  validator: (val) {
                    if (val == "") {
                      return "Location can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: CustombuttonAuth(
                  Title: "Add",
                  onPressed: () {
                    if (formstate.currentState!.validate()) {
                      addUser();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
