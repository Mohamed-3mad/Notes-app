import 'package:flutter/material.dart';
import 'package:login/components/custom_note_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/components/snack_bar.dart';

import '../constants.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({super.key, required this.docId, required this.oldName});
  final String docId;
  final String oldName;

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController noteController = TextEditingController();
  bool isLoading = false;

  editCategory() async {
    CollectionReference categories =
        FirebaseFirestore.instance.collection('categories');
    try {
      if (formKey.currentState!.validate()) {
        isLoading = true;
        setState(() {});
        await categories
            .doc(widget.docId)
            .set({'name': noteController.text}, SetOptions(merge: true));

        noteController.clear();
        customSnackBar(context, snackText: 'Category Edited');
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      }
    } on Exception catch (e) {
      isLoading = false;
      setState(() {});
      customSnackBar(context, snackText: "Failed to edit category: $e");
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
  void initState() {
    noteController.text = widget.oldName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Category"),
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
                          editCategory();
                        },
                        child: const Text("Edit"),
                      )
                    ],
                  )),
            ),
    );
  }
}
