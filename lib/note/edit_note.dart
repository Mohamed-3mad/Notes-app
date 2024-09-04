import 'package:flutter/material.dart';
import 'package:login/components/custom_note_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/components/snack_bar.dart';
import 'package:login/note/note_page.dart';

import '../constants.dart';

class EditNote extends StatefulWidget {
  const EditNote(
      {super.key,
      required this.noteDocId,
      required this.categoryDocId,
      required this.oldName});
  final String noteDocId;
  final String categoryDocId;
  final String oldName;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController noteController = TextEditingController();
  bool isLoading = false;

  editNote() async {
    CollectionReference note = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryDocId)
        .collection("note");

    try {
      if (formKey.currentState!.validate()) {
        isLoading = true;
        setState(() {});
        await note.doc(widget.noteDocId).set({
          'note': noteController.text,
        });

        noteController.clear();
        customSnackBar(context, snackText: 'Note Added');
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => NotePage(categoryId: widget.categoryDocId)),
        );
      }
    } on Exception catch (e) {
      isLoading = false;
      setState(() {});
      customSnackBar(context, snackText: "Failed to add Note: $e");
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
  void initState() {
    noteController.text = widget.oldName;
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
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
                          editNote();
                        },
                        child: const Text("Edit"),
                      )
                    ],
                  )),
            ),
    );
  }
}
