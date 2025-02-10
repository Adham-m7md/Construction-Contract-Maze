import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maze/pages/home_page.dart';
import 'package:maze/pages/sign_in_page.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});
  static String id = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const SignIn();
          }
        }),
      ),
    );
  }
}
