import "package:flutter/material.dart";

class Input extends StatelessWidget {
  final String initialValue;
  final String labelText;

  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;

  final TextInputType keyboardType;

  final bool obscureText;

  const Input(
      {this.initialValue = '',
      @required this.labelText,
      @required this.onSaved,
      @required this.validator,
      this.keyboardType = TextInputType.text,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.deepPurple,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.red[400],
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.red[400],
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.deepPurple,
          ),
        ),
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: Colors.purple[800],
        ),
      ),
    );
  }
}
