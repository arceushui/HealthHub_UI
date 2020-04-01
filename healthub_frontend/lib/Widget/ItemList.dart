import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    this.title,
    this.mealName,
    this.calories,
  });

  final String title;
  final String mealName;
  final double calories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        AnimatedContainer(
          height: 150,
          width: 350,
          duration: Duration(seconds: 2),
          curve: Curves.easeIn,
          child: Material(
            color: Colors.white,
            child: InkWell(
              child: _Description(
              title: title,
              mealName: mealName,
              calories: calories,
              ),
              onTap: () {

              }
            )
          )
        )
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    Key key,
    this.title,
    this.mealName,
    this.calories,
  }) : super(key: key);

  final String title;
  final String mealName;
  final double calories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 30.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            mealName,
            style: const TextStyle(fontSize: 20.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            '$calories kcal',
            style: const TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}