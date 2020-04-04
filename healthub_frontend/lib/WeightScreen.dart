import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthub_frontend/Widget/DrawerList.dart';
import 'package:healthub_frontend/Model/Weight.dart';

import 'Model/api_response.dart';
import 'Service/profile_service.dart';
import 'package:healthub_frontend/Model/Profile.dart';

Widget _buildList(weights) => ListView.builder(
    itemCount: weights.length,
    itemBuilder: (BuildContext context, int position) {
      var weight = weights[position];
      return ListTile(
          title: Text(weight.weight.toString() + " KG"),
          subtitle: Text(weight.timestamp.day.toString() +
              "/" +
              weight.timestamp.month.toString() +
              "/" +
              weight.timestamp.year.toString()));
    });

class WeightScreen extends StatefulWidget {
  final String id;
  WeightScreen({@required this.id});
  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  ProfileService get profileService => GetIt.I<ProfileService>();

  APIResponse<Profile> _apiResponse;
  List<Weight> weights;

  Future<List<Weight>> _getWeights() async {
    _apiResponse = await profileService.getProfile(widget.id);

    return _apiResponse.data.weights;
  }

  Widget _futureBuilder(BuildContext context) => FutureBuilder<List<Weight>>(
        future: _getWeights(), // a Future<String> or null
        builder: (context, AsyncSnapshot<List<Weight>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('Press button to start');
            case ConnectionState.waiting:
              return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue));
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return _buildList(snapshot.data);
          }
        },
      );

  // void saveProfile(){
  //   List<Weight> list = weights;
  //   Weight updatedweight = Weight(timestamp: DateTime.now(), weight: double.parse(weightController.text));
  //   print(updatedweight);
  //   list.add(updatedweight);
  //   print(list);
  //   Profile save = Profile(weights: list);
  //   print(gender);
  //   profileService.editProfile(GenerateProfile(profile: save), widget.id);
  //   Navigator.of(context).pop();
  // }

  @override
  void initState() {
    super.initState();
    _getWeights();
  }

  var _formKey = GlobalKey<FormState>();

  TextEditingController weightController = TextEditingController();
  // Future<List<Weight>> _weights = Future<List<Weight>>.delayed(
  //   Duration(seconds: 2),
  //   () => ,
  // );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true);
    weights = [
      new Weight(weight: 50, timestamp: new DateTime.now()),
      new Weight(weight: 60, timestamp: new DateTime.now())
    ];
    return new Scaffold(
      appBar: AppBar(
        title: Text("Weight"),
      ),
      drawer: DrawerList(),
      body: Container(
        child: _futureBuilder(context),
      ),
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
                                decoration: const InputDecoration(
                                    hintText: 'e.g. 50',
                                    labelText: 'Weight',
                                    suffixText: "KG",
                                    labelStyle: TextStyle(fontSize: 20)),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                    child: Text("Submit"),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                      }
                                    })),
                          ])));
            },
          );
        },
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
