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
  GlobalKey<FormState> formState =GlobalKey<FormState>();

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
                        Navigator.of(context).pushReplacementNamed("/login") ;
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }

                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
