import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthub_frontend/Widget/DrawerList.dart';

class WeightScreen extends StatefulWidget {
  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true);
    return new Scaffold(
        appBar: AppBar(
          title: Text("Weight"),
        ),
        drawer: DrawerList(),
        body: Container());
  }
}
