import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthub_frontend/Widget/DrawerList.dart';

class SleepScreen extends StatefulWidget {
  @override
  _SleepScreenState createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true);
    return new Scaffold(
      appBar: AppBar(
        title: Text("Sleep"),
      ),
      drawer: DrawerList(),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: SearchBar(
              minimumChars: 3,
              searchBarStyle: SearchBarStyle(
                  borderRadius: BorderRadius.all(Radius.circular(22))),
              hintText: "Search",
              hintStyle: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: ScreenUtil.getInstance().setSp(45)),
            ),
          ),
        ],
      ),
    );
  }
}
