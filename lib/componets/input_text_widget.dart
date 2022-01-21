import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {
  final label;
  final controller;
  final onTap;
  final onChange;
  InputTextWidget({
    this.label,
    this.controller,
    this.onTap,
    this.onChange,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: TextFormField(
        controller: this.controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 17,
          ),
          hintText: this.label,
          hintStyle: TextStyle(fontSize: 15),
          fillColor: Colors.white,
          filled: true,
        ),
        onTap: this.onTap,
        onChanged: this.onChange,
      ),
    );
  }
}
