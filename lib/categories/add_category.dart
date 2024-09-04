import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/custom_note_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/components/snack_bar.dart';

import '../constants.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController noteController = TextEditingController();
  bool isLoading = false;

  addCategory() async {
    CollectionReference categories =
        FirebaseFirestore.instance.collection('categories');
    try {
      if (formKey.currentState!.validate()) {
        isLoading = true;
        setState(() {});
        await categories.add({
          'name': noteController.text,
          'id': FirebaseAuth.instance.currentUser!.uid
        });

        noteController.clear();
        customSnackBar(context, snackText: 'Category Added');
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      }
    } on Exception catch (e) {
      isLoading = false;
      setState(() {});
      customSnackBar(context, snackText: "Failed to add category: $e");
    }
  }

  // Future<void> addCategory() {
  //   // Call the user's CollectionReference to add a new use
  //   return categories
  //       .add({'name': noteController.text})
  //       .then((value) => print("Category Added"))
  //       .catchError((error) => print("Failed to add category: $error"));
  // }
  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomNoteForm(
                        hintTxt: "Write your note",
                        controller: noteController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Can't be empty";
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        height: 50,
                        minWidth: 100,
                        color: kPrimaryColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onPressed: () {
                          addCategory();
                        },
                        child: const Text("Add"),
                      )
                    ],
                  )),
            ),
    );
  }
}
