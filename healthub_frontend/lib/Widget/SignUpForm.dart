import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flrx_validator/flrx_validator.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _password;
    return Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(1200),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 70.0),
                  blurRadius: 30.0),
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 10.0),
                  blurRadius: 20.0),
            ]),
        child: Padding(
            padding: EdgeInsets.only(left:16, right: 16, top: 16.0),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Sign Up",
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(55),
                        fontFamily: "Open Sans",
                        color: Colors.white,
                        letterSpacing: .6
                    )),
                Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10.0),
                  child: Form(
                    autovalidate: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          style: TextStyle(
                              color: Colors.white
                          ),
                          decoration: InputDecoration(
                            labelText: "Enter your username",
                            labelStyle: TextStyle(
                                fontFamily: "Open Sans",
                                color: Colors.white
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),

                          ),
                          keyboardType: TextInputType.text,
                          validator: Validator<String>(
                            rules: [RequiredRule(validationMessage:"Please enter a valid username.")]
                          )
                        ),
                        TextFormField(
                          style: TextStyle(
                              color: Colors.white
                          ),
                          decoration: InputDecoration(
                            labelText: "Enter your email",
                            labelStyle: TextStyle(
                                fontFamily: "Open Sans",
                                color: Colors.white
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),

                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if(!EmailValidator.validate(value)) {
                              return "Please enter a valid email.";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          style: TextStyle(
                              color: Colors.white
                          ),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Enter a new password",
                            labelStyle: TextStyle(
                                fontFamily: "Open Sans",
                                color: Colors.white
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value){
                            _password=value;
                            final RegExp _passwordRegex = new RegExp(
                                r"^(?=.*[A-Z])(?=.*[a-z])\S{8,15}$");
                            if(!_passwordRegex.hasMatch(value))
                              return "Contain at least a uppercase and a lowercase \n"
                                  "Password length must be between 8 and 15";
                            return null;
                          },
                        ),
                        TextFormField(
                          style: TextStyle(
                              color: Colors.white
                          ),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Repeat your password",
                            labelStyle: TextStyle(
                                fontFamily: "Open Sans",
                                color: Colors.white
                            ),

                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value){
                            if(!(value == _password))
                              return "Please enter a valid password";
                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
        )
    );
  }
}
