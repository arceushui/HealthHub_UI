import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthub_frontend/Widget/DateTimePicker.dart';
import 'package:healthub_frontend/Widget/DrawerList.dart';
import 'package:healthub_frontend/Model/Activity.dart';
import 'package:flutter/services.dart';

import 'Model/api_response.dart';
import 'Service/activity_service.dart';
import 'package:healthub_frontend/Widget/WeightLineChart.dart';
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
              return new Text('Press button to start');
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else {
                print("snapshot is " + snapshot.toString());

                return _buildChartAndList(snapshot.data.activities.toList());
              }
          }
        },
      );

  Widget _buildChartAndList(activities) => Column(
        children: <Widget>[
          // new Expanded(child: WeightLineChart.withWeights(activities)),
          new Expanded(child: _buildList(activities)),
        ],
      );

  Widget _buildList(activities) => ListView.builder(
      itemCount: activities.length,
      itemBuilder: (BuildContext context, int position) {
        var activity = activities[position];
        return ListTile(
            title: Text(activity.activity.toString()),
            subtitle: Text(activity.date.day.toString() +
                "/" +
                activity.date.month.toString() +
                "/" +
                activity.date.year.toString()));
      });

  void addActivity() {
    // Activity _activity = Activity(
    //     activity: activityController.text,
    //     caloriBurned: double.parse(caloriesController.text),
    //     duration: double.parse(durationController.text),
    //     date: dateController.);
    // activities.add(_activity);
    // activityService.addActivity(_activity, widget.id);
    // Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  var _formKey = GlobalKey<FormState>();

  TextEditingController activityController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  DateTimePicker dateTimeController = DateTimePicker();

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
                                    labelStyle: TextStyle(fontSize: 20)),
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                    child: Text("Submit"),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        addActivity();
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
