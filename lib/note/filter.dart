import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/constants.dart';

class FilterFireStore extends StatefulWidget {
  const FilterFireStore({super.key});

  @override
  State<FilterFireStore> createState() => _FilterFireStoreState();
}

class _FilterFireStoreState extends State<FilterFireStore> {
  List<QueryDocumentSnapshot> data = [];

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  // initData() async {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   QuerySnapshot usersData = await users.get();
  //   usersData.docs.forEach(
  //     (element) {
  //       data.add(element);
  //     },
  //   );
  //   setState(() {});
  // }

  @override
  void initState() {
    //initData();
    super.initState();
  }

  bool isLoading = false;

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
            CollectionReference users =
                FirebaseFirestore.instance.collection('users');
            DocumentReference doc1 =
                FirebaseFirestore.instance.collection('users').doc("1");
            DocumentReference doc2 =
                FirebaseFirestore.instance.collection('users').doc("2");
            DocumentReference doc3 =
                FirebaseFirestore.instance.collection('users').doc("3");
            WriteBatch batch = FirebaseFirestore.instance.batch();
            batch.set(doc1, {
              "username": "MOHAMED",
              'money': 200,
              "age": 21,
              "phone": '111111111',
            });
            batch.set(doc2, {
              "username": "EMAD",
              'money': 300,
              "age": 52,
              "phone": '111111111',
            });
            batch.set(doc3, {
              "username": "EMMMAD",
              'money': 300,
              "age": 52,
              "phone": '111111111',
            });
            batch.commit().then((value) {
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Navigator.pushNamedAndRemoveUntil(
                      context, 'filterfirestore', (route) => false);
            });
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: const Text("Filter"),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder(
              //Real-Time Change
              stream: _usersStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
//Create a reference to the document the transaction will use
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(snapshot.data!.docs[index].id);

                          FirebaseFirestore.instance
                              .runTransaction((transaction) async {
                            isLoading = true;
                            setState(() {});
                            // Get the document
                            DocumentSnapshot snapshot =
                                await transaction.get(documentReference);
                            isLoading = false;
                            setState(() {});
                            if (snapshot.exists) {
                              var snapshotData = snapshot.data();
                              if (snapshotData is Map<String, dynamic>) {
                                int money = snapshotData['money'] + 100;
                                transaction.update(documentReference, {
                                  'money': money,
                                });
                              }
                            }
                          });
                          // .then((value) {
                          //   isLoading
                          //       ? const Center(
                          //           child: CircularProgressIndicator())
                          //       : Navigator.pushNamedAndRemoveUntil(context,
                          //           'filterfirestore', (route) => false);
                          // }).catchError((error) =>
                          //     print("Failed to update user followers: $error"));
                        },
                        child: Card(
                          child: ListTile(
                            trailing: Text(
                                "${snapshot.data!.docs[index]["money"]} \$",
                                style: const TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            titleTextStyle: const TextStyle(fontSize: 26),
                            title: Text(snapshot.data!.docs[index]["username"]),
                            subtitle: Text(
                                "age:  ${snapshot.data!.docs[index]['age']}"),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
        ));
  }
}
