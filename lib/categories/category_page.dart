import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:login/categories/edit_page.dart';
import 'package:login/components/snack_bar.dart';
import 'package:login/note/note_page.dart';
import '../constants.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List data = [];
  bool isLoading = true;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
            Navigator.pushNamed(context, "addcategory");
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: const Text("Category Page"),
          actions: [
            IconButton(
                onPressed: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.disconnect();
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, "login");
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : data.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/folder_6861999.png",
                            height: 100),
                        const SizedBox(height: 20),
                        const Text(
                          "Create your first Category!",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: GridView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NotePage(categoryId: data[index].id)));
                          },
                          onLongPress: () => AwesomeDialog(
                            context: context,
                            btnCancelText: "Delete",
                            btnOkText: "Edit",
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            title: '${data[index]['name']}',
                            desc: "Delete or Edit?",
                            descTextStyle: const TextStyle(fontSize: 18),
                            btnCancelOnPress: () async {
                              await FirebaseFirestore.instance
                                  .collection('categories')
                                  .doc(data[index].id)
                                  .delete();
                              Navigator.pushReplacementNamed(context, "home");
                              customSnackBar(context,
                                  snackText:
                                      "'${data[index]['name']}' Category deleted");
                            },
                            btnOkOnPress: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditCategory(
                                          docId: data[index].id,
                                          oldName: data[index]['name'])));
                            },
                          )..show(),
                          child: Card(
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/folder_6994677.png",
                                    height: 80,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "${data[index]['name']}",
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
                              mainAxisSpacing: 10,
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
                  ));
  }
}
