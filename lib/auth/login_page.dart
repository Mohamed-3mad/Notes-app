import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/components/login_icon.dart';
import 'package:login/components/snack_bar.dart';
import 'package:login/components/text_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  bool obscureTxt = true;
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pushReplacementNamed(context, "home");
  }

  // Future signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();

  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

  //   // Once signed in, return the UserCredential
  //   FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //   Navigator.pushReplacementNamed(context, "home");
  // }
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/rafiki.png",
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      // color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Login to continue using the app",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormWidget(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Enter your Email";
                      }
                    },
                    obscText: false,
                    controller: email,
                    hintTxt: "Enter your email",
                    icon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormWidget(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Enter your Password";
                      }
                    },
                    obscText: obscureTxt,
                    controller: password,
                    hintTxt: "Enter password",
                    //icon:  IconButton(CupertinoIcons.eye,),
                    icon: IconButton(
                      onPressed: () {
                        obscureTxt = !obscureTxt;
                        setState(() {});
                      },
                      icon: obscureTxt
                          ? const Icon(CupertinoIcons.eye)
                          : const Icon(CupertinoIcons.eye_slash),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      if (email.text == "") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "Please write your email then click on 'Forgot Password?'"),
                          duration: Duration(seconds: 2),
                          backgroundColor: kPrimaryColor,
                        ));
                        return;
                      }
                      try {
                        isLoading = true;
                        setState(() {});
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text);
                        isLoading = false;
                        setState(() {});
                      } catch (e) {
                        customSnackBar(context,
                            snackText: "Please enter correct email");
                        // print("=========================$e");
                      }
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
              MaterialButton(
                color: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                height: 60,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('Processing Data'),
                    //   ),
                    // );
                    try {
                      isLoading = true;
                      setState(() {});
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      isLoading = false;
                      setState(() {});
                      if (credential.user!.emailVerified) {
                        Navigator.pushReplacementNamed(context, "home");
                      } else {
                        customSnackBar(context,
                            snackText: 'Please verify your account');
                      }
                    } on FirebaseAuthException catch (e) {
                      customSnackBar(context,
                          snackText: 'invalid email or password');
                      isLoading = false;
                      setState(() {});
                      if (e.code == 'user-not-found') {
                        customSnackBar(context,
                            snackText: 'No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print("=================errorrrrrrrrrrrrrrrrrrr");
                        customSnackBar(context,
                            snackText:
                                'Wrong password provided for that user.');
                      }
                    }
                  }
                },
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              const SizedBox(height: 20),
              const Text(
                "OR Login with",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LoginIcon(
                      image: "assets/images/facebook_5968764.png",
                      onPressed: () {
                        //signInWithFacebook();
                      }),
                  LoginIcon(
                      image: "assets/images/google_13170545.png",
                      onPressed: () async {
                        signInWithGoogle();
                      }),
                  LoginIcon(
                      image: "assets/images/apple-logo_747.png",
                      onPressed: () {}),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    //textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "register");
                    },
                    child: const Text(
                      "Register",
                      //textAlign: TextAlign.center,

                      style: TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
