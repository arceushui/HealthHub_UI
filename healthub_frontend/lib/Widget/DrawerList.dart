import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:healthub_frontend/ProfileScreen.dart';
import 'package:healthub_frontend/WeightScreen.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _password;
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Hui"),
            accountEmail: Text("lgndhui@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person,
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
                  builder: (BuildContext context) => ProfileScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.accessibility),
            title: Text("Weight"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WeightScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.directions_run),
            title: Text("Activity"),
          ),
          ListTile(
            leading: Icon(Icons.event_seat),
            title: Text("Sleeping"),
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text("Meal"),
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text("Prescription"),
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