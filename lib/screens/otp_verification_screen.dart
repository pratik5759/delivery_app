import 'package:delivery_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:telephony/telephony.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobNo;
  String verificationId;

  OtpVerificationScreen({required this.mobNo, required this.verificationId});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final telephony = Telephony.instance;
  FocusNode focusNode = FocusNode();
  TextEditingController otpController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenOTP();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 0.04 * screenHeight,
              ),

              ///Enter Registration code
              Center(
                  child: Text(
                "Enter Your OTP",
                style: TextStyle(
                    fontSize: 0.1 * screenWidth, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 0.04 * screenHeight,
              ),

              Pinput(
                controller: otpController,
                focusNode: focusNode,
                length: 6,
              ),
              SizedBox(
                height: 0.04 * screenHeight,
              ),

              ///we have sent verification code to you mob no
              CustomText(
                text: "We have sent verification code to you Mobile No",
                isMobNo: false,
              ),

              ///user mob no
              CustomText(
                text: widget.mobNo,
                isMobNo: true,
              ),

              /*///you can check your inbox
              CustomText(text: "You can check you inbox",isMobNo: false,),*/
              SizedBox(
                height: 0.03 * screenHeight,
              ),

              ///i did not receive code
              CustomText(
                text: "I did not recive code ? Send again",
                isMobNo: false,
              ),
              SizedBox(
                height: 0.07 * screenHeight,
              ),

              ///verify button
              InkWell(
                onTap: () async {
                  try {
                    PhoneAuthCredential credential;
                    credential = await PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: otpController.text);
                    final userCred =
                        await firebaseAuth.signInWithCredential(credential);
                    if (userCred.user != null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }
                    print(credential.toString());
                  } catch (err) {
                    print('error : $err');
                  }
                },
                child: Container(
                  height: 0.05 * screenHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xFFFC6111),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Text(
                    "Verify ",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void listenOTP() {
    print("LISTENING TO OTP ");
    telephony.listenIncomingSms(
      listenInBackground: false,
      onNewMessage: (message) {
        if (message.body!.contains('delivery-app-dc02c')) {
          String OTP = message.body!.substring(0, 6);

          print(OTP);

          setState(() {
            otpController.text = OTP;
          });
        }
      },
    );
  }
}

class CustomText extends StatelessWidget {
  bool isMobNo = false;

  CustomText({super.key, required this.text, required this.isMobNo});

  String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isMobNo ? Colors.green : Colors.black),
    );
  }
}

class OtpBox extends StatelessWidget {
  TextEditingController controller;

  OtpBox(
      {required this.controller,
      this.nextNode,
      required this.currentNode,
      this.prevNode});

  final FocusNode? nextNode;
  final FocusNode currentNode;
  final FocusNode? prevNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
      width: 55,
      height: 60,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (text) {
          if (text.length == 1) {
            //FocusScope.of(context).requestFocus(nextNode);
            nextNode?.nextFocus();
            //prevNode?.unfocus();
          } else if (text.isEmpty && prevNode != null) {
            //FocusScope.of(context).requestFocus(prevNode);
            prevNode?.previousFocus();
          } else if (text.isEmpty) {
            //FocusScope.of(context).requestFocus(prevNode);
            prevNode?.previousFocus();
          }
          // if (currentNode.hasPrimaryFocus) {
          //   prevNode?.unfocus();
          //   nextNode?.unfocus();
          // }
        },
        focusNode: currentNode,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.all(8),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFC6111), width: 2.5),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFC6111), width: 2.5),
              borderRadius: BorderRadius.circular(8),
            )),
        style: TextStyle(
            fontSize: 28, color: Colors.green, fontWeight: FontWeight.bold),
      ),
    );
  }
}
