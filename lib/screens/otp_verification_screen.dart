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


  void listenOTP() async{
    //bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if(permissionsGranted!){
      print("LISTENING TO OTP -----------------> 1");
      telephony.listenIncomingSms(
        listenInBackground: false,
        onNewMessage: (message) {
          print('${message.body} ---------------------> 2');
          if (message.body!.contains('delivery-app-dc02c')) {
            print('${message.body} ---------------------> 3');
            setState(() {
              otpController.text = message.body!.substring(0, 6);
              print('${message.body} ---------------------> 4');
            });
          }
        },
      );
    }else{
      print('SMS read not granted ---------------------->');
    }
  }

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
    focusNode.dispose();
    otpController.dispose();
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
                    //listenOTP();
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
                      print(userCred.credential);
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





  /*void listenOTP() {
    print("LISTENING TO OTP ");
    telephony.listenIncomingSms(
      listenInBackground: false,
      onNewMessage: (message) {
        if (message.body!.contains('delivery-app-dc02c')) {
          setState(() {
            otpController.text = message.body!.substring(0, 6);;
          });
        }
      },
    );
  }*/
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
