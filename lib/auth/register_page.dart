import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/components/snack_bar.dart';
import 'package:login/components/text_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController coPassword = TextEditingController();
  bool obscureTxt = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    username.dispose();
    coPassword.dispose();
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
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      // color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Sign Up to continue using the app",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "username",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      //color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormWidget(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Enter your username";
                      }
                    },
                    obscText: false,
                    controller: username,
                    hintTxt: "Enter your username",
                    icon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      //color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormWidget(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Enter your email";
                      }
                    },
                    obscText: false,
                    controller: email,
                    hintTxt: "Enter your email",
                    icon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.email_outlined),
                    ),
                    //const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      //color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormWidget(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Enter your Password";
                      }
                    },
                    obscText: true,
                    controller: password,
                    hintTxt: "Enter password",
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
                  const SizedBox(height: 30),
                  const Text(
                    "Confirm password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      //color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormWidget(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please confirm your password";
                      }
                    },
                    obscText: obscureTxt,
                    controller: coPassword,
                    hintTxt: "Enter confirm password",
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
                    //   const SnackBar(content: Text('Processing Data')),
                    // );
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      Navigator.pushReplacementNamed(context, "login");
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        customSnackBar(context,
                            snackText: 'The password provided is too weak.');

                        //print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        customSnackBar(context,
                            snackText:
                                'The account already exists for that email.');
                      }
                    } catch (e) {
                      customSnackBar(context, snackText: '$e');
                    }
                  }
                },
                child: const Text(
                  "SignUp",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Have an account? ",
                    //textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "login");
                    },
                    child: const Text(
                      "Login",
                      //textAlign: TextAlign.center,

                      style: TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
