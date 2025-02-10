import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maze/helper/widgets/CustomButton.dart';
import 'package:maze/helper/widgets/CustomTextFeild.dart';
import 'package:maze/helper/widgets/constants.dart';
import 'package:maze/utils/app_directions.dart';
import 'package:maze/pages/sign_up_page.dart';

class SignIn extends StatefulWidget {
  static String id = 'Signin';

  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _emailConntroller = TextEditingController();

  final _passwordConntroller = TextEditingController();

  Future SignInMetode() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailConntroller.text.trim(),
      password: _passwordConntroller.text.trim(),
    );
  }

  void dispose() {
    super.dispose();
    _emailConntroller.dispose();
    _passwordConntroller.dispose();
  }

  String? email;

  String? password;

  bool isLooding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 153, 183, 246),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: context.screenHeight * 0.08,
              ),
              Container(
                height: context.screenHeight * 0.4,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(kLogo), fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                height: context.screenHeight * 0.02,
              ),
              Padding(
                padding: EdgeInsets.only(right: context.screenWidth * 0.5),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: context.screenHeight * 0.014,
              ),
              TextFormFeild(
                controller: _emailConntroller,
                hintText: 'Email',
                onChanged: (data) {
                  email = data;
                },
              ),
              SizedBox(
                height: context.screenHeight * 0.014,
              ),
              TextFormFeild(
                controller: _passwordConntroller,
                obscureText: true,
                hintText: 'password',
                onChanged: (data) {
                  password = data;
                },
              ),
              SizedBox(
                height: context.screenHeight * 0.02,
              ),
              Button(
                onTap: SignInMetode,
                buttonText: 'Sign In',
              ),
              SizedBox(
                height: context.screenHeight * 0.012,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'don\'t have an account  ',
                    style: TextStyle(
                        fontSize: 18,
                        color: kBlackColor,
                        fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, SignUp.id);
                    },
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String massege) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(massege)));
  }
}
