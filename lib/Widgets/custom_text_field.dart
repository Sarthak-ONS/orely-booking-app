import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      required TextEditingController? emailController,
      this.isPasswordField = false,
      this.hintText = 'someone@example.com',
      this.maxLines = 1})
      : _emailController = emailController,
        super(key: key);

  final TextEditingController? _emailController;
  final bool isPasswordField;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: Colors.black54,
      child: TextFormField(
        obscureText: isPasswordField,
        style: const TextStyle(fontSize: 16),
        maxLines: maxLines,
        controller: _emailController,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          isDense: true,
        ),
        // style: _textStyleBlack,
      ),
    );
  }
}
