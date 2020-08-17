import "package:flutter/material.dart";

class Button extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  final bool isFit;

  const Button(
      {@required this.text, @required this.callback, this.isFit = false});
  @override
  Widget build(BuildContext context) {
    if (this.isFit) {
      return FlatButton(
        child: Text(
          text,
        ),
        onPressed: callback,
      );
    }
    return FlatButton(
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: callback,
      child: Text(text),
    );
  }
}
