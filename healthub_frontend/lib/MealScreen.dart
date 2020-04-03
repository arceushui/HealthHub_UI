

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'NewMeal.dart';
import 'Widget/DrawerList.dart';
import 'Widget/ItemList.dart';

class MealScreen extends StatefulWidget {
  @override
  _MealScreenState createState() => _MealScreenState();
}

List<Color> colors = [Colors.blue[800], Color(0xFFffe5b4), Colors.red];
List<DateTime> date = [DateTime(2020), DateTime(2020,4,2), DateTime(2020,4,3), DateTime(2020,4,4)];

class _MealScreenState extends State<MealScreen> {

  bool choose = false;
  int choose_index = 0;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true);


    return Scaffold(
      appBar: AppBar(
        title: Text("Meal"),
      ),
      drawer: DrawerList(),
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
                                      new DateFormat.yMMMd().format(date[index]).toString(),
                                      style: TextStyle(
                                          color: choose == true && (index == choose_index)? Colors.blue : Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        choose_index = index;

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
                      itemCount: date.length,
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
                        mealName: "rice",
                        calories: 1213,
                        title: "Breakfast",
                      ),
                      CustomListItem(
                        mealName: "rice",
                        calories: 1213,
                        title: "Lunch",
                      ),
                      CustomListItem(
                        mealName: "rice",
                        calories: 1213,
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
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => NewMeal()
          ),);
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