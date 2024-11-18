import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fidelyo/Components/TextFormFiled.dart';
import 'package:fidelyo/Register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Components/Button.dart';
import 'Components/logo.dart';
import 'app_colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isRememberMeChecked = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();


GlobalKey<FormState> formState =GlobalKey<FormState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null){
      return ;
    }
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.of(context).pushNamedAndRemoveUntil("/homepage", (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
            Form(
              key: formState,
              child: Column(
              children: [
                CustomLogo(),
                const SizedBox(height: 50),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '  Hi, Welcome Back 👋',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '    Hello again, you’ve been missed!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF999EA1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email ",
                    style: TextStyle(fontSize: 20, color: AppColors.secondary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextForm(hinttext: "Enter Your Email", mycontroller: email ,  validator: (val){
                  if (val == ""){
                    return "Fill Your Filds" ;
                  }
                },),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password ",
                    style: TextStyle(fontSize: 20, color: AppColors.secondary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextForm(hinttext: "Enter Your Password", mycontroller: password , obscureText: true, validator: (val){
                  if (val == ""){
                    return "Fill Your Filds" ;
                  }
                },),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _isRememberMeChecked,
                          onChanged: (value) {
                            setState(() {
                              _isRememberMeChecked = value ?? false;
                            });
                          },
                        ),
                        const Text('Remember Me'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/forgetpassword") ;
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or With',
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        signInWithGoogle();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.grey, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      ),
                      child: const Row(
                        children: [
                          FaIcon(FontAwesomeIcons.google, color: Colors.black),
                          SizedBox(width: 20),
                          Text(
                            'Google',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.grey, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      ),
                      child: const Row(
                        children: [
                          FaIcon(FontAwesomeIcons.facebook, color: Colors.black),
                          SizedBox(width: 20),
                          Text(
                            'Facebook',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('New client? '),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Register()),
                        );
                      },
                      child: const Text(
                        'Register here',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                CustombuttonAuth(Title: "Login", onPressed: () async {
                  if (formState.currentState!.validate()) {
                    try {
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );

                     if (credential.user!.emailVerified){
                       Navigator.of(context).pushReplacementNamed("/homepage");
                     }else {
                       AwesomeDialog(
                         context: context,
                         dialogType: DialogType.error,
                         animType: AnimType.rightSlide,
                         title: 'Verify Your Email',
                         desc: 'Please Verify Your Email',
                       ).show();
                     }
                    } on FirebaseAuthException catch (e) {
                      print('FirebaseAuthException Code: ${e.code}');
                      print('FirebaseAuthException Message: ${e.message}');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: '${e.code}',
                        desc: '${e.message}',
                      ).show();
                    } catch (e) {
                      print('Unexpected error: $e');
                    }
                  }
                    else {
                      print("Not valid ") ;
                  }

                } )
              ],
            ),)
          ),
        ),
      ),
    );
  }
}
