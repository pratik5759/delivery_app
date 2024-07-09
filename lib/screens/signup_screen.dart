import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/user_signup_model.dart';
import 'package:delivery_app/screens/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/screens/custom_widgets/textformfeild.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();


  FirebaseFirestore fStore = FirebaseFirestore.instance;
  var userSignupCollection = FirebaseFirestore.instance.collection('user');

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool obscureValue = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// sign up big text
            const Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: 33, fontWeight: FontWeight.w900, letterSpacing: 2),
            ),

            /// add you details for sign up
            const Text(
              "Add your details for sign up",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFB9B9B9),
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),

            Form(
                key: signupFormKey,
                // this form has error
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [


                    /// name textfeild
                    CustomValidationFeild(
                      controller: nameController,
                      hintText: 'Name',
                      validator: (text) {
                        if (text!.isEmpty && text.length < 3) {
                          return 'please enter your name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    /// email textfeild
                    CustomValidationFeild(
                      controller: emailController,
                      hintText: 'Email',
                      validator: validateEmail,
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    ///Mob no textfeild
                    CustomValidationFeild(
                      controller: mobNoController,
                      hintText: 'Mob No',
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    /// address textfeild
                    CustomValidationFeild(
                      controller: addressController,
                      hintText: 'Address',
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    /// password textfeild
                    CustomValidationFeild(
                      controller: passwordController,
                      hintText: 'Password',
                      icon: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              obscureValue = !obscureValue;
                            });
                          },
                          child: const Icon(Icons.remove_red_eye)),
                      isObscure: obscureValue,
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    /// confirm password textfeild
                    CustomValidationFeild(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password'),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )),

            /// sign up button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: InkWell(
                onTap: () {
                  if (nameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty &&
                      mobNoController.text.isNotEmpty &&
                      addressController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty &&
                      confirmPasswordController.text.isNotEmpty) {
                    UserSignupModel newUser = UserSignupModel(
                        name: nameController.text,
                        email: emailController.text,
                        mobNo: mobNoController.text,
                        address: addressController.text,
                        password: confirmPasswordController.text);

                    userSignupCollection.doc().set(newUser.toMap()).then((v) {
                      print("data added successfully");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    });
                  }
                },
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                      color: const Color(0xFFFC6111),
                      borderRadius: BorderRadius.circular(45)),
                  child: const Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),

            /// already have an account ? Login
            RichText(
                text: TextSpan(children: [
                  const TextSpan(
                    text: "Already have an Account ? ",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFB9B9B9),
                        fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                      text: "Login",
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFBF6435),
                          fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        }),
                ]))
          ],
        ),
      ),
    );
  }


}

String? validateEmail(String? email) {
  var regX = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  if (!regX.hasMatch(email!)) {
    return 'Please enter a valid Email';
  } else {
    return null;
  }
}
