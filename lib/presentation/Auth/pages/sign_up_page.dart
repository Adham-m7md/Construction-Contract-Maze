import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maze/core/helper/show_snack_bar.dart';
import 'package:maze/core/widgets/CustomButton.dart';
import 'package:maze/core/widgets/CustomTextFeild.dart';
import 'package:maze/core/widgets/constants.dart';
import 'package:maze/core/widgets/drop_down_button_form_feild.dart';
import 'package:maze/presentation/Auth/pages/auth.dart';
import 'package:maze/core/utils/app_directions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maze/presentation/Auth/widgets/have_an_account_widget.dart';

class SignUp extends StatefulWidget {
  static String id = 'Signup';

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? selectedJobTitle;
  bool _obscureText = true;
  bool isLoading = false;

  bool isValidPhoneNumber(String phone) {
    final regex = RegExp(r'^01[0-9]{9}$');
    return regex.hasMatch(phone);
  }

  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  Future<void> signUpMetode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'job_title': selectedJobTitle,
          'created_at': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          Navigator.of(context).pushNamed(Auth.id);
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = "The email address is already in use.";
            break;
          case 'invalid-email':
            errorMessage = "The email address is invalid.";
            break;
          case 'operation-not-allowed':
            errorMessage = "Email/password accounts are not enabled.";
            break;
          case 'weak-password':
            errorMessage =
                "The password is too weak. Please choose a stronger password.";
            break;
          default:
            errorMessage = "An error occurred during sign-up: ${e.message}";
        }
        showSnackBar(context, errorMessage);
      } catch (e) {
        showSnackBar(context, "An unexpected error occurred: $e");
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: context.screenHeight * 0.07),
                Image.asset(
                  kLogo,
                  height: context.screenHeight * 0.3,
                ),
                SizedBox(height: context.screenHeight * 0.02),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 8),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.screenHeight * 0.014),
                TextFormFeild(
                  hintText: 'Name',
                  onChanged: (data) {
                    setState(() {
                      _nameController.text = data;
                    });
                  },
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.screenHeight * 0.01),
                DropDownButtonFormFeild(
                    selectedJobTitle: selectedJobTitle,
                    onChanged: (newValue) {
                      setState(() {
                        selectedJobTitle = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a job title';
                      }
                      return null;
                    }),
                SizedBox(height: context.screenHeight * 0.01),
                TextFormFeild(
                  hintText: 'Phone',
                  onChanged: (data) {
                    setState(() {
                      _phoneController.text = data;
                    });
                  },
                  controller: _phoneController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter your phone number';
                    }
                    if (!isValidPhoneNumber(value)) {
                      return 'ex: 01234567890';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.screenHeight * 0.01),
                TextFormFeild(
                  hintText: 'Email',
                  onChanged: (data) {
                    setState(() {
                      _emailController.text = data;
                    });
                  },
                  controller: _emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'ex: youremail@gmail.com';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.screenHeight * 0.01),
                TextFormFeild(
                    obscureText: _obscureText,
                    hintText: 'Password',
                    onChanged: (data) {
                      setState(() {
                        _passwordController.text = data;
                      });
                    },
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'password is required';
                      }
                      if (!isValidPassword(value)) {
                        return 'not less than 6 letters';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )),
                SizedBox(height: context.screenHeight * 0.02),
                isLoading
                    ? const CircularProgressIndicator()
                    : Button(
                        onTap: signUpMetode,
                        buttonText: 'Sign Up',
                      ),
                SizedBox(height: context.screenHeight * 0.014),
                const HaveAnAccountWidget(),
                SizedBox(height: context.screenHeight * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
