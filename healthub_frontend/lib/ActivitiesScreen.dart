import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:healthub_frontend/Widget/DrawerList.dart';
import 'package:healthub_frontend/Model/Activity.dart';
import 'package:flutter/services.dart';

import 'Model/api_response.dart';
import 'Service/activity_service.dart';
import 'package:healthub_frontend/Widget/charts/ActivityBarChart.dart';
import 'package:healthub_frontend/Model/Activities.dart';

class ActivitiesScreen extends StatefulWidget {
  final String id;
  ActivitiesScreen({@required this.id});
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  ActivityService get activityService => GetIt.I<ActivityService>();
  // String id = "5e8045a1a48f421f4f9ff6c4";
  APIResponse<Activities> _apiResponse;
  Activities activities;

  Future<Activities> _getActivities() async {
    _apiResponse = await activityService.getActivities(widget.id);
    activities = _apiResponse.data;

    return activities;
  }

  Widget _futureBuilder(BuildContext context) => FutureBuilder<Activities>(
        future: _getActivities(), // a Future<String> or null
        builder: (context, AsyncSnapshot<Activities> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('No Connection');
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else {
                return _buildChartAndList(snapshot.data.activities.toList());
              }
          }
        },
      );

  Widget _buildChartAndList(activities) => Column(
        children: <Widget>[
          new Expanded(child: ActivityBarChart.withActivities(activities)),
          new Expanded(child: _buildList(activities)),
        ],
      );

  Widget _buildList(activities) => ListView.separated(
      itemCount: activities.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int position) {
        var activity = activities[position];
        return Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  activity.activity,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                Text(
                  activity.date.split("T")[0].split("-").reversed.join("/"),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  activity.caloriBurned.toStringAsFixed(1) +
                      " cal" +
                      " ★ " +
                      activity.duration.toStringAsFixed(1) +
                      "h",
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ));
      });

  void addActivity(confirmedDate) async {
    Activities _activities = new Activities();
    confirmedDate = confirmedDate.replaceAll(" ", "T");
    Activity _activity = Activity(
        activity: activityController.text,
        caloriBurned: double.parse(caloriesController.text),
        duration: double.parse(durationController.text),
        date: confirmedDate);
    _activities.activities = new List<Activity>();
    _activities.activities.add(_activity);
    await activityService.addActivities(_activities, widget.id);
    setState(() {});
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  var _formKey = GlobalKey<FormState>();

  TextEditingController activityController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true);

    return new Scaffold(
      appBar: AppBar(
        title: Text("Activities"),
      ),
      drawer: DrawerList(id: widget.id),
      body: Container(child: _futureBuilder(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String confirmedDate = dateController.text;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  content: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: activityController,
                                decoration: const InputDecoration(
                                    hintText: 'Jogging',
                                    labelText: 'Activity Name',
                                    labelStyle: TextStyle(fontSize: 15)),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: caloriesController,
                                decoration: const InputDecoration(
                                    hintText: '25',
                                    labelText: 'Calories Burned',
                                    labelStyle: TextStyle(fontSize: 15)),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: durationController,
                                decoration: const InputDecoration(
                                    hintText: 'Hours',
                                    labelText: 'Duration',
                                    labelStyle: TextStyle(fontSize: 15)),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: dateController,
                                decoration: const InputDecoration(
                                    labelText: 'Date',
                                    labelStyle: TextStyle(fontSize: 15)),
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime.now()
                                          .subtract(new Duration(days: 365)),
                                      maxTime: DateTime.now(),
                                      onChanged: (date) {}, onConfirm: (date) {
                                    confirmedDate = date.toString();
                                    dateController.text = date.day.toString() +
                                        "/" +
                                        date.month.toString() +
                                        "/" +
                                        date.year.toString();
                                  }, currentTime: DateTime.now());
                                },
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                    child: Text("Submit"),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        addActivity(confirmedDate);
                                      }
                                    })),
                          ])));
            },
          );
        },
        tooltip: 'Add New Activity',
        child: const Icon(Icons.add),
      ),
    );
  }
}
