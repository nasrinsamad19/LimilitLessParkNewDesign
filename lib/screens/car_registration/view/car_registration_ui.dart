import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:limitlesspark_new/main.dart';
import 'package:limitlesspark_new/screens/api/api.dart';
import 'package:limitlesspark_new/screens/car_registration/model/model.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:limitlesspark_new/screens/guide/option_screen.dart';
import 'package:limitlesspark_new/screens/login/view/reset_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarRegistartionUi extends StatefulWidget {
  const CarRegistartionUi({Key? key}) : super(key: key);

  @override
  _CarRegistartionUiState createState() => _CarRegistartionUiState();
}

class _CarRegistartionUiState extends State<CarRegistartionUi> {
  TextEditingController car1Controller = TextEditingController();
  TextEditingController car2Controller = TextEditingController();
  TextEditingController v1Controller = TextEditingController();
  TextEditingController v2Controller = TextEditingController();

  var platform;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  String selectedEmiratesValue = "Dubai";
  String selectedCategoryValue = "Private";
  String selectedPlateValue = 'A';
  String selectedEmiratesValue2 = "Dubai";
  String selectedCategoryValue2 = "Private";
  String selectedPlateValue2 = 'A';
  bool addMore = false;

  TextEditingController plateNoController = TextEditingController();

  List<DropdownMenuItem<String>> get dropdownEmiratesItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Dubai"), value: "Dubai"),
      DropdownMenuItem(child: Text("Abu Dhabi"), value: "Abu_Dhabi"),
      DropdownMenuItem(child: Text("Sharjah"), value: "Sharjah"),
      DropdownMenuItem(child: Text("Ajman"), value: "Ajman"),
      DropdownMenuItem(child: Text("Umm Al Quwain"), value: "Umm_Al_Quwain"),
      DropdownMenuItem(child: Text("Ras Al Khaimah"), value: "Ras_Al_Khaimah"),
      DropdownMenuItem(child: Text("Fujairah"), value: "Fujairah"),
    ];
    return menuItems;
  }

  List<String> abu_Dhabi = [
    '1',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '50'
  ];

  List<String> dubai = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    'AA'
  ];
  List<String> ajman = ['A', 'B', 'C', 'D', 'E', 'H'];
  List<String> Fujairah = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'K',
    'M',
    'P',
    'R',
    'S',
    'T'
  ];
  List<String> Ras_Al_Khaimah = [
    'A',
    'C',
    'D',
    'I',
    'K',
    'M',
    'N',
    'S',
    'V',
    'Y'
  ];
  List<String> Sharjah = [
    '1',
    '2',
    '3',
  ];
  List<String> Umm_al_Quwain = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H' 'I',
    'X'
  ];

  List<DropdownMenuItem<String>> get dropdownCategoryItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Private"), value: "Private"),
    ];
    return menuItems;
  }

  newToken() {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      final prefs = await SharedPreferences.getInstance();
      var currentToken = prefs.getString('token');
      if (currentToken != token) {
        print('token refresh: ' + token);
        // add code here to do something with the updated token
        await prefs.setString('token', token);
      }
    });
  }

  _registerCar() async {
    print('here');
    if (Platform.isAndroid) {
      platform = "android";
    } else if (Platform.isIOS) {
      platform = "ios";
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('car1', car1Controller.text);
    await prefs.setString('car2', car2Controller.text);

    var rtoken = prefs.getString('token');
    var car1 = selectedPlateValue + car1Controller.text;
    print(car1);
    print(car2Controller.text);
    var car2 = selectedPlateValue2 + car2Controller.text;
    print(car2);
    var name = prefs.getString('name');
    var email = prefs.getString('email');
    var password = prefs.getString('password');

    var data = car2Controller.text.isEmpty
        ? {
            "full_name": name,
            "email": email,
            "password": password,
            "cars": [
              {"license_plate": car1, "state": selectedEmiratesValue},
            ],
            "registration_token": rtoken,
            "device_type": platform
          }
        : {
            "full_name": name,
            "email": email,
            "password": password,
            "cars": [
              {"license_plate": car1, "state": selectedEmiratesValue},
              {"license_plate": car2, "state": selectedEmiratesValue2}
            ],
            "registration_token": rtoken,
            "device_type": platform
          };
    print(data);

    CallApi().register(data, 'users/signup/').then((value) async {
      setState(() {
        _isLoading = true;
      });
      if (value == 201) {
        setState(() {
          _isLoading = false;
        });
        otpVerify();
      } else if (value == 200) {
        setState(() {
          _isLoading = false;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('carno', car1.toString());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OptionScreen()),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var content = prefs.getString('error');
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialog(context, content),
        );
      }
    });
  }

  List dataList = [];
  List<state> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CallApi().fetchstates().then((value) {
      setState(() {
        print(value);
        //dataList= value.states;
        print(dataList);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Add your car'.toUpperCase(),
          style: TextStyle(
            color: ColorNames().blue,
            fontSize: 15.0,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.only(bottom: 20),
          height: height,
          width: width,
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/infy.gif'),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 150,
                          height: 100,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Vehicle details'.toUpperCase(),
                          style: TextStyle(
                            color: ColorNames().blue,
                            fontSize: 20.0,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      signUpForm(context),
                      SizedBox(
                        height: 20,
                      ),
                      !addMore
                          ? GestureDetector(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/add.png',
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'Add more vehicle',
                                    style: TextStyle(
                                      color: ColorNames().blue,
                                      fontSize: 12.0,
                                      fontFamily: 'Roboto',
                                    ),
                                  )
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  addMore = true;
                                  print(addMore);
                                });
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      addMore ? signUpForm2(context) : Container(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: height / 12,
                          width: width / 1.6,
                          padding: EdgeInsets.fromLTRB(50, 0, 50, 20),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: ColorNames().blue),
                                borderRadius: BorderRadius.circular(20),
                                color: ColorNames().blue),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () async {
                                    if (car1Controller.text.isNotEmpty) {
                                      MyAppState().getToken();
                                      _registerCar();
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialog(
                                                context, 'Enter plate Number'),
                                      );
                                    }
                                    // setcar();
                                  },
                                  child: Center(
                                    child: Text('Add',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                        )),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  Widget _buildPopupDialog(BuildContext context, value) {
    return new AlertDialog(
      title: const Text('Error'),
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

  sub() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var subscribed = prefs.getStringList('subscribed');
    var car1 = prefs.getString('car1');
    var car2 = prefs.getString('car2');

    List topics = [
      car1,
      car2,
    ];
    if (car1!.isNotEmpty) {
      await FirebaseMessaging.instance.subscribeToTopic(topics[0]);

      await FirebaseFirestore.instance
          .collection('topics')
          .doc(token)
          .set({topics[0]: 'subscribe'}, SetOptions(merge: true));
      setState(() {
        subscribed?.add(topics[0]);
      });
    }
    if (car2!.isNotEmpty) {
      await FirebaseMessaging.instance.subscribeToTopic(topics[1]);
      await FirebaseFirestore.instance
          .collection('topics')
          .doc(token)
          .set({topics[1]: 'subscribe'}, SetOptions(merge: true));
      setState(() {
        subscribed?.add(topics[1]);
      });
    }
  }

  otpVerify() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    print(email);
    var data = {"email": email, "reason": "account_activation"};

    CallApi().getOtp(data, 'users/get-otp/').then((value) async {
      if (value == 200) {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResetPassword(
                    email: 'null',
                  )),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var content = prefs.getString('getOtpError');
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialog(context, content),
        );
      }
    });
  }

  Widget signUpForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),
            Text(
              'Vehicle Name',
              style: TextStyle(
                color: ColorNames().blue,
                fontSize: 12.0,
                fontFamily: 'Roboto',
              ),
            ),
            Container(
              height: 50,
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorNames().blue),
                  ),
                  counterText: "",
                  hintText: 'Type here',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10.0,
                    fontFamily: 'Roboto',
                  ),
                ),
                style: TextStyle(
                  color: ColorNames().blue,
                  fontSize: 12.0,
                  fontFamily: 'Roboto',
                ),
                controller: v1Controller,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please enter vehicle name';
                  }
                },
                //onSaved: (val) => fname = val.toString(),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Emirates',
              style: TextStyle(
                color: ColorNames().blue,
                fontSize: 12.0,
                fontFamily: 'Roboto',
              ),
            ),
            DropdownButtonFormField(
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontFamily: 'Roboto',
              ),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorNames().blue),
                ),
              ),
              //dropdownColor: Colors.blueAccent,
              value: selectedEmiratesValue,
              onChanged: (String? newValue) {
                setState(() {
                  selectedEmiratesValue = newValue!;
                  if (selectedEmiratesValue == 'Abu_Dhabi' ||
                      selectedEmiratesValue == 'Sharjah') {
                    selectedPlateValue = '1';
                  }
                });
                print(selectedEmiratesValue);
              },
              items: dropdownEmiratesItems,
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Plate Category',
              style: TextStyle(
                color: ColorNames().blue,
                fontSize: 12.0,
                fontFamily: 'Roboto',
              ),
            ),
            DropdownButtonFormField(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontFamily: 'Roboto',
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorNames().blue),
                  ),
                  hintText: 'Enter your first name here',
                  hintStyle: TextStyle(
                    color: ColorNames().blue,
                    fontSize: 12.0,
                    fontFamily: 'Roboto',
                  ),
                ),
                //dropdownColor: Colors.blueAccent,
                value: selectedCategoryValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategoryValue = newValue!;
                  });
                },
                items: dropdownCategoryItems),
            SizedBox(
              height: 25,
            ),
            Text(
              'Plate Code',
              style: TextStyle(
                color: ColorNames().blue,
                fontSize: 12.0,
                fontFamily: 'Roboto',
              ),
            ),
            DropdownButton(
              itemHeight: 50,
              isExpanded: false,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontFamily: 'Roboto',
              ),
              underline: Container(
                height: 1,
                color: ColorNames().blue,
              ),
              // decoration: InputDecoration(
              //   enabledBorder: UnderlineInputBorder(
              //     borderSide: BorderSide(color: ColorNames().blue),
              //   ),
              //   hintText: 'select option',
              //   hintStyle: TextStyle(color: ColorNames().blue, fontSize: 12.0),
              // ),
              //dropdownColor: Colors.blueAccent,
              value: selectedPlateValue,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPlateValue = newValue!;
                });
              },
              items: selectedEmiratesValue == 'Dubai'
                  ? dubai.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  : selectedEmiratesValue == 'Abu_Dhabi'
                      ? abu_Dhabi.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()
                      : selectedEmiratesValue == 'Sharjah'
                          ? Sharjah.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()
                          : selectedEmiratesValue == 'Ajman'
                              ? ajman.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList()
                              : selectedEmiratesValue == 'Umm_Al_Quwain'
                                  ? Umm_al_Quwain.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList()
                                  : selectedEmiratesValue == 'Ras_Al_Khaimah'
                                      ? Ras_Al_Khaimah.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList()
                                      : Fujairah.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Plate Number',
              style: TextStyle(
                color: ColorNames().blue,
                fontSize: 12.0,
                fontFamily: 'Roboto',
              ),
            ),
            Container(
              height: 50,
              child: TextFormField(
                maxLength: 5,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorNames().blue),
                  ),
                  counterText: "",
                  hintText: 'Enter your plate number here',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10.0,
                    fontFamily: 'Roboto',
                  ),
                ),
                style: TextStyle(
                  color: ColorNames().blue,
                  fontSize: 12.0,
                  fontFamily: 'Roboto',
                ),
                controller: car1Controller,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please plate number';
                  } else if (val.length < 6) {
                    return 'maximum entry is 5 numbers';
                  }
                },
                //onSaved: (val) => fname = val.toString(),
              ),
            ),
          ],
        ));
  }

  Widget signUpForm2(BuildContext context) {
    return Form(
        key: _formKey2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Second vehicle details',
              style: TextStyle(
                color: ColorNames().blue,
                fontSize: 20.0,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Vehicle Name',
              style: TextStyle(
                color: ColorNames().blue,
                fontSize: 12.0,
                fontFamily: 'Roboto',
              ),
            ),
            Container(
              height: 50,
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorNames().blue),
                  ),
                  counterText: "",
                  hintText: 'Type here',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10.0,
                    fontFamily: 'Roboto',
                  ),
                ),
                style: TextStyle(
                  color: ColorNames().blue,
                  fontSize: 12.0,
                  fontFamily: 'Roboto',
                ),
                controller: v2Controller,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please enter vehicle name';
                  }
                },
                //onSaved: (val) => fname = val.toString(),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Emirates',
              style: TextStyle(
                color: ColorNames().blue,
                fontSize: 12.0,
                fontFamily: 'Roboto',
              ),
            ),
            DropdownButtonFormField(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontFamily: 'Roboto',
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorNames().blue),
                  ),
                  hintText: 'Enter your first name here',
                  hintStyle: TextStyle(
                    color: ColorNames().blue,
                    fontSize: 12.0,
                    fontFamily: 'Roboto',
                  ),
                ),
                //dropdownColor: Colors.blueAccent,
                value: selectedEmiratesValue2,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedEmiratesValue2 = newValue!;
                    if (selectedEmiratesValue2 == 'Abu_Dhabi' ||
                        selectedEmiratesValue2 == 'Sharjah') {
                      selectedPlateValue2 = '1';
                    }
                  });
                  print(selectedEmiratesValue2);
                },
                items: dropdownEmiratesItems),
            SizedBox(
              height: 25,
            ),
            Text(
              'Plate Category',
              style: TextStyle(
                color: ColorNames().blue,
                fontSize: 12.0,
                fontFamily: 'Roboto',
              ),
            ),
            DropdownButtonFormField(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontFamily: 'Roboto',
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorNames().blue),
                  ),
                  hintText: 'Enter your first name here',
                  hintStyle: TextStyle(
                    color: ColorNames().blue,
                    fontSize: 12.0,
                    fontFamily: 'Roboto',
                  ),
                ),
                //dropdownColor: Colors.blueAccent,
                value: selectedCategoryValue2,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategoryValue2 = newValue!;
                  });
                },
                items: dropdownCategoryItems),
            SizedBox(
              height: 25,
            ),
            Text(
              'Plate Code',
              style: TextStyle(
                color: ColorNames().blue,
                fontSize: 12.0,
                fontFamily: 'Roboto',
              ),
            ),
            DropdownButton(
              itemHeight: 50,
              isExpanded: false,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontFamily: 'Roboto',
              ),
              underline: Container(
                height: 1,
                color: ColorNames().blue,
              ),
              value: selectedPlateValue2,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPlateValue2 = newValue!;
                });
              },
              items: selectedEmiratesValue2 == 'Dubai'
                  ? dubai.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  : selectedEmiratesValue == 'Abu_Dhabi'
                      ? abu_Dhabi.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()
                      : selectedEmiratesValue == 'Sharjah'
                          ? Sharjah.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()
                          : selectedEmiratesValue == 'Ajman'
                              ? ajman.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList()
                              : selectedEmiratesValue == 'Umm_Al_Quwain'
                                  ? Umm_al_Quwain.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList()
                                  : selectedEmiratesValue == 'Ras_Al_Khaimah'
                                      ? Ras_Al_Khaimah.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList()
                                      : Fujairah.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Plate Number',
              style: TextStyle(
                color: ColorNames().blue,
                fontSize: 12.0,
                fontFamily: 'Roboto',
              ),
            ),
            Container(
              height: 50,
              child: TextFormField(
                maxLength: 5,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorNames().blue),
                  ),
                  counterText: "",
                  hintText: 'Enter your plate number here',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10.0,
                    fontFamily: 'Roboto',
                  ),
                ),
                style: TextStyle(
                  color: ColorNames().blue,
                  fontSize: 12.0,
                  fontFamily: 'Roboto',
                ),
                controller: car2Controller,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please plate number';
                  } else if (val.length < 6) {
                    return 'maximum entry is 5 numbers';
                  }
                },
                //onSaved: (val) => fname = val.toString(),
              ),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ));
  }
}
