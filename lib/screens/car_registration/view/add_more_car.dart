import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/api/api.dart';
import 'package:limitlesspark_new/screens/car_registration/model/model.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMoreCar extends StatefulWidget {
  const AddMoreCar({Key? key}) : super(key: key);

  @override
  _AddMoreCarState createState() => _AddMoreCarState();
}

class _AddMoreCarState extends State<AddMoreCar> {
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
  late List<DropdownMenuItem<States>> _dropdownMenuItems;

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

  var email;
  var name;
  var car;
  var dataList;

  @override
  void initState() {
    // TODO: implement initState
    //fetchdata();

    super.initState();
    CallApi().fetchstates().then((value) {
      setState(() {
        print(value.states);
        dataList = value.states;
        print(dataList[0].stateName);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
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
                            _update();
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
      ),
    );
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
              //    items: dataList.map<String>((item) => DropdownMenuItem<String>(
              //        value:item['state_name'],
              //        child: Text(item['state_name'].toString()
              //    )
              //    )
              //    )
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
              ),
            ),
          ],
        ));
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

  _update() async {
    var car1 = selectedPlateValue + car1Controller.text;
    var data = {
      "full_name": name,
      "email": email,
      "cars": [
        {"license_plate": car1, "state": selectedEmiratesValue},
      ],
      //"cars": car2.text!.isNotEmpty ? [car1.text, car2.text] : [car1.text]
    };
    print(data);

    CallApi().postUpdateProfile(data, 'users/update/').then((value) async {
      if (value == 200) {
        var content = 'updated';
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialog(context, content),
        );
      } else {
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
}
