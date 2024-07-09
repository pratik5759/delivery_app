import 'package:delivery_app/screens/custom_widgets/custom_textfeild.dart';
import 'package:delivery_app/screens/otp_verification_screen.dart';
import 'package:delivery_app/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String? otpVerificationId;

  FirebaseAuth fAuth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  final telephony = Telephony.instance;

  void reqSmsPermission() async{
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reqSmsPermission();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// sign up big text
            Text("Log In",style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.w900,
                letterSpacing: 2
            ),),

            /// add you details for sign up
            Text("Add your details for Log In",style: TextStyle(
                fontSize: 16,
                color: Color(0xFFB9B9B9),
                fontWeight: FontWeight.w500
            ),),
            SizedBox(height: 20,),

            ///your email
            CustomValidationFeild(controller: emailController, hintText: 'Your Email'),
            SizedBox(height: 20,),

            ///password
            CustomValidationFeild(controller: passController, hintText: 'Password'),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0,right: 5),
                    child: Divider(thickness: 0.8,),
                  ),
                ),
                Text('OR'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5,right: 25),
                    child: Divider(thickness: 0.8,),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),

            ///phone no
            CustomValidationFeild(controller: phoneController, hintText: 'Phone No'),
            SizedBox(height: 20,),

            ///log in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: InkWell(
                onTap: (){
                  if(phoneController.text.isNotEmpty){
                    fAuth.verifyPhoneNumber(
                      phoneNumber: '+91${phoneController.text}',
                      verificationCompleted: (phoneAuthCredential) {

                      }, verificationFailed: (error) {

                    }, codeSent: (verificationId, forceResendingToken) {
                      otpVerificationId = verificationId;
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpVerificationScreen(mobNo: '+91${phoneController.text}', verificationId: otpVerificationId!)));

                        }, codeAutoRetrievalTimeout: (verificationId) {

                      otpVerificationId = verificationId;
                    },
                    );
                  }
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpVerificationScreen(mobNo: '1234567890')));
                },
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                      color: Color(0xFFFC6111),
                      borderRadius: BorderRadius.circular(45)
                  ),
                  child: Center(child: Text(
                    'Log In',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                    ),
                  ),),
                ),
              ),
            ),
            SizedBox(height: 15,),

            /// Forgot your password ?
            RichText(text: TextSpan(children: [
              TextSpan(
                text: "Forgot your password ?",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFB9B9B9),
                    fontWeight: FontWeight.w500
                ),
                  recognizer: TapGestureRecognizer()..onTap = (){
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                    print("forgot password tapped");
                  }
              ),

            ])),
            SizedBox(
              height: 20,
            ),


            ///dont have an account sign up
            RichText(text: TextSpan(children: [
              TextSpan(
                text: "Don't have an Account ? ",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFB9B9B9),
                    fontWeight: FontWeight.w500
                ),
              ),
              TextSpan(
                  text: "Sign Up",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFBF6435),
                      fontWeight: FontWeight.w500
                  ),
                  recognizer: TapGestureRecognizer()..onTap = (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                  }
              ),


            ]))

          ],
        ),
      ),
    );
  }
}
