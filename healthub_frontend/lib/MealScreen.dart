import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:healthub_frontend/Model/Meal.dart';
import 'package:healthub_frontend/Service/meal_service.dart';
import 'package:intl/intl.dart';

import 'Model/GenerateMeal.dart';
import 'Model/api_response.dart';
import 'NewMeal.dart';
import 'Widget/DrawerList.dart';
import 'Widget/ItemList.dart';

class MealScreen extends StatefulWidget {
  final String id;

  MealScreen({@required this.id});
  @override
  _MealScreenState createState() => _MealScreenState();
}

List<Color> colors = [Colors.blue[800], Color(0xFFffe5b4), Colors.red];
List<DateTime> mealTime = [DateTime(2010, 9, 23)];
var formatter = new DateFormat('yyyy-MM-dd');

class _MealScreenState extends State<MealScreen> {

  MealService get mealService => GetIt.I<MealService>();

  APIResponse<GenerateMeal> _apiResponse;

  bool _isLoading = false;

  List<Meal> list;

  List<DateTime> mealTime = new List<DateTime>();



  _getMeal() async {

    setState(() {
      _isLoading = true;
    });

    print(widget.id);
    _apiResponse = await mealService.getMeal(widget.id);

    mealTime =[];



    list = _apiResponse.data.meals.toList();
    print(list);
    for(var i = 0; i < list.length; i++) {
      if (i != 0) {
        if (formatter.format(list[i].mealTime) != formatter.format(list[i - 1].mealTime)) {
          mealTime.add(list[i].mealTime);
        }
      }
      else
        mealTime.add(list[i].mealTime);
    }

    print(mealTime);


    setState(() {
      _isLoading = false;
    });

  }

  @override
  void initState() {
      _getMeal();
    super.initState();
  }

  bool choose = false;
  int choose_index = 0;

  String breakfast = "Please add the meal";
  String lunch = "Please add the meal";
  String dinner = "Please add the meal";

  double breakfastCalories = 0;
  double lunchCalories = 0;
  double dinnerCalories = 0;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true);


    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Meal"),
      ),
      drawer: DrawerList(id: widget.id),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 15.0, top: 30.0, bottom: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 70.0,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 55.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: choose == true && (index == choose_index)? Colors.white :  Colors.blue,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Material(
                                color: Colors.transparent,
                                  child: InkWell(
                                    child: Text(
                                      new DateFormat.yMMMd().format(mealTime[index]).toString(),
                                      style: TextStyle(
                                          color: choose == true && (index == choose_index)? Colors.blue : Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onTap: (){
                                      breakfast = "Please add the meal";
                                      lunch = "Please add the meal";
                                      dinner = "Please add the meal";

                                      breakfastCalories = 0;
                                      lunchCalories = 0;
                                      dinnerCalories = 0;
                                      for(var i = 0; i < list.length; i++) {
                                        if (formatter.format(list[i].mealTime) == formatter.format(mealTime[index])) {

                                          if(list[i].mealType == "breakfast"){
                                            breakfast = list[i].mealName;
                                            breakfastCalories = list[i].calories;
                                          }

                                          else if(list[i].mealType == "lunch"){
                                            lunch = list[i].mealName;
                                            lunchCalories = list[i].calories;
                                          }

                                          else{
                                            dinner = list[i].mealName;
                                            dinnerCalories = list[i].calories;
                                          }
                                        }
                                      }
                                      setState(() {
                                        choose_index = index;
                                        mealTime.toSet().toList();

                                      });
                                      choose=true;
                                    },
                                  )
                            )

                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 15.0,
                        );
                      },
                      itemCount: mealTime.length,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: ScreenUtil.instance.setHeight(1500),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                  ),
                  ListView(
                    padding: const EdgeInsets.only(top: 30, bottom: 15, left: 8,right: 8),
                    itemExtent: 106.0,
                    children: <CustomListItem>[
                      CustomListItem(
                        mealName: breakfast,
                        calories: breakfastCalories,
                        title: "Breakfast",
                      ),
                      CustomListItem(
                        mealName: lunch,
                        calories: lunchCalories,
                        title: "Lunch",
                      ),
                      CustomListItem(
                        mealName: dinner,
                        calories: dinnerCalories,
                        title: "Dinner",
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => NewMeal(id: widget.id,))).then((context){
                _getMeal();
          });
        },
        child: Icon(
          Icons.add,
          size: 40,
          color: Colors.blue,
        ),
        backgroundColor: Colors.white,

      ),
    );
  }
}