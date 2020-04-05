import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:healthub_frontend/Model/GenerateProfile.dart';
import 'package:healthub_frontend/Model/Profile.dart';
import 'package:healthub_frontend/Model/Weight.dart';
import 'package:healthub_frontend/Widget/SaveAlertDialog.dart';
import 'package:healthub_frontend/Widget/DrawerList.dart';

import 'Model/api_response.dart';
import 'Service/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  final String id;

  ProfileScreen({@required this.id});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var _formkey = GlobalKey<FormState>();

  ProfileService get profileService => GetIt.I<ProfileService>();

  APIResponse<Profile> _apiResponse;
  bool _isLoading = false;

  int age;
  int height;
  String gender;
  List<Weight> weights;
  int _selectedGender;


  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  _getProfile() async {
    setState(() {
      _isLoading = true;
    });

    print(widget.id);

    _apiResponse = await profileService.getProfile(widget.id);


    
    weights = _apiResponse.data.weights;
    height = _apiResponse.data.height;
    gender = _apiResponse.data.gender;
    age  =_apiResponse.data.age;

    weightController = new TextEditingController(text: weights[0].weight.toString());
    heightController = new TextEditingController(text: height.toString());
    ageController = new TextEditingController(text: age.toString());
    if(gender == 'male')
      _selectedGender = 0;
    else
      _selectedGender = 1;


    setState(() {
      _isLoading = false;
    });
  }



  List<DropdownMenuItem<int>> genderList = [];

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  double weightChanged;
  int ageChanged;
  String genderChanged;
  int heightChanged;

  void loadGenderList() {
    genderList = [];
    genderList.add(new DropdownMenuItem(
      child: new Text('Male'),
      value: 0,
    ));
    genderList.add(new DropdownMenuItem(
      child: new Text('Female'),
      value: 1,
    ));
  }

  Widget getFormWidget() {



    return new DropdownButton(
      hint: new Text('Select Gender'),
      items: genderList,
      value: _selectedGender,
      onChanged: (value) {
      setState(() {
        _selectedGender = value;
        if(_selectedGender == 0)
          gender = 'male';
        else
          gender = 'female';
      });
      },
      isExpanded: true,
    );
  }

  void saveProfile(){
    List<Weight> list = [];
    Weight updatedweight = Weight(timestamp: DateTime.now(), weight: double.parse(weightController.text));
    print(updatedweight);
    list.add(updatedweight);
    print(list);
    Profile save = Profile(weights: list, age: int.parse(ageController.text), height: int.parse(heightController.text), gender: gender);
    print(gender);
    profileService.editProfile(GenerateProfile(profile: save), widget.id);
    Navigator.of(context).pop();
  }

  void cancel(){
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true);

    loadGenderList();

    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              showDialog<Null>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
              return CustomAlertDialog(title: "Confirmation Required", content: "Do you want to save changes to profile?",yesOnPressed: saveProfile, noOnPressed: cancel);
              },
              );
            },
          )
        ],
      ),
      drawer: DrawerList(id: widget.id),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom:20.0),
            child:  Container(
              color: Colors.blue,
              child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                      size: ScreenUtil.instance.setSp(100),
                    ),
                  )
              ),
              height: ScreenUtil.instance.setSp(500),
            ),
          ),
          SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top:50.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: ScreenUtil.getInstance().setHeight(300),
                    ),
                    Container(
                        width: double.infinity,
                        height: ScreenUtil.getInstance().setHeight(1200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                            padding: EdgeInsets.only(left:16, right: 16, top: 16.0),
                            child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10.0),
                                  child: Form(
                                    key: _formkey,
                                    autovalidate: true,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(

                                            child: Text(
                                              "Gender", style: TextStyle(
                                                fontFamily: "Open Sans",
                                                color: Colors.black
                                            ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: ScreenUtil.instance.setHeight(50),
                                        ),
                                        getFormWidget(),
                                        TextFormField(
                                          controller: ageController,
                                          style: TextStyle(
                                              color: Colors.black
                                          ),
                                          decoration: InputDecoration(
                                            labelText: "Age",
                                            labelStyle: TextStyle(
                                                fontFamily: "Open Sans",
                                                color: Colors.black
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black)
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black)
                                            ),

                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                        SizedBox(
                                          height: ScreenUtil.instance.setHeight(50),
                                        ),
                                        TextFormField(
                                          controller: heightController,
                                          style: TextStyle(
                                              color: Colors.black
                                          ),
                                          decoration: InputDecoration(
                                            labelText: "Height (cm)",
                                            labelStyle: TextStyle(
                                                fontFamily: "Open Sans",
                                                color: Colors.black
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black)
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black)
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                        SizedBox(
                                          height: ScreenUtil.instance.setHeight(50),
                                        ),
                                        TextFormField(
                                          controller: weightController,
                                          style: TextStyle(
                                              color: Colors.black
                                          ),
                                          decoration: InputDecoration(
                                            labelText: "Weight (kg)",
                                            labelStyle: TextStyle(
                                                fontFamily: "Open Sans",
                                                color: Colors.black
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black)
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black)
                                            ),
                                          ),
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),

                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            )
                        )
                    ),
                  ],
                ),
              )
          )
        ],
      )
    );
  }
}