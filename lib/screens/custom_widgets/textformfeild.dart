import 'package:flutter/material.dart';

class CustomValidationFeild extends StatelessWidget {


  final TextEditingController controller;
  String hintText = 'hint text here';
  final Widget? icon;
  final bool isObscure;
  final String? Function(String?)? validator;
  int? maxLength;

  CustomValidationFeild({super.key,required this.controller,required this.hintText,this.icon,this.isObscure=false,this.validator,this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        //height: 50,
        decoration: BoxDecoration(
            color:  Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(45)
        ),
        child: Padding(
          padding:EdgeInsets.only(left: 17.0/*,top: 5*/),
          child: TextFormField(
            maxLength: maxLength,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator, // want to accept custom validator here
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
