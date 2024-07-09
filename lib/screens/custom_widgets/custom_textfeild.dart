import 'package:flutter/material.dart';

class CustomValidationFeild extends StatelessWidget {


  TextEditingController controller ;
  String hintText = 'hint text here';
  Widget? icon;
  bool isObscure;

  CustomValidationFeild({super.key,required this.controller,required this.hintText,this.icon,this.isObscure=false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color:  Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(45)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 17.0/*,top: 5*/),
          child: TextField(
            obscureText: isObscure,
            obscuringCharacter: '*',
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: icon,
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 18,
                color: Color(0xFFB9B9B9)
              )
            ),
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
      ),
    );
  }
}
