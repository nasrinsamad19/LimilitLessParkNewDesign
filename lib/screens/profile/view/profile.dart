import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/api/api.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:limitlesspark_new/screens/guide/welcome_screen.dart';
import 'package:limitlesspark_new/screens/login/view/intro_ui.dart';
import 'package:limitlesspark_new/screens/profile/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileUI> {
  TextEditingController emailController = TextEditingController();
  TextEditingController car1 = TextEditingController();
  TextEditingController car2 = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController palteNoController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool emailc = false;
  bool fnamec = false;
  bool car1Chaged = false;
  bool car2Chaged = false;
  Profile? futureAlbum;
  var token;
  var email;
  var fname;
  var cars = [];
  bool _isFirstLoadRunning = false;

  late Future<Profile> futureData;

  @override
  void initState() {
    // TODO: implement initState
    //fetchdata();
    setState(() {
      _isFirstLoadRunning = true;
    });
    super.initState();
    var futureData = CallApi().fetchprofile().then((value) {
      setState(() {
        _isFirstLoadRunning = false;
      });
      emailController.text = value.email;
      fnameController.text = value.fullName;
      cars = value.cars;
      print(cars.first.state);

      // car1.text = cars.first.licensePlate;
      // if (value.cars.first.licensePlate != value.cars.last.licensePlate) {
      //   car2.text = value!.cars.last.licensePlate;
      // }
    });
  }

  // fetchdata() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   fnameController.text = prefs.getString('firstName')!;
  //   lnameController.text = prefs.getString('lastName')!;
  //   emailController.text = prefs.getString('email')!;
  //   car1.text = prefs.getString('car1')!;
  //   car2.text = prefs.getString('car2')!;
  // }

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
      body: _isFirstLoadRunning
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/infy.gif'),
                  // CircularProgressIndicator()
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.only(left: 40, right: 40, top: 30),
              child: Column(
                children: [
                  signUpForm(context),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        decoration: new BoxDecoration(
            color: ColorNames().offwhite,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(80.0),
              topRight: const Radius.circular(80.0),
            )),
        padding: EdgeInsets.fromLTRB(100, 40, 100, 40),
        child: Container(
          height: height / 19,
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [ColorNames().blue, ColorNames().blue]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _profileUpdate();
                  }
                },
                child: Center(
                  child: Text('UPDATE',
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

  Widget signUpForm(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                //border: Border.all(color: ColorNames().blue),
                borderRadius: BorderRadius.circular(20),
                color: ColorNames().offwhite,
              ),
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              child: TextFormField(
                style: TextStyle(
                  color: ColorNames().blue,
                  fontSize: 14.0,
                  fontFamily: 'Roboto',
                ),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  hintText: token,
                  hintStyle: TextStyle(
                    color: ColorNames().lightgrey,
                    fontSize: 14.0,
                    fontFamily: 'Roboto',
                  ),
                ),
                controller: fnameController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please enter Name';
                  } else if (val.contains(RegExp(r'[0-9]'))) {
                    return 'Please check your entry';
                  }
                },
                onChanged: (val) {
                  setState(() {
                    fname = true;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                //border: Border.all(color: ColorNames().blue),
                borderRadius: BorderRadius.circular(20),
                color: ColorNames().offwhite,
              ),
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  hintText: 'Client email',
                  hintStyle: TextStyle(
                    color: ColorNames().lightgrey,
                    fontSize: 14.0,
                    fontFamily: 'Roboto',
                  ),
                ),
                style: TextStyle(
                  color: ColorNames().blue,
                  fontSize: 14.0,
                  fontFamily: 'Roboto',
                ),
                controller: emailController,
                validator: (val) {
                  Pattern pattern =
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                  RegExp regex = RegExp(pattern.toString());
                  if (val!.isEmpty) {
                    return 'Please enter email';
                  } else {
                    if (!regex.hasMatch(val)) {
                      return 'Invalid Email';
                    }
                  }
                },
                onChanged: (val) {
                  setState(() {
                    email = true;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _signOut();
              },
              child: Container(
                  height: 40,
                  width: width,
                  decoration: BoxDecoration(
                    //border: Border.all(color: ColorNames().blue),
                    borderRadius: BorderRadius.circular(20),
                    color: ColorNames().offwhite,
                  ),
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      _signOut();
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: ColorNames().blue,
                        fontSize: 14.0,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  _profileUpdate() async {
    var data = {
      "full_name": fnameController.text,
      "email": emailController.text,
      "cars": cars
      //"cars": car2.text!.isNotEmpty ? [car1.text, car2.text] : [car1.text]
    };

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

  _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('alreadyloggedin');
    prefs.remove('access');
    prefs.remove('name');
    prefs.remove('Titles');
    // await FirebaseMessaging.instance.deleteToken();
    //await FirebaseMessaging.instance.app.delete();

    CallApi().logout().then((value) {
      if (value == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IntroScreen()),
        );
        print('sucees');
      } else {
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) => _buildPopUp(context)
        //
        // );
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
