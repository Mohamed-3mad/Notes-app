import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:login/note/add_note.dart';
import 'package:login/note/edit_note.dart';
import '../components/snack_bar.dart';
import '../constants.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List data = [];
  bool isLoading = true;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection("note")
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(
            side: BorderSide(
              style: BorderStyle.solid,
              color: kPrimaryColor,
            ),
          ),
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddNote(docId: widget.categoryId)));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: const Text("Note Page"),
          // actions: [
          //   IconButton(
          //       onPressed: () async {
          //         GoogleSignIn googleSignIn = GoogleSignIn();
          //         googleSignIn.disconnect();
          //         await FirebaseAuth.instance.signOut();
          //         Navigator.pushReplacementNamed(context, "login");
          //       },
          //       icon: const Icon(Icons.exit_to_app))
          // ],
        ),
        body: data.isEmpty
            ? PopScope(
                canPop: false,
                onPopInvoked: (didPop) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'home',
                    (route) => false,
                  );
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/rafiki.png", height: 100),
                      const SizedBox(height: 20),
                      const Text(
                        "Write your first Note!",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              )
            : PopScope(
                canPop: false,
                onPopInvoked: (didPop) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'home',
                    (route) => false,
                  );
                },
                child: isLoading == true
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: GridView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onLongPress: () => AwesomeDialog(
                                context: context,
                                btnCancelText: "Delete",
                                btnOkText: "Edit",
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: '${data[index]['note']}',
                                desc: "Delete or Edit?",
                                descTextStyle: const TextStyle(fontSize: 18),
                                btnCancelOnPress: () async {
                                  await FirebaseFirestore.instance
                                      .collection('categories')
                                      .doc(widget.categoryId)
                                      .collection("note")
                                      .doc(data[index].id)
                                      .delete();
                                  if(data[index]['url']!="none"){
                                    FirebaseStorage.instance.refFromURL(data[index]['url']).delete();
                                  }
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NotePage(
                                              categoryId: widget.categoryId)));
                                  customSnackBar(context,
                                      snackText:
                                          "'${data[index]['note']}' Note deleted");
                                },
                                btnOkOnPress: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditNote(
                                              categoryDocId: widget.categoryId,
                                              noteDocId: data[index].id,
                                              oldName: data[index]['note'])));
                                },
                              )..show(),
                              child: Card(
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      if(data[index]['url'] !="none") ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.network(data[index]['url'],height: 100)),
const SizedBox(height: 10,),
                                      Text(
                                        "${data[index]['note']}",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20),

                          // Card(
                          //   child: Container(
                          //     padding: const EdgeInsets.all(20),
                          //     child: Column(
                          //       children: [
                          //         Image.asset(
                          //           "assets/images/folder_17083745.png",
                          //           height: 100,
                          //         ),
                          //         const Text("Home"),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ),
                      ),
              ));
  }
}
