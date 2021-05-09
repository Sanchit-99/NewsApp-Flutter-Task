import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;

  InputField({@required this.hint,@required this.controller,@required this.obscure});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Container(
      height: 40,
      width: mq.width * 0.8,
      child: TextField(
        obscureText: obscure,
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white),
          fillColor: Colors.brown.shade200,
          filled: true,
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(20.0),
            ),
            borderSide: const BorderSide(width: 0.0),

          ),
          focusedBorder: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(20.0),
            ),
            borderSide: const BorderSide(width: 0.0),
          ),
          contentPadding:
              EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 15),
        ),
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
