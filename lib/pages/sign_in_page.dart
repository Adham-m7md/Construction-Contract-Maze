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
  final _formKey = GlobalKey<FormState>(); // مفتاح لإدارة حالة النموذج
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> signInMetode() async {
    // تشغيل الفاليديتور يدويًا عند الضغط على الزر
    if (_formKey.currentState!.validate()) {
      // إذا كانت جميع الحقول صحيحة
      setState(() {
        isLoading = true;
      });

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        // التعامل مع أخطاء Firebase Auth
        String errorMessage;
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'البريد الإلكتروني غير صحيح';
            break;
          case 'user-not-found':
            errorMessage = 'البريد الإلكتروني غير مسجل';
            break;
          case 'wrong-password':
            errorMessage = 'كلمة المرور غير صحيحة';
            break;
          case 'user-disabled':
            errorMessage = 'هذا الحساب معطل';
            break;
          case 'invalid-credential':
            errorMessage = 'كلمة المرور غير صحيحة';
            break;
          default:
            errorMessage = 'حدث خطأ أثناء تسجيل الدخول: ${e.message}';
        }
        showSnackBar(context, errorMessage);
      } catch (e) {
        showSnackBar(context, "حدث خطأ غير متوقع: $e");
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  // دالة لعرض Dialog لإعادة تعيين كلمة المرور
  Future<void> _showResetPasswordDialog(BuildContext context) async {
    final _resetEmailController = TextEditingController();

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
                controller: _resetEmailController,
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
                Navigator.of(context).pop(); // إغلاق الـ Dialog
              },
              child: const Text('cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_resetEmailController.text.isNotEmpty) {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: _resetEmailController.text.trim(),
                    );
                    showSnackBar(context,
                        'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني');
                    Navigator.of(context).pop(); // إغلاق الـ Dialog
                  } on FirebaseAuthException catch (e) {
                    showSnackBar(context, "حدث خطأ: ${e.message}");
                  } catch (e) {
                    showSnackBar(context, "حدث خطأ غير متوقع: $e");
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
          key: _formKey, // ربط النموذج بالمفتاح
          autovalidateMode: AutovalidateMode.disabled, // تعطيل التحقق التلقائي
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: context.screenHeight * 0.08),
                Image.asset(
                  kLogo,
                  height: context.screenHeight * 0.45,
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
                      return 'البريد الإلكتروني مطلوب';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'البريد الإلكتروني غير صحيح';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.screenHeight * 0.014),
                TextFormFeild(
                  controller: _passwordController,
                  obscureText: true,
                  hintText: 'Password',
                  onChanged: (data) {
                    setState(() {
                      _passwordController.text = data;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'كلمة المرور مطلوبة';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showResetPasswordDialog(context); // عرض Dialog
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
                    ? const CircularProgressIndicator() // عرض مؤشر التحميل
                    : Button(
                        onTap: signInMetode,
                        buttonText: 'Sign In',
                      ),
                SizedBox(height: context.screenHeight * 0.012),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        fontSize: 18,
                        color: kBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red, // لون الخلفية للرسالة
      ),
    );
  }
}
