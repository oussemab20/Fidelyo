import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Components/Button.dart';
import 'Components/TextFormFiled.dart';
import 'Components/logo.dart';
import 'app_colors.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> formState =GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formState,
            child: Column(
              children: [
                CustomLogo(),
                const SizedBox(height: 110),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      ' Forget Password?',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Don’t worry! It happens. Please enter the email associated with your account.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF999EA1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email Address",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                CustomTextForm(
                  hinttext: "Enter Your Email",
                  mycontroller: email,
                  validator: (val) {
                    if (val == "") {
                      return "Fill Your Fields";
                    }
                  },
                ),
                const SizedBox(height: 30),
                CustombuttonAuth(
                  Title: "Send",
                  onPressed: () async {
                    if (email.text.isEmpty) {
                      // Show error dialog if the email field is empty
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Fill Fields',
                        desc: 'Please enter your email',
                      ).show();
                      return; // Stop further execution if the field is empty
                    }

                    try {
                      // Attempt to send password reset email
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Email Sent',
                        desc: 'An email has been sent to your email address',
                      ).show();
                    } catch (e) {
                      // Show error dialog if an exception occurs
                      print(e);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'User not found',
                        desc: 'Verify your email address',
                      ).show();
                    }
                  },
                ),

                const Spacer(), // Pushes the content above, keeping the row at the bottom
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Remember password?'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/login");
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Add a small bottom margin
              ],
            ),
          ),
        ),
      ),
    );
  }
}
