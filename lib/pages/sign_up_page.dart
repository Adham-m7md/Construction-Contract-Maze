import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maze/helper/widgets/CustomButton.dart';
import 'package:maze/helper/widgets/CustomTextFeild.dart';
import 'package:maze/helper/widgets/constants.dart';
import 'package:maze/pages/auth.dart';
import 'package:maze/pages/sign_in_page.dart';
import 'package:maze/utils/app_directions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  static String id = 'Signup';

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>(); // مفتاح لإدارة حالة النموذج
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool isLoading = false;

  // دالة للتحقق من صحة رقم الهاتف
  bool isValidPhoneNumber(String phone) {
    // Regex للتحقق من أن الرقم يتكون من 11 رقمًا ويبدأ بـ 01
    final regex = RegExp(r'^01[0-9]{9}$');
    return regex.hasMatch(phone);
  }

  // دالة للتحقق من صحة كلمة المرور
  bool isValidPassword(String password) {
    // التحقق من أن كلمة المرور تحتوي على 6 أحرف/أرقام على الأقل
    return password.length >= 6;
  }

  Future<void> signUpMetode() async {
    // تشغيل الفاليديتور يدويًا عند الضغط على الزر
    if (_formKey.currentState!.validate()) {
      // إذا كانت جميع الحقول صحيحة
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
          'created_at': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          Navigator.of(context).pushNamed(Auth.id);
        }
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, "حدث خطأ أثناء التسجيل: ${e.message}");
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
          autovalidateMode: AutovalidateMode.disabled, // تعطيل التحقق التلقائي
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: context.screenHeight * 0.08),
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
                SizedBox(height: context.screenHeight * 0.02),
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
                SizedBox(height: context.screenHeight * 0.02),
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
                      return 'البريد الإلكتروني غير صحيح';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.screenHeight * 0.014),
                TextFormFeild(
                  obscureText: true,
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
                ),
                SizedBox(height: context.screenHeight * 0.02),
                isLoading
                    ? const CircularProgressIndicator() // عرض مؤشر التحميل
                    : Button(
                        onTap: signUpMetode,
                        buttonText: 'Sign Up',
                      ),
                SizedBox(height: context.screenHeight * 0.014),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 18,
                        color: kBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, SignIn.id);
                      },
                      child: const Text(
                        'SIGN IN',
                        style: TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.screenHeight * 0.06),
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
