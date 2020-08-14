import 'package:flutter/material.dart';
import '../components/rounded_button.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String title;
  final Function onPressed;

  RoundedButton(
      {@required this.color, @required this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(25.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 170.0,
          height: 60.0,
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }
}
