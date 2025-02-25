import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maze/core/helper/show_snack_bar.dart';
import 'package:maze/core/widgets/CustomButton.dart';
import 'package:maze/core/widgets/CustomTextFeild.dart';
import 'package:maze/core/widgets/constants.dart';
import 'package:maze/presentation/Auth/widgets/dont_have_an_account_widget.dart';
import 'package:maze/presentation/home/pages/home_page.dart';
import 'package:maze/presentation/home/pages/qestions_page.dart';
import 'package:maze/core/utils/app_directions.dart';

class SignIn extends StatefulWidget {
  static String id = 'Signin';

  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted && FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context).pushReplacementNamed(QuestionsPages.id);
      }
    });
  }

  Future<void> signInMetode() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          Navigator.of(context).pushReplacementNamed(HomePage.id);
        }
      } on FirebaseAuthException catch (e) {
        final errorMessage = _handleFirebaseError(e);
        if (mounted) showSnackBar(context, errorMessage);
      } catch (e) {
        if (mounted) showSnackBar(context, "An unexpected error occurred: $e");
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "Invalid email format. Please check your email.";
      case 'user-not-found':
        return "No account found with this email. Please sign up.";
      case 'wrong-password':
        return "Incorrect password. Please check your password and try again.";
      case 'user-disabled':
        return "This account has been disabled. Contact support.";
      case 'invalid-credential':
        return "the email or password is incorrect, check and try again.";
      case 'account-exists-with-different-credential':
        return "An account already exists with this email but different sign-in method.";
      case 'email-already-in-use':
        return "This email is already in use by another account.";
      default:
        return "Sign-in failed: ${e.message}";
    }
  }

  Future<void> _showResetPasswordDialog(BuildContext context) async {
    final resetEmailController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                color: Colors.redAccent,
                size: 72,
              ),
              SizedBox(height: context.screenHeight * 0.02),
              const Text('Reset Password'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: resetEmailController,
                decoration: const InputDecoration(
                  hintText: 'Enter Your Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'البريد الإلكتروني مطلوب';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'البريد الإلكتروني غير صحيح';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (resetEmailController.text.isNotEmpty) {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: resetEmailController.text.trim(),
                    );
                    if (mounted) {
                      showSnackBar(context,
                          'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني');
                      Navigator.of(context).pop();
                    }
                  } on FirebaseAuthException catch (e) {
                    if (mounted) {
                      showSnackBar(context, "حدث خطأ: ${e.message}");
                    }
                  } catch (e) {
                    if (mounted) {
                      showSnackBar(context, "حدث خطأ غير متوقع: $e");
                    }
                  }
                } else {
                  showSnackBar(context, 'الرجاء إدخال بريد إلكتروني صحيح');
                }
              },
              child: const Text('send'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                SizedBox(height: context.screenHeight * 0.08),
                Image.asset(
                  kLogo,
                  height: context.screenHeight * 0.4,
                ),
                SizedBox(height: context.screenHeight * 0.02),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 8),
                    Text(
                      'Sign In',
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
                  controller: _emailController,
                  hintText: 'Email',
                  onChanged: (data) {
                    setState(() {
                      _emailController.text = data;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'ex: exampel@gmail.com';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'ex: exampel@gmail.com';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.screenHeight * 0.014),
                TextFormFeild(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  hintText: 'Password',
                  onChanged: (data) {
                    setState(() {
                      _passwordController.text = data;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
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
                  ),
                ),
                SizedBox(height: context.screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showResetPasswordDialog(context);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: context.screenHeight * 0.02),
                isLoading
                    ? const CircularProgressIndicator()
                    : Button(
                        onTap: signInMetode,
                        buttonText: 'Sign In',
                      ),
                SizedBox(height: context.screenHeight * 0.012),
                const DontHaveAnAccountWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
