import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:fidelyo/Components/Button.dart';
import 'package:fidelyo/Components/Customimagefield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../app_colors.dart';

class Editoffers extends StatefulWidget {
  final String offerId; // Offer document ID passed from the list of offers
  const Editoffers({super.key, required this.offerId});

  @override
  State<Editoffers> createState() => _EditoffersState();
}

class _EditoffersState extends State<Editoffers> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  // Variables for offer images
  File? _offerImageFile1;
  File? _offerImageFile2;
  File? _offerImageFile3;

  // Variables for image URLs
  String _offerImageUrl1 = '';
  String _offerImageUrl2 = '';
  String _offerImageUrl3 = '';

  CollectionReference offers = FirebaseFirestore.instance.collection('offers');

  // Cloudinary initialization
  final cloudinary = Cloudinary.full(
    apiKey: '197697484636332',
    apiSecret: '6IJy9p6ST3Dqn6W8CA94VjgFRes',
    cloudName: 'dbuvyidvu',
  );

  // Fetch offer details
  Future<void> fetchOffer() async {
    try {
      DocumentSnapshot offerDoc = await offers.doc(widget.offerId).get();
      if (offerDoc.exists) {
        setState(() {
          _offerImageUrl1 = offerDoc['offerImages'][0];
          _offerImageUrl2 = offerDoc['offerImages'][1];
          _offerImageUrl3 = offerDoc['offerImages'][2];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to fetch offer details: $e")));
    }
  }

  // Update offer with new images
  Future<void> updateOffer() async {
    try {
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
      } else if (_offerImageUrl1.isNotEmpty) {
        offerImageUrls.add(_offerImageUrl1); // Keep existing image if no new image selected
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
      } else if (_offerImageUrl2.isNotEmpty) {
        offerImageUrls.add(_offerImageUrl2); // Keep existing image if no new image selected
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
      } else if (_offerImageUrl3.isNotEmpty) {
        offerImageUrls.add(_offerImageUrl3); // Keep existing image if no new image selected
      }

      if (offerImageUrls.isNotEmpty) {
        await offers.doc(widget.offerId).update({
          "offerImages": offerImageUrls,
          "updatedAt": DateTime.now(), // Optional: track last updated time
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Offer updated successfully!")));
      } else {
        throw Exception("Failed to upload images to Cloudinary");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update offer: $e")));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOffer(); // Fetch offer data when page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Offer",
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
              // Offer Image 1
              if (_offerImageFile1 == null && _offerImageUrl1 == '')
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
                      _offerImageFile1 != null
                          ? Image.file(_offerImageFile1!, width: 200, height: 150, fit: BoxFit.cover)
                          : Image.network(_offerImageUrl1, width: 200, height: 150, fit: BoxFit.cover),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _offerImageFile1 = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // Offer Image 2
              if (_offerImageFile2 == null && _offerImageUrl2 == '')
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
                      _offerImageFile2 != null
                          ? Image.file(_offerImageFile2!, width: 200, height: 150, fit: BoxFit.cover)
                          : Image.network(_offerImageUrl2, width: 200, height: 150, fit: BoxFit.cover),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _offerImageFile2 = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // Offer Image 3
              if (_offerImageFile3 == null && _offerImageUrl3 == '')
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
                      _offerImageFile3 != null
                          ? Image.file(_offerImageFile3!, width: 200, height: 150, fit: BoxFit.cover)
                          : Image.network(_offerImageUrl3, width: 200, height: 150, fit: BoxFit.cover),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _offerImageFile3 = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // Update button
              Padding(
                padding: EdgeInsets.all(20),
                child: CustombuttonAuth(
                  Title: "Update Offer",
                  onPressed: () {
                    if (formstate.currentState!.validate()) {
                      updateOffer();
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

  // Image picker methods
  void _onBrowseOfferImage1() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _offerImageFile1 = File(pickedFile.path);
      });
    }
  }

  void _onBrowseOfferImage2() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _offerImageFile2 = File(pickedFile.path);
      });
    }
  }

  void _onBrowseOfferImage3() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _offerImageFile3 = File(pickedFile.path);
      });
    }
  }
}
