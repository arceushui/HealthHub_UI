import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:healthub_frontend/MealScreen.dart';
import 'package:healthub_frontend/Model/Meal.dart';

import 'Model/GenerateMeal.dart';
import 'Service/meal_service.dart';
import 'Widget/SaveAlertDialog.dart';

class NewMeal extends StatefulWidget {
  final String id;

  NewMeal({@required this.id});
  @override
  _NewMealState createState() => _NewMealState();
}


class _NewMealState extends State<NewMeal> {

  var _formkey = GlobalKey<FormState>();
  MealService get mealService => GetIt.I<MealService>();

  TextEditingController mealNameController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController ingredientController = TextEditingController();

  int _selectedType = 0;
  List<DropdownMenuItem<int>> typeList = [];

  String _date = "Not set";
  DateTime mealtime;

  bool _isChecked = true;

  List<String> text = ["Manual Typing"];

  List<String> ingredients = new List<String>();
  String type;


  @override
  void initState() {
    super.initState();
  }

  void loadTypeList() {
    typeList = [];
    typeList.add(new DropdownMenuItem(
      child: new Text('Breakfast'),
      value: 0,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Lunch'),
      value: 1,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Dinner'),
      value: 2,
    ));
  }

  Widget getFormWidget() {

    return new DropdownButton(
      hint: new Text('Select meal type'),
      items: typeList,
      value: _selectedType,
      onChanged: (value) {
        setState(() {
          _selectedType = value;
          if(_selectedType == 0)
            type = "breakfast";
          else if(_selectedType == 1)
            type = "lunch";
          else
            type = "dinner";
        });
      },
      isExpanded: true,
    );
  }

  void saveMeal(){
    String auto;
    double calories;

    if(_isChecked){
      auto = "false";
      calories = double.parse(caloriesController.text);
    }

    else{
      auto = "true";
      calories = 0.0;
    }
    Meal save = Meal(mealName: mealNameController.text, mealTime: mealtime, mealType: type, calories: calories,ingredients: ingredients);
    print(save);

    mealService.editMeal(GenerateMeal(meals: [save]), widget.id, auto);
    Navigator.of(context).pop();
  }

  void cancel(){
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true);


    loadTypeList();

    return Scaffold(
        appBar: AppBar(
          title: Text("Add new meal"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                showDialog<Null>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return SaveAlertDialog(title: "Confirmation Required", content: "Do you want to save changes to profile?",yesOnPressed: saveMeal, noOnPressed: cancel);
                  },
                );
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top:10.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: ScreenUtil.getInstance().setHeight(10),
                      ),
                      Container(
                          width: double.infinity,
                          height: ScreenUtil.getInstance().setHeight(2000),
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
                                                "Meal Type", style: TextStyle(
                                                  fontFamily: "Open Sans",
                                                  color: Colors.black,
                                                  fontSize:ScreenUtil.instance.setSp(50)
                                              ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil.instance.setHeight(50),
                                          ),
                                          getFormWidget(),
                                          TextFormField(
                                            controller: mealNameController,
                                            style: TextStyle(
                                                color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              labelText: "Meal Name",
                                              labelStyle: TextStyle(
                                                  fontFamily: "Open Sans",
                                                  color: Colors.black,
                                                  fontSize: ScreenUtil.instance.setSp(50)
                                              ),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black)
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black)
                                              ),

                                            ),
                                            keyboardType: TextInputType.text,
                                          ),
                                          SizedBox(
                                            height: ScreenUtil.instance.setHeight(50),
                                          ),
                                          TextFormField(
                                            enabled: _isChecked,
                                            controller: caloriesController,
                                            style: TextStyle(
                                                color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              labelText: "Calories",
                                              labelStyle: TextStyle(
                                                  fontFamily: "Open Sans",
                                                  color: Colors.black,
                                                  fontSize: ScreenUtil.instance.setSp(50)
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
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                    height: 60.0,
                                                    child: Column(
                                                      children: text
                                                          .map((t) => CheckboxListTile(
                                                        title: Text(t),
                                                        value: _isChecked,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _isChecked = val;
                                                          });
                                                        },
                                                      ))
                                                          .toList(),
                                                    ),
                                                  ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: ScreenUtil.instance.setHeight(50),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(

                                              child: Text(
                                                "Meal Date", style: TextStyle(
                                                  fontFamily: "Open Sans",
                                                  color: Colors.black,
                                                  fontSize: ScreenUtil.instance.setSp(50)
                                              ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 3.0,
                                                    ),
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      RaisedButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5.0)),
                                                        onPressed: () {
                                                          DatePicker.showDatePicker(context,
                                                              theme: DatePickerTheme(
                                                                containerHeight: 210.0,
                                                              ),
                                                              showTitleActions: true,
                                                              minTime: DateTime(2020, 1, 1),
                                                              maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
                                                                print('confirm $date');
                                                                _date = '${date.year} - ${date.month} - ${date.day}';
                                                                setState(() {
                                                                  mealtime = date;
                                                                });
                                                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                                                        },
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          height: 50.0,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              Row(
                                                                children: <Widget>[
                                                                  Container(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Icon(
                                                                          Icons.date_range,
                                                                          size: 18.0,
                                                                          color: Colors.black,
                                                                        ),
                                                                        Text(
                                                                          " $_date",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 18.0),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              Text(
                                                                "  Change",
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 18.0),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        color: Colors.white,
                                                      ),


                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil.instance.setHeight(50),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil.instance.setHeight(50),
                                          ),
                                          TextFormField(
                                            controller: ingredientController,
                                            style: TextStyle(
                                                color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              labelText: "Ingredients",
                                              labelStyle: TextStyle(
                                                  fontFamily: "Open Sans",
                                                  color: Colors.black,
                                                  fontSize: ScreenUtil.instance.setSp(50)
                                              ),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black)
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black)
                                              ),
                                            ),
                                            keyboardType: TextInputType.text,
                                          ),
                                          RaisedButton(
                                            onPressed: (){
                                              ingredients.add(ingredientController.text);
                                            },
                                            child: Text("ADD"),
                                          ),
                                          Container(
                                              height: 100,
                                              child: ListView.separated(
                                                scrollDirection: Axis.horizontal,
                                                shrinkWrap: true,
                                                padding: const EdgeInsets.all(8),
                                                itemCount: ingredients.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Container(
                                                    height: 50,
                                                    color: Colors.amber,
                                                    child: Center(child: Text(ingredients[index])),
                                                  );
                                                },
                                                separatorBuilder:  (BuildContext context, int index) {
                                                  return SizedBox(
                                                    width: 15.0,
                                                  );
                                                },
                                              )),
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
