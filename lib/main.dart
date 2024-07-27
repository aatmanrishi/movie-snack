import 'package:firebase_core/firebase_core.dart';
import './screens/MovieListScreen.dart';
import '../screens/Signup.dart';
import 'package:flutter/material.dart';


// void main() async {
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Snack',
      home: const SignupScreen(),
    );
  }
}