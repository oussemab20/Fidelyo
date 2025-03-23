import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:fidelyo/Components/Button.dart';
import 'package:fidelyo/Components/TextFormFiledadd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Components/Customimagefield.dart';
import '../app_colors.dart';
import 'EditOffers.dart'; // Make sure to import EditOffers page

class EditStore extends StatefulWidget {
  final String storeId; // Store ID passed from previous screen

  const EditStore({super.key, required this.storeId});

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();

  File? _selectedFile; // Shop image
  File? _logoFile; // Shop logo image
  String _shopImageUrl = ''; // Shop image URL
  String _logoImageUrl = ''; // Logo image URL
  CollectionReference shops = FirebaseFirestore.instance.collection('shops');
  bool isResized = false; // Flag to toggle image resizing

  // Initialize Cloudinary
  final cloudinary = Cloudinary.full(
    apiKey: '197697484636332',
    apiSecret: '6IJy9p6ST3Dqn6W8CA94VjgFRes',
    cloudName: 'dbuvyidvu',
  );

  // Load current store data from Firestore
  @override
  void initState() {
    super.initState();
    _loadStoreData();
  }
  Future<void> deleteStore() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Store"),
        content: Text("Are you sure you want to delete this store? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (!confirm) return;

    try {
      // Suppression des images de Cloudinary
      if (_shopImageUrl.isNotEmpty) {
        await cloudinary.deleteResource(publicId: _shopImageUrl.split('/').last.split('.').first);
      }
      if (_logoImageUrl.isNotEmpty) {
        await cloudinary.deleteResource(publicId: _logoImageUrl.split('/').last.split('.').first);
      }

      // Suppression du magasin de Firestore
      await shops.doc(widget.storeId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Store deleted successfully!")),
      );

      // Retour à l'écran précédent
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete store: $e")),
      );
    }
  }
  Future<void> _loadStoreData() async {
    try {
      final storeSnapshot = await shops.doc(widget.storeId).get();
      if (storeSnapshot.exists) {
        final storeData = storeSnapshot.data() as Map<String, dynamic>;

        name.text = storeData["name"] ?? '';
        description.text = storeData["description"] ?? '';
        location.text = storeData["location"] ?? '';

        _shopImageUrl = storeData["shopImage"] ?? '';
        _logoImageUrl = storeData["logo"] ?? '';

        setState(() {
          // Trigger rebuild to display images
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load store data: $e")),
      );
    }
  }

  Future<void> updateStore() async {
    if (_selectedFile == null || _logoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select both shop image and logo")),
      );
      return;
    }

    try {
      // Upload the updated images to Cloudinary
      final shopImageResponse = await cloudinary.uploadResource(
        CloudinaryUploadResource(
          filePath: _selectedFile!.path,
          resourceType: CloudinaryResourceType.image,
        ),
      );
      final logoImageResponse = await cloudinary.uploadResource(
        CloudinaryUploadResource(
          filePath: _logoFile!.path,
          resourceType: CloudinaryResourceType.image,
        ),
      );

      if (shopImageResponse.isSuccessful && logoImageResponse.isSuccessful) {
        final shopImageUrl = shopImageResponse.secureUrl!;
        final logoImageUrl = logoImageResponse.secureUrl!;

        // Update shop details in Firestore
        await shops.doc(widget.storeId).update({
          "name": name.text,
          "shopImage": shopImageUrl,
          "logo": logoImageUrl,
          "location": location.text,
          "description": description.text,
          "updatedAt": DateTime.now(), // Optional: track last update date
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Store updated successfully!")),
        );
      } else {
        throw Exception("Failed to upload images to Cloudinary");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update store: $e")),
      );
    }
  }

  // Image selection methods
  void _onBrowseShopImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  void _onBrowseLogoImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _logoFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Store",
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
              // Shop Name
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
              // Shop Image
              if (_selectedFile == null && _shopImageUrl == '')
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
                      _selectedFile != null
                          ? Image.file(_selectedFile!, width: 200, height: 150, fit: BoxFit.cover)
                          : Image.network(_shopImageUrl, width: 200, height: 150, fit: BoxFit.cover),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _selectedFile = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              // Shop Logo
              if (_logoFile == null && _logoImageUrl == '')
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
                      _logoFile != null
                          ? Image.file(_logoFile!, width: 200, height: 150, fit: BoxFit.cover)
                          : Image.network(_logoImageUrl, width: 200, height: 150, fit: BoxFit.cover),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _logoFile = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              // Location
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
              // Description
              Padding(
                padding: EdgeInsets.all(10),
                child: CustomTextFormAdd(
                  hinttext: "Enter Shop Description",
                  mycontroller: description,
                  maxLines: 5,
                  validator: (val) {
                    if (val == "") {
                      return "Description can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              // Button to navigate to Edit Offers

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Editoffers(offerId: ''),
                        ),
                      );
                    },
                    child: Text("Edit Offers"),
                  ),
                  TextButton(
                    onPressed: deleteStore,
                    child: Text(
                      "Delete the Shop",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              // Update button
              Padding(
                padding: EdgeInsets.all(10),
                child: CustombuttonAuth(
                  Title: "Update",
                  onPressed: () {
                    if (formstate.currentState!.validate()) {
                      updateStore();
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
