import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/auth/register_page.dart';
import 'package:login/categories/add_category.dart';
import 'package:login/categories/category_page.dart';
import 'package:login/note/filter.dart';
import 'package:login/notification.dart';
import 'auth/login_page.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('================================User is currently signed out!');
      } else {
        print('================================User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color.fromRGBO(86, 80, 14, 171),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 5,
          iconTheme: IconThemeData(
            color: kPrimaryColor,
          ),
          titleTextStyle: TextStyle(
            color: kPrimaryColor,
            fontSize: 24,
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      // theme: ThemeData(
      //   appBarTheme: const AppBarTheme(
      //     //backgroundColor: Colors.black,
      //     backgroundColor: Colors.white,
      //     elevation: 10,
      //     iconTheme: IconThemeData(
      //       color: kPrimaryColor,
      //     ),
      //     titleTextStyle: TextStyle(
      //       color: kPrimaryColor,
      //       fontSize: 24,
      //     ),
      //   ),
      // ),
      routes: {
        "register": (context) => const RegisterPage(),
        "login": (context) => const LoginPage(),
        "home": (context) => const CategoryPage(),
        "addcategory": (context) => const AddCategory(),
        "filterfirestore": (context) => const FilterFireStore(),
      },
      debugShowCheckedModeBanner: false,
      home:const LoginPage(),

       // (FirebaseAuth.instance.currentUser != null &&
       //        FirebaseAuth.instance.currentUser!.emailVerified)
       //    ? const CategoryPage()
       //    : const LoginPage(),
    );
  }
}
