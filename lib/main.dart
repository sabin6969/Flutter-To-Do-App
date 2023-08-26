import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/add_titles_page.dart';
import 'package:todoapp/home_page.dart';
import 'package:todoapp/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: "/splashscreen",
      routes: {
        "/homepage": (context) => const MyHomePage(),
        "/splashscreen": (context) => const SplashScreen(),
        "/addtask": (context) => const AddTask(),
      },
    );
  }
}
