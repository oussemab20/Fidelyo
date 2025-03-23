import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Components/Button.dart';
import '../Components/Customimagefield.dart';
import '../app_colors.dart';

class Addoffers extends StatefulWidget {
  final String shopUid; // Passed from Addstore page
  const Addoffers({super.key, required this.shopUid});

  @override
  State<Addoffers> createState() => _AddoffersState();
}

class _AddoffersState extends State<Addoffers> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  // Additional offer image variables
  File? _offerImageFile1; // Offer image 1
  File? _offerImageFile2; // Offer image 2
  File? _offerImageFile3; // Offer image 3

  CollectionReference offers = FirebaseFirestore.instance.collection('offers');

  // Initialize Cloudinary
  final cloudinary = Cloudinary.full(
    apiKey: '197697484636332',
    apiSecret: '6IJy9p6ST3Dqn6W8CA94VjgFRes',
    cloudName: 'dbuvyidvu',
  );

  Future<void> addOffer() async {
    if (_offerImageFile1 == null && _offerImageFile2 == null && _offerImageFile3 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one image for the offer")),
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

      // Upload offer images to Cloudinary
      List<String> offerImageUrls = [];

      if (_offerImageFile1 != null) {
        final offerImageResponse1 = await cloudinary.uploadResource(
          CloudinaryUploadResource(
            filePath: _offerImageFile1!.path,
            resourceType: CloudinaryResourceType.image,
          ),
        );
        if (offerImageResponse1.isSuccessful) {
          offerImageUrls.add(offerImageResponse1.secureUrl!);
        }
      }

      if (_offerImageFile2 != null) {
        final offerImageResponse2 = await cloudinary.uploadResource(
          CloudinaryUploadResource(
            filePath: _offerImageFile2!.path,
            resourceType: CloudinaryResourceType.image,
          ),
        );
        if (offerImageResponse2.isSuccessful) {
          offerImageUrls.add(offerImageResponse2.secureUrl!);
        }
      }

      if (_offerImageFile3 != null) {
        final offerImageResponse3 = await cloudinary.uploadResource(
          CloudinaryUploadResource(
            filePath: _offerImageFile3!.path,
            resourceType: CloudinaryResourceType.image,
          ),
        );
        if (offerImageResponse3.isSuccessful) {
          offerImageUrls.add(offerImageResponse3.secureUrl!);
        }
      }

      if (offerImageUrls.isNotEmpty) {
        // Add offer details to Firestore, including the shop UID and the logged-in user's UID
        final offerDoc = await offers.add({
          "offerImages": offerImageUrls, // Store all offer images
          "shopUid": widget.shopUid, // Pass shop UID from Addstore page
          "ownerUid": uid, // Associate the offer with the logged-in user
          "createdAt": DateTime.now(), // Optional: track creation date
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Offer added successfully!")),
        );

        // Clear the form
        setState(() {
          _offerImageFile1 = null;
          _offerImageFile2 = null;
          _offerImageFile3 = null;
        });
      } else {
        throw Exception("Failed to upload images to Cloudinary");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add offer: $e")),
      );
    }
  }

  void _onBrowseOfferImage1() async {
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
        _offerImageFile1 = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No file selected")),
      );
    }
  }

  void _onBrowseOfferImage2() async {
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
        _offerImageFile2 = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No file selected")),
      );
    }
  }

  void _onBrowseOfferImage3() async {
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
        _offerImageFile3 = File(pickedFile.path);
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
        title: Text(
          "Add A Offer",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold text
            color: Colors.purple, // Purple text color
          ),
        ),
        centerTitle:true,
        backgroundColor: Colors.white, // Replace with your desired hex color value
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formstate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Offer image 1
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text("Offer Image 1", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              if (_offerImageFile1 == null)
                Padding(
                  padding: EdgeInsets.all(10),
                  child: CustomImageField(
                    hinttext: "Choose a file for offer image 1",
                    subtext: "JPEG, PNG formats only, up to 50MB",
                    onBrowseFile: _onBrowseOfferImage1,
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Image.file(_offerImageFile1!, width: 200, height: 150, fit: BoxFit.cover),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _offerImageFile1 = null; // Remove the selected image
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // Offer image 2
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text("Offer Image 2", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              if (_offerImageFile2 == null)
                Padding(
                  padding: EdgeInsets.all(10),
                  child: CustomImageField(
                    hinttext: "Choose a file for offer image 2",
                    subtext: "JPEG, PNG formats only, up to 50MB",
                    onBrowseFile: _onBrowseOfferImage2,
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Image.file(_offerImageFile2!, width: 200, height: 150, fit: BoxFit.cover),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _offerImageFile2 = null; // Remove the selected image
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // Offer image 3
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text("Offer Image 3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              if (_offerImageFile3 == null)
                Padding(
                  padding: EdgeInsets.all(10),
                  child: CustomImageField(
                    hinttext: "Choose a file for offer image 3",
                    subtext: "JPEG, PNG formats only, up to 50MB",
                    onBrowseFile: _onBrowseOfferImage3,
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Image.file(_offerImageFile3!, width: 200, height: 150, fit: BoxFit.cover),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _offerImageFile3 = null; // Remove the selected image
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              Padding(
                padding: EdgeInsets.all(20),
                child: CustombuttonAuth(
                  Title: "Add Offer",
                  onPressed: () {
                    if (formstate.currentState!.validate()) {
                      addOffer();
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
