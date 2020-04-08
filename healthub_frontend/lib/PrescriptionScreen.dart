import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:healthub_frontend/Widget/DrawerList.dart';
import 'package:flutter/services.dart';

import 'Model/api_response.dart';
import 'Service/prescription_service.dart';
import 'package:healthub_frontend/Model/PrescriptionStore.dart';
import 'package:healthub_frontend/Model/Prescription.dart';
import 'package:table_calendar/table_calendar.dart';

class PrescriptionScreen extends StatefulWidget {
  final String id;
  PrescriptionScreen({@required this.id});
  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen>
    with TickerProviderStateMixin {
  PrescriptionService get prescriptionService => GetIt.I<PrescriptionService>();
  // String id = "5e8045a1a48f421f4f9ff6c4";
  APIResponse<PrescriptionStore> _apiResponse;
  PrescriptionStore prescriptionStore;
  CalendarController _calendarController;
  AnimationController _animationController;

  // Map<DateTime, List> _prescriptions;
  List _selectedPrescriptions;
  DateTime _selectedDay;

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  var _formKey = GlobalKey<FormState>();

  TextEditingController prescriptionNameController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController prescriptionUnitController = TextEditingController();
  TextEditingController repeatDayController = TextEditingController();

  @override
  void dispose() {
    _calendarController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List prescriptions) {
    setState(() {
      _selectedPrescriptions = prescriptions;
      _selectedDay = day;
    });
  }

  List generateDays(DateTime start, DateTime end) {
    final daysToGenerate = end.difference(start).inDays;
    final days = List.generate(daysToGenerate,
        (i) => DateTime(start.year, start.month, start.day + (i)));
    return days;
  }

  Map<DateTime, List> formatCalendarData(
      List<Prescription> _prescriptionsData) {
    final start = DateTime.now().subtract(new Duration(days: 14));
    final end = DateTime.now().add(new Duration(days: 14));
    return Map.fromIterable(generateDays(start, end),
        key: (day) => day,
        value: (day) => findPrescriptionNames(_prescriptionsData, day));
  }

  List findPrescriptionNames(
      List<Prescription> _prescriptionsData, DateTime day) {
    List prescriptionNames = [];
    _prescriptionsData.forEach((prescription) {
      final prescriptionDays = generateDays(
          DateTime.parse(prescription.startDate),
          DateTime.parse(prescription.endDate));
      if (prescriptionDays.contains(day)) {
        prescriptionNames.add(prescription.prescriptionName);
      }
    });
    return prescriptionNames;
  }

  void addPrescription(confirmedStartDate, confirmedEndDate) async {
    print("confirmedStartDate is $confirmedStartDate");
    PrescriptionStore _prescriptionStore = new PrescriptionStore();
    confirmedStartDate = confirmedStartDate.replaceAll(" ", "T");
    confirmedEndDate = confirmedEndDate.replaceAll(" ", "T");
    print("confirmedStartDate after change is $confirmedStartDate");

    Prescription _prescription = Prescription(
        prescriptionName: prescriptionNameController.text,
        instructions: instructionsController.text,
        repeatDay: int.parse(repeatDayController.text),
        prescriptionUnit: prescriptionUnitController.text,
        startDate: confirmedStartDate,
        endDate: confirmedEndDate);

    _prescriptionStore.prescriptions = new List<Prescription>();
    _prescriptionStore.prescriptions.add(_prescription);
    await prescriptionService.addPrescriptionStore(
        _prescriptionStore, widget.id);
    Navigator.of(context).pop();
  }

  Future<PrescriptionStore> _getPrescriptionStore() async {
    _apiResponse = await prescriptionService.getPrescriptionStore(widget.id);
    prescriptionStore = _apiResponse.data;
    return prescriptionStore;
  }

  Widget _futureBuilder(BuildContext context) =>
      FutureBuilder<PrescriptionStore>(
        future: _getPrescriptionStore(), // a Future<String> or null
        builder: (context, AsyncSnapshot<PrescriptionStore> snapshot) {
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
                return _buildCalendarAndList(
                    snapshot.data.prescriptions.toList());
              }
          }
        },
      );

  Widget _buildCalendarAndList(_prescriptions) => Column(
        children: <Widget>[
          new Expanded(
              flex: 0,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: _buildTableCalendarWithBuilders(
                      formatCalendarData(_prescriptions)))),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList(_prescriptions)),
        ],
      );

  Widget _buildTableCalendarWithBuilders(_prescriptions) {
    return TableCalendar(
      calendarController: _calendarController,
      events: _prescriptions,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      initialSelectedDay: _selectedDay,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(List<Prescription> _prescriptions) {
    List<Prescription> selectedPrescriptions = [];
    _prescriptions.forEach((_prescription) {
      if (_selectedPrescriptions != null &&
          _selectedPrescriptions.contains(_prescription.prescriptionName)) {
        selectedPrescriptions.add(_prescription);
      }
    });
    return selectedPrescriptions.length != 0
        ? ListView(
            children: selectedPrescriptions
                .map((prescription) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.8),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                        title: Text(
                            "Prescription: " + prescription.prescriptionName),
                        subtitle:
                            Text("Instructions: " + prescription.instructions),
                        onTap: () {},
                      ),
                    ))
                .toList(),
          )
        : Text("No prescriptions for this date!");
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true);

    return new Scaffold(
      appBar: AppBar(
        title: Text("Prescriptions"),
      ),
      drawer: DrawerList(id: widget.id),
      body: Container(child: _futureBuilder(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String confirmedStartDate = startDateController.text;
          String confirmedEndDate = endDateController.text;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  content: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                controller: prescriptionNameController,
                                decoration: const InputDecoration(
                                    hintText: 'Antibiotics',
                                    labelText: 'Prescription Name',
                                    labelStyle: TextStyle(fontSize: 15)),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: prescriptionUnitController,
                                decoration: const InputDecoration(
                                    hintText: '1',
                                    labelText: 'Prescription Amount',
                                    labelStyle: TextStyle(fontSize: 15)),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: repeatDayController,
                                decoration: const InputDecoration(
                                    hintText: '3',
                                    labelText: 'Frequency per Day',
                                    labelStyle: TextStyle(fontSize: 15)),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: instructionsController,
                                decoration: const InputDecoration(
                                    hintText: 'Take before meals',
                                    labelText: 'Instructions',
                                    labelStyle: TextStyle(fontSize: 15)),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: startDateController,
                                decoration: const InputDecoration(
                                    labelText: 'Start Date',
                                    labelStyle: TextStyle(fontSize: 15)),
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime.now()
                                          .subtract(new Duration(days: 365)),
                                      maxTime: DateTime(2022, 12, 31),
                                      onChanged: (date) {}, onConfirm: (date) {
                                    confirmedStartDate = date.toString();
                                    print(
                                        "confirmedStartDate on selection is $confirmedStartDate");
                                    startDateController.text =
                                        date.day.toString() +
                                            "/" +
                                            date.month.toString() +
                                            "/" +
                                            date.year.toString();
                                  }, currentTime: DateTime.now());
                                },
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: endDateController,
                                decoration: const InputDecoration(
                                    labelText: 'End Date',
                                    labelStyle: TextStyle(fontSize: 15)),
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime.now()
                                          .subtract(new Duration(days: 365)),
                                      maxTime: DateTime(2022, 12, 31),
                                      onChanged: (date) {}, onConfirm: (date) {
                                    confirmedEndDate = date.toString();
                                    endDateController.text =
                                        date.day.toString() +
                                            "/" +
                                            date.month.toString() +
                                            "/" +
                                            date.year.toString();
                                  }, currentTime: DateTime.now());
                                },
                              ),
                            ),
                            Flexible(
                                child: RaisedButton(
                                    child: Text("Submit"),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        addPrescription(confirmedStartDate,
                                            confirmedEndDate);
                                      }
                                    })),
                          ])));
            },
          );
        },
        tooltip: 'Add New Prescription',
        child: const Icon(Icons.add),
      ),
    );
  }
}
