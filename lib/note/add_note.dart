import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/components/custom_note_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/components/snack_bar.dart';
import 'package:login/note/note_page.dart';
import 'package:path/path.dart';
import '../components/custom_upload_button.dart';
import '../constants.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key, required this.docId});
  final String docId;
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController noteController = TextEditingController();
  bool isLoading = false;

  File? file;
  String? url ;

  getImage() async {
    final ImagePicker picker = ImagePicker();
// // Pick an image.
// final XFile? imageGallery = await picker.pickImage(source: ImageSource.gallery);
// // Capture a photo.
    final XFile? imageCamera = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 400,
        maxHeight: 200
    );
    if (imageCamera != null) {
      file = File(imageCamera.path);

      var imageName = basename(imageCamera.path);

      var refStorage = FirebaseStorage.instance.ref("images /$imageName");
      await refStorage.putFile(file!);
      url =await refStorage.getDownloadURL();
    }
    setState(() {});
  }



  addNote(context) async {
    CollectionReference note = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docId)
        .collection("note");

    try {
      if (formKey.currentState!.validate()) {
        isLoading = true;
        setState(() {});
        await note.add({
          'note': noteController.text,
          'url': url??"none",
        });

        noteController.clear();
        customSnackBar(context , snackText: 'Note Added');
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => NotePage(categoryId: widget.docId)),
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
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
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
                      CustomUploadButton(title: "Upload image",onPressed: (){
                        getImage();
                      },isSelected: url ==null ?false:true,),
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
                          addNote(context);
                        },
                        child: const Text("Add"),
                      ),

                    ],
                  )),
            ),
    );
  }
}
