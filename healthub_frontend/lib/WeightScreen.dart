import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthub_frontend/Widget/DrawerList.dart';
import 'package:healthub_frontend/Model/Weight.dart';
import 'package:flutter/services.dart';

import 'Model/api_response.dart';
import 'Service/profile_service.dart';
import 'package:healthub_frontend/Widget/charts/WeightLineChart.dart';
import 'package:healthub_frontend/Model/Profile.dart';
import 'package:healthub_frontend/Model/GenerateProfile.dart';

class WeightScreen extends StatefulWidget {
  final String id;
  WeightScreen({@required this.id});
  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  ProfileService get profileService => GetIt.I<ProfileService>();
  // String id = "5e8045a1a48f421f4f9ff6c4";
  APIResponse<Profile> _apiResponse;
  Profile profile;

  Future<Profile> _getProfile() async {
    _apiResponse = await profileService.getProfile(widget.id);
    profile = _apiResponse.data;

    return profile;
  }

  Widget _futureBuilder(BuildContext context) => FutureBuilder<Profile>(
        future: _getProfile(), // a Future<String> or null
        builder: (context, AsyncSnapshot<Profile> snapshot) {
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
                return _buildChartAndList(snapshot.data.weights);
              }
          }
        },
      );

  Widget _buildChartAndList(weights) => Column(
        children: <Widget>[
          new Expanded(child: WeightLineChart.withWeights(weights)),
          new Expanded(child: _buildList(weights)),
        ],
      );

  Widget _buildList(weights) => ListView.separated(
      itemCount: weights.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
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

  void saveProfile() async {
    Weight newWeight = Weight(
        timestamp: DateTime.now(), weight: double.parse(weightController.text));
    List<Weight> _newWeight = [];
    _newWeight.add(newWeight);
    Profile save = Profile(
        weights: _newWeight,
        age: profile.age,
        height: profile.height,
        gender: profile.gender);
    await profileService.editProfile(GenerateProfile(profile: save), widget.id);
    setState(() {});
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  var _formKey = GlobalKey<FormState>();

  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true);

    return new Scaffold(
      appBar: AppBar(
        title: Text("Weight"),
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
                                controller: weightController,
                                decoration: const InputDecoration(
                                    hintText: 'e.g. 50',
                                    labelText: 'Add Today\'s Weight',
                                    suffixText: "KG",
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
                                        saveProfile();
                                      }
                                    })),
                          ])));
            },
          );
        },
        tooltip: 'Add Today\'s Weight',
        child: const Icon(Icons.add),
      ),
    );
  }
}
