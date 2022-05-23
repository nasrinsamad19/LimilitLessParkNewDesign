import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:limitlesspark_new/screens/api/api.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:limitlesspark_new/screens/guide/option_screen.dart';
import 'package:limitlesspark_new/screens/profile/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class BookNow extends StatefulWidget {
  const BookNow({Key? key}) : super(key: key);

  @override
  BookNowState createState() => BookNowState();
}

class BookNowState extends State<BookNow> {
  TextEditingController dateinputarrival = TextEditingController();
  TextEditingController dateinputDeparture = TextEditingController();
  TextEditingController _timecontroler = TextEditingController();
  var _selectedDay = DateTime.now();
  var _focusedDay;
  double _startValue = 1.0;
  double _endValue = 5.0;
  double val = 1;

  //String _selectedDate1=DateFormat("yyyy-MM-ddTHH:mm:ss").add_jm().format(DateTime.now());
  //String _selectedDate1=DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now().t);
  //String _selectedDate1 = DateTime.now().toString();

  var car1Id;
  var car2Id;
  final _formKey = GlobalKey<FormState>();
  TimeOfDay selectedTime2 = TimeOfDay.now();
  TimeOfDay selectedTime =
      TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
  DateTime _selectedDate1 = DateTime.now();
  DateTime _selectedDate2 = DateTime.now();
  var oldArrivalTime;
  var oldDTime;

  Future<void> _selectDate1(BuildContext context) async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2032),
    );
    if (d != null)
      setState(() {
        dateinputDeparture.text = new DateFormat("yyyy-MM-dd").format(d);
      });
  }

  _selectTime1(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2032),
    );
    if (d != null)
      setState(() {
        dateinputarrival.text = new DateFormat("yyyy-MM-dd").format(d);
      });
  }

  _selectTime2(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime2,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime2) {
      setState(() {
        selectedTime2 = timeOfDay;
      });
    }
  }

  String? dropdownvalue;

  // List of items in our dropdown menu
  var items = [];

  getCarList() async {
    CallApi().checkReservation().then((value) async {
      if (value.active == false) {
        setState(() {
          cancel = false;
        });
        print('false cancel');
        var futureData = CallApi().fetchprofile();
        print(futureData.then((value) {
          // var car1 = value!.cars.first;
          // var car2 = value!.cars.last;
          // if (value.cars.first != value!.cars.last) {
          //   setState(() {
          //     items = [car1.toString(), car2.toString()];
          //   });
          // } else {
          //   setState(() {
          //     items = [car1.toString()];
          //   });
          // }
          // print(items);
        }));
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print(cancel);
        setState(() {
          print(value.data);
          DateTime dtA = DateTime.parse(value.data.arrival.toString());
          dateinputarrival.text = DateFormat("yyyy-MM-dd").format(dtA);
          DateTime dtD = DateTime.parse(value.data.departure.toString());
          dateinputDeparture.text = DateFormat("yyyy-MM-dd").format(dtD);
          print(dtA);
          oldArrivalTime = DateFormat("hh:mm a").format(dtA);
          oldDTime = DateFormat("hh:mm a").format(dtD);
          print(oldArrivalTime);
          print(oldDTime);
          dropdownvalue = value.data.licensePlate;
          items = [value.data.licensePlate];
          cancel = true;
        });
      }
    });
  }

  late Future<Profile> futureData;
  bool cancel = false;

  @override
  void initState() {
    // TODO: implement initState
    dateinputarrival.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dateinputDeparture.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
    getCarList();
    // Timer mytimer = Timer.periodic(Duration(seconds: 2), (timer) {
    //   if (mounted) {
    //     getCarList();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          elevation: 0.0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: ColorNames().blue,
              size: 15,
            ),
          ),
          title: Container(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 70,
                    height: 70,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Limitless Parking'.toUpperCase(),
                    style: TextStyle(
                      color: ColorNames().blue,
                      fontSize: 15.0,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ))),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('Select Date & Time',
                  style: TextStyle(
                    color: ColorNames().blue,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ]),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _selectedDay,
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: ColorNames().blue,
                    shape: BoxShape.circle,
                    //borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: !cancel
                    ? (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay =
                              focusedDay; // update `_focusedDay` here as well
                        });
                        print(_selectedDay);
                        print(_focusedDay);
                      }
                    : null,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 0),
              child: Text('Duration',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                  )),
            ),
            Slider(
              min: 0.0,
              max: 6.0,
              divisions: 6,
              value: val,
              inactiveColor: ColorNames().blue,
              activeColor: ColorNames().blue,
              label: val.round().toString() + 'Hrs',
              onChanged: !cancel
                  ? (value) {
                      setState(() {
                        val = value;
                        print(val);
                        print(selectedTime2);
                        selectedTime = TimeOfDay.fromDateTime(
                            DateTime.now().add(Duration(hours: val.toInt())));
                      });
                    }
                  : null,
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Time',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Roboto',
                          )),
                      Container(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: ColorNames().blue),
                          ),
                        ),
                        height: 40,
                        child: Row(
                          children: [
                            !cancel
                                ? Text(
                                    selectedTime2.format(context),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Roboto',
                                    ),
                                  )
                                : Text(
                                    oldArrivalTime.toString(),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                            IconButton(
                              icon: !cancel
                                  ? Icon(
                                      Icons.access_time,
                                    )
                                  : Icon(
                                      Icons.access_time,
                                      color: Colors.grey,
                                    ),
                              tooltip: 'Tap to open date picker',
                              onPressed: () {
                                !cancel ? _selectTime2(context) : null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('End Time',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Roboto',
                          )),
                      Container(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: ColorNames().blue),
                          ),
                        ),
                        height: 40,
                        child: Row(
                          children: [
                            !cancel
                                ? Text(
                                    selectedTime.format(context),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Roboto',
                                    ),
                                  )
                                : Text(
                                    oldDTime,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                            IconButton(
                              icon: !cancel
                                  ? Icon(Icons.access_time)
                                  : Icon(
                                      Icons.access_time,
                                      color: Colors.grey,
                                    ),
                              tooltip: 'Tap to open date picker',
                              onPressed: () {
                                //!cancel ? _selectTime1(context) : null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      // body: SingleChildScrollView(
      //   padding: EdgeInsets.only(left: 40, right: 40, top: 30),
      //   child: Column(
      //     children: [
      //       !cancel
      //           ? Text('')
      //           : Padding(
      //               padding: EdgeInsets.only(top: 10, bottom: 20),
      //               child: Text(
      //                 'Reservation Details'.toUpperCase(),
      //                 style: TextStyle(
      //                     color: Colors.black,
      //                     fontSize: 20,
      //                     fontWeight: FontWeight.bold,
      //                     fontFamily: 'Roboto',),
      //               ),
      //             ),
      //       signUpForm(context),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: cancel
          ? Container(
              height: 50,
              width: width / 1.5,
              padding: EdgeInsets.fromLTRB(50, 0, 50, 20),
              child: Container(
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //     colors: [Colors.blue, ColorNames().lightBlue]),
                  color: ColorNames().darkBlue,
                  boxShadow: [],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var license_plate = prefs.getString('selectedCar');

                        var data = {"license_plate": license_plate};
                        CallApi()
                            .postCancel(data, 'reservations/cancel/')
                            .then((value) async {
                          if (value == 200) {
                            getCarList();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(
                                      context, 'Cancellation on process'),
                            );
                          } else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var content = prefs.getString('error');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(context, content),
                            );
                          }
                        });
                      },
                      child: Center(
                        child: Text('CANCEL BOOKING',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            )),
                      )),
                ),
              ),
            )
          : Container(
              height: 50,
              width: width / 1.5,
              padding: EdgeInsets.fromLTRB(50, 0, 50, 20),
              child: Container(
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //     colors: [Colors.blue, ColorNames().lightBlue]),
                  color: ColorNames().darkBlue,
                  boxShadow: [],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        if (_selectedDay != null) {
                          validate();
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(context, 'Select Date'),
                          );
                        }
                      },
                      child: Center(
                        child: Text('BOOK NOW',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            )),
                      )),
                ),
              ),
            ),
    );
  }

  validate() {
    double dTime = selectedTime.hour + selectedTime.minute / 60.0;
    TimeOfDay currentTime = TimeOfDay.now();
    print(currentTime);
    double aTime = selectedTime2.hour + selectedTime2.minute / 60.0;
    double cTime = currentTime.hour + currentTime.minute / 60.0;
    var diff = aTime - dTime;
    var buffer = aTime - cTime;
    // print(aTime);
    // print(cTime);
    // print(dTime);
    // print(buffer);
    // print('diff');
    // print(aTime>cTime);
    if (aTime < cTime) {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            _buildPopupDialog(context, 'Arrival time expired'),
      );
    } else {
      if (diff >= 1.0) {
        getCarList();
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialog(context, 'Minimum 1 hour rservation required'),
        );
        print('sucees');
      } else {
        _bookNow();
      }
    }
  }

  _bookNow() async {
    // var arrival= DateFormat("yyyy-MM-ddTHH:mm:ss").parse(dateinputarrival.text).toIso8601String();
    //var departure= DateFormat().parse(dateinputDeparture.text).toIso8601String();

    print(selectedTime);
    var date = selectedTime.format(context);
    print(date);
    DateTime date2 = DateFormat.jm().parse(date);
    print(date2.toString() + ';;');
    var fdate = date2.toString().split(" ").elementAt(1);
    print(dateinputarrival.text);
    print(_selectedDay.toString().split(" ").elementAt(0));
    var finalDate = DateTime.parse(
            _selectedDay.toString().split(" ").elementAt(0) + ' ' + fdate)
        .toIso8601String();
    print(finalDate);
    print(date2);

    print(selectedTime2);
    var adate = selectedTime2.format(context);
    print(date);
    DateTime adate2 = DateFormat.jm().parse(adate);
    var ardate = adate2.toString().split(" ").elementAt(1);
    var finalADate = DateTime.parse(
            _selectedDay.toString().split(" ").elementAt(0) + ' ' + ardate)
        .toIso8601String();
    print(finalADate);
    print(finalDate);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var car_license_plate = prefs.getString('selectedCar');
    var site = prefs.getString('site');
    var state = prefs.getString('state');

    var data = {
      "license_plate": car_license_plate,
      "arrival": finalADate,
      "departure": finalDate,
      "state": state,
      "site": site
    };
    print(data);
    CallApi().postBookNow(data, 'reservations/create/').then((value) {
      if (value == true) {
        getCarList();
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialog(context, 'reservation on process'),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OptionScreen()),
        );
        print('sucees');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialog(context, value.toString()),
        );
        print('errorrr');
      }
    });
  }

  Widget _buildPopupDialog(BuildContext context, value) {
    return new AlertDialog(
      title: const Text('Message'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$value'),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
