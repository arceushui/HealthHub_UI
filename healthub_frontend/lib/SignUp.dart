import 'package:get_it/get_it.dart';
import 'package:healthub_frontend/Service/signup_service.dart';
import 'package:healthub_frontend/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flrx_validator/flrx_validator.dart';



class SignUp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<SignUp> {

  SignupService get notesService => GetIt.I<SignupService>();

  var _formkey = GlobalKey<FormState>();

  Future<int> getUser(body) async{
    print(body);
    http.Response response = await http.post('http://localhost:8000/api/user/signup', body: body,headers: {"Content-Type": "application/json"},);
    print(response.body);
    print(response.statusCode);
    return response.statusCode;
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true);
    Size size =MediaQuery.of(context).size;
    String _password;
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset('assets/images/LoginUI/loginUI_bg.jpg',
                width: size.width,
                height: size.height,
                fit: BoxFit.fill),
          ),
          Center(
              child: Container(
                  margin: EdgeInsets.all(70.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: new Image.asset('assets/images/LoginUI/Logo.png',
                        width: 110,
                        height: 110,
                        fit: BoxFit.contain),
                  )
              )
          ),
          SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0,top:10.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: ScreenUtil.getInstance().setHeight(420),
                    ),
                    Container(
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
                                    key: _formkey,
                                    autovalidate: true,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        TextFormField(
                                          controller: usernameController,
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
                                              rules: [RequiredRule(validationMessage:"Please enter a valid username."),MinLengthRule(6, validationMessage:"Username should be at least 6 characters.")]
                                          ),

                                        ),
                                        TextFormField(
                                          controller: emailController,
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
                                          controller: passwordController,
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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            width: ScreenUtil.getInstance().setWidth(330),
                            height: ScreenUtil.getInstance().setHeight(100),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF17ead9),
                                      Color(0xFF6078ea)
                                    ]
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF6078ea).withOpacity(0.3),
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 8.0
                                  )
                                ]
                            ),
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async{
                                    var body;
                                    List listdata;

                                    listdata = listData();
                                    body = User(username: listdata[0], email: listdata[1], password: listdata[2]).encoder();
                                    final error=await getUser(body);

                                    if(error==422){
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Error 422'),
                                              content: Text('Invalid'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('OK'),
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                      );
                                    }
                                    else{
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Sign up successfully!'),
                                              content: Text('Your account is created.'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Login'),
                                                  onPressed: (){
                                                    Navigator.push(context, MaterialPageRoute(
                                                        builder: (context) => MyApp()
                                                    ),);
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                      );
                                    }

                                  },
                                  child: Center(
                                    child: Text("SIGN UP", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: "Open Sans",
                                    ),),
                                  ),
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account?",
                          style: TextStyle(
                              fontFamily: "Open Sans",
                              color: Colors.white
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text("Login",
                            style: TextStyle(
                                fontFamily: "Open Sans",
                                color: Colors.lightBlue
                            ),),
                        )
                      ],
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );}

  List listData(){
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    return [username, email, password];
  }
}

class User {
  String username;
  String email;
  String password;

  User({this.username, this.email, this.password});

  void getUsername(String username){
    this.username = username;
  }

  void getemail(String email){
    this.email = email;
  }

  void getPassword(String password){
    this.password = password;
  }

  String encoder() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["email"] = email;
    map["password"] = password;
    var body = json.encode(map);
    return body;
  }
}


