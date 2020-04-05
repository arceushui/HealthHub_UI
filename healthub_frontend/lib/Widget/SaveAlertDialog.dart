import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {

  String title;
  String content;
  String yes;
  String no;
  Function yesOnPressed;
  Function noOnPressed;

  CustomAlertDialog({String title, String content, Function yesOnPressed, Function noOnPressed, String yes = "Confirm", String no = "Cancel"}){
    this.title = title;
    this.content = content;
    this.yesOnPressed = yesOnPressed;
    this.noOnPressed = noOnPressed;
    this.yes = yes;
    this.no = no;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(this.title),
      content: new Text(this.content),
      backgroundColor: Colors.white,
      shape:
      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: <Widget>[
        new FlatButton(
          child: new Text(this.no),
          textColor: Colors.black,
          onPressed: () {
            this.noOnPressed();
          },
        ),
        new FlatButton(
          child: Text(this.yes),
          textColor: Colors.black,
          onPressed: () {
            this.yesOnPressed();
          },
        ),
      ],
    );
  }
}