import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:healthub_frontend/PrescriptionScreen.dart';
import 'package:healthub_frontend/ProfileScreen.dart';
import 'package:healthub_frontend/WeightScreen.dart';
import 'package:healthub_frontend/ActivitiesScreen.dart';
import 'package:healthub_frontend/SleepScreen.dart';

import '../MealScreen.dart';

class DrawerList extends StatelessWidget {
  final String id;

  DrawerList({@required this.id});

  @override
  Widget build(BuildContext context) {
    print(id);
    String _password;
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Hui"),
            accountEmail: Text("lgndhui@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: ScreenUtil.instance.setSp(100),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.face),
            title: Text("Profile"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ProfileScreen(id: id)));
            },
          ),
          ListTile(
            leading: Icon(Icons.accessibility),
            title: Text("Weight"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WeightScreen(id: id)));
            },
          ),
          ListTile(
            leading: Icon(Icons.directions_run),
            title: Text("Exercise"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ActivitiesScreen(id: id)));
            },
          ),
          ListTile(
            leading: Icon(Icons.event_seat),
            title: Text("Sleep"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SleepScreen(id: id)));
            },
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text("Diet"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MealScreen(id: id)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text("Prescription"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PrescriptionScreen(id: id)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.forum),
            title: Text("Dianogsis"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
          ),
        ],
      ),
    );
  }
}
