import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:healthub_frontend/ProfileScreen.dart';
import 'Model/login.dart';
import 'Service/login_service.dart';
import 'SignUp.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => LoginService());
}

void main() {
  setupLocator();
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSelected = false;
  var _formkey = GlobalKey<FormState>();
  var listdata = [];

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginService get loginService => GetIt.I<LoginService>();

  void _radio(){
    setState(() {
      _isSelected = !_isSelected;
    });
  }
  Widget radioButton(bool isSelected) => Container(
    width: 16.0,
    height: 16.0,
    padding: EdgeInsets.all(2.0),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
            width: 2.0,
            color: Colors.black
        )
    ),
    child: isSelected ? Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black
      ),) : Container(),
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true);
    Size size =MediaQuery.of(context).size;
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
                    SizedBox(height: ScreenUtil.getInstance().setHeight(680),
                    ),
                    Container(
                        width: double.infinity,
                        height: ScreenUtil.getInstance().setHeight(800),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 70.0),
                                  blurRadius: 30.0),
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0.0, -10.0),
                                  blurRadius: 20.0),
                            ]),
                        child: Padding(
                            padding: EdgeInsets.only(left:16, right: 16, top: 16.0),
                            child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Login",
                                    style: TextStyle(
                                        fontSize: ScreenUtil.getInstance().setSp(55),
                                        fontFamily: "Open Sans",
                                        color: Colors.white,
                                        letterSpacing: .6
                                    )),
                                Container(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50, bottom: 35.0),
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
                                            labelText: "Username",
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
                                        ),
                                        TextFormField(
                                          controller: passwordController,
                                          style: TextStyle(
                                              color: Colors.white
                                          ),
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            labelText: "Password",
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
                                        )
                                      ],
                                    ),
                                  ),
                                ),


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text("Forgot Password?",
                                      style: TextStyle(
                                          fontSize: ScreenUtil.getInstance().setSp(28),
                                          color: Color(0xFF25ffab),
                                          fontFamily: "Open Sans"
                                      ),),

                                  ],
                                )
                              ],
                            )
                        )
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 12.0,
                            ),
                            GestureDetector(
                              onTap: _radio,
                              child: radioButton(_isSelected),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text("Remember me",
                                style: TextStyle(
                                    fontFamily: "Opens Sans",
                                    fontSize: 12,
                                    color: Colors.white
                                ))
                          ],
                        ),
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
                                    final user = Login(
                                        username: usernameController.text,
                                        password: passwordController.text
                                    );

                                    final result = await loginService.login(user);
                                    final id = await loginService.sendId(user);

                                    if(result.error){
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
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => ProfileScreen(id: id.data)
                                      ),);
                                    }
                                  },
                                  child: Center(
                                    child: Text("LOGIN", style: TextStyle(
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
                        Text("Don't have an account?",
                          style: TextStyle(
                              fontFamily: "Open Sans",
                              color: Colors.white
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => SignUp()
                            ),);
                          },
                          child: Text("SignUp",
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
    );
  }




}




