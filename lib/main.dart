import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maze/pages/home_page.dart';
import 'package:maze/pages/auth.dart';
import 'package:maze/pages/info_page.dart';
import 'package:maze/pages/sign_in_page.dart';
import 'package:maze/pages/sign_up_page.dart';
import 'package:maze/pages/videos_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MazeApp());
}

class MazeApp extends StatelessWidget {
  const MazeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        Auth.id: (context) => const Auth(),
        SignUp.id: (context) => const SignUp(),
        SignIn.id: (context) => const SignIn(),
        HomePage.id: (context) => const HomePage(),
        VideosPage.id: (context) => const VideosPage(),
        InfoPage.id: (context) => const InfoPage(),
      },
    );
  }
}
