import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:healthub_frontend/Widget/DrawerList.dart';
import 'package:healthub_frontend/Model/Sleep.dart';
import 'package:flutter/services.dart';

import 'Model/api_response.dart';
import 'Service/activity_service.dart';
import 'package:healthub_frontend/Widget/charts/ActivityBarChart.dart';
import 'package:healthub_frontend/Model/SleepStore.dart';

class SleepScreen extends StatefulWidget {
  final String id;
  SleepScreen({@required this.id});
  @override
  _SleepScreenState createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  ActivityService get activityService => GetIt.I<ActivityService>();
  // String id = "5e8045a1a48f421f4f9ff6c4";
  APIResponse<SleepStore> _apiResponse;
  SleepStore sleeping;

  Future<SleepStore> _getSleepStore() async {
    _apiResponse = await sleepService.getSleepStore(widget.id);
    sleeping = _apiResponse.data;

    return sleeping;
  }

  Widget _futureBuilder(BuildContext context) => FutureBuilder<SleepStore>(
        future: _getSleepStore(), // a Future<String> or null
        builder: (context, AsyncSnapshot<SleepStore> snapshot) {
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
                return _buildChartAndList(snapshot.data.sleeping.toList());
              }
          }
        },
      );

  Widget _buildChartAndList(sleeping) => Column(
        children: <Widget>[
          new Expanded(child: SleepBarChart.withSleepStore(sleeping)),
          new Expanded(child: _buildList(sleeping)),
        ],
      );

  Widget _buildList(sleeping) => ListView.separated(
      itemCount: sleeping.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int position) {
        var sleep = sleeping[position];
        return Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  activity.duration,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                Text(
                  sleep.sleepingTime
                      .split("T")[0]
                      .split("-")
                      .reversed
                      .join("/"),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  DateTime.parse(sleep.sleepingTime),
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ));
      });

  void addSleep(confirmedSleepTime) async {
    SleepStore _sleeping = new SleepStore();
    confirmedSleepTime = confirmedSleepTime.replaceAll(" ", "T");
    Sleep _sleep = Sleep(
      duration: durationController.text,
      sleepingTime: confirmedSleepTime,
    );
    _sleeping.sleeping = new List<Sleep>();
    _sleeping.sleeping.add(_sleep);
    await activityService.addSleepStore(_sleeping, widget.id);
    setState(() {});
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  var _formKey = GlobalKey<FormState>();

  TextEditingController sleepTimeController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true);

    return new Scaffold(
      appBar: AppBar(
        title: Text("Sleep"),
      ),
      drawer: DrawerList(id: widget.id),
      body: Container(child: _futureBuilder(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String confirmedSleepTime = sleepTimeController.text;
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
                                controller: sleepTimeController,
                                decoration: const InputDecoration(
                                    labelText: 'Sleep Start Time',
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
                                    confirmedSleepTime = date.toString();
                                    sleepTimeController.text =
                                        date.day.toString() +
                                            "/" +
                                            date.month.toString() +
                                            "/" +
                                            date.year.toString();
                                  }, currentTime: DateTime.now());
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: durationController,
                                decoration: const InputDecoration(
                                    hintText: 'Hours',
                                    labelText: 'Sleep Duration',
                                    labelStyle: TextStyle(fontSize: 15)),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                    child: Text("Submit"),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        addSleep(confirmedSleepTime);
                                      }
                                    })),
                          ])));
            },
          );
        },
        tooltip: 'Add New Sleep',
        child: const Icon(Icons.add),
      ),
    );
  }
}
