import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/api/api.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:limitlesspark_new/screens/guide/option_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  void initState() {
    super.initState();
    // Firebase.initializeApp().whenComplete(() {
    //   print("completed");
    //   setState(() {});
    // });
  }

  @override
  final _formKey = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;

  // 4 text editing controllers that associate with the 4 input fields
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController correctPasswordController =
      TextEditingController();

  String? validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern.toString());
    if (value.isEmpty) {
      return 'Please enter Password';
    } else if (value.length < 8) {
      return "Password must contain at least eight characters";
    } else if (!regex.hasMatch(value)) {
      return 'Password must contain uppercase and lowercase \n letters, numbers and special characters.';
    } else
      return null;
  }

  String? validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Please enter Password';
    } else if (passwordController.text != value) {
      return "Enter correct password";
    } else
      return null;
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorNames().darkBlue,
          toolbarHeight: 70,
          title: Container(
              alignment: Alignment.center,
              color: ColorNames().darkBlue,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/limitless_logo.png',
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    'Limitless Parking'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19.0,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [signUpForm(context)],
        ),
      ),
      bottomNavigationBar: Container(
        child: Container(
          height: height / 10,
          width: width / 2,
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
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      resetPassword();
                    }
                  },
                  child: Center(
                    child: Text('Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        )),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  resetPassword() async {
    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('passwordEmail');
    var otp = prefs.getString('otp');

    var data = {
      "email": email,
      "otp_token": otp,
      "new_password": correctPasswordController.text
    };

    CallApi()
        .emailVerification(data, 'users/reset-password')
        .then((value) async {
      if (value == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OptionScreen()),
        );
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var content = prefs.getString('emailVerror');
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialog(context, content),
        );
      }
    });
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

  Widget signUpForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Text('Enter New Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                  )),
            ),
            Container(
              height: 50,
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: 'Type your password here ',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10.0,
                    fontFamily: 'Roboto',
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontFamily: 'Roboto',
                ),
                controller: passwordController,
                validator: (val) => validatePassword(val.toString()),
                //onSaved: (val) => password = val.toString(),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Text('Confirm New Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                  )),
            ),
            Container(
              height: 50,
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: 'Confirm your password here',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10.0,
                    fontFamily: 'Roboto',
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontFamily: 'Roboto',
                ),
                controller: correctPasswordController,
                validator: (val) => validateConfirmPassword(val.toString()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
