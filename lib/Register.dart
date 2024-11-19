import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fidelyo/Components/Button.dart';
import 'package:fidelyo/Components/TextFormFiled.dart';
import 'package:fidelyo/Components/logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController(); // Controller remains for UI
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController zipcode = TextEditingController();
  GlobalKey<FormState> formState =GlobalKey<FormState>();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    // Get the current user's UID from FirebaseAuth
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Call the user's CollectionReference to add a new user
    return users
        .doc(uid) // Use the UID as the document ID
        .set({
      'full_name': name.text,
      'email': email.text,
      'address': address.text,
      'location': location.text,
      'zipcode': zipcode.text,
      'created_at': FieldValue.serverTimestamp(), // Optionally add a timestamp
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomLogo(),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Full name ",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextForm(hinttext: "Enter your Name", mycontroller: name, validator: (val){
                    if (val == ""){
                      return "Fill Your Filds" ;
                    }
                  }),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email Address ",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextForm(hinttext: "Enter your Email", mycontroller: email, validator: (val){
                    if (val == ""){
                      return "Fill Your Filds" ;
                    }
                  },),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Address ",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextForm(hinttext: "Enter your Address", mycontroller: address,validator: (val){
                    if (val == ""){
                      return "Fill Your Filds" ;
                    }
                  },),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Location ",
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Add spacing between the fields if needed
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Zip Code ",
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextForm(hinttext: "", mycontroller: zipcode,validator: (val){
                          if (val == ""){
                            return "Fill Your Filds" ;
                          }
                        },),
                      ),
                      SizedBox(width: 10), // Add spacing between the fields if needed
                      Expanded(
                        child: CustomTextForm(hinttext: "", mycontroller: location,validator: (val){
                          if (val == ""){
                            return "Fill Your Filds" ;
                          }
                        },),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password ",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextForm(hinttext: "Enter your Password", mycontroller: password, obscureText: true, validator: (val){
                    if (val == ""){
                      return "Fill Your Filds" ;
                    }
                  }),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password Confirmation ",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextForm(hinttext: "Confirm your Password", mycontroller: confirmPassword, obscureText: true, validator: (val){
                    if (val == ""){
                      return "Fill Your Filds" ;
                    }
                  }),
                  SizedBox(height: 120),
                  CustombuttonAuth(
                    Title: "Register",
                    onPressed: () async {
                      if (password.text != confirmPassword.text) {
                        print('Confirm password does not match the password.');
                        return; // Stop execution if passwords don't match
                      }

                      try {
                        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );
                        FirebaseAuth.instance.currentUser!.sendEmailVerification();

                        // Add user details to Firestore after successful registration
                        await addUser();

                        Navigator.of(context).pushReplacementNamed("/login");
                      } on FirebaseAuthException catch (e) {
                        // Show an error dialog with the Firebase error details
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: '${e.code}',
                          desc: '${e.message}',
                        ).show();
                      } catch (e) {
                        // Handle any other errors
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Unexpected Error',
                          desc: 'Something went wrong: $e',
                        ).show();
                      }
                    },
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
