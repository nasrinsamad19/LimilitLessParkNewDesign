import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/api/api.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:limitlesspark_new/screens/login/view/reset_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailEnterUI extends StatefulWidget {
  const EmailEnterUI({Key? key}) : super(key: key);

  @override
  _EmailEnterUIState createState() => _EmailEnterUIState();
}

class _EmailEnterUIState extends State<EmailEnterUI> {
  @override
  void initState() {
    super.initState();
  }

  @override
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

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
                    style: TextStyle(color: Colors.white, fontSize: 19.0),
                  ),
                ],
              ))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [loginForm(context)],
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
                      otpVerify();
                    }
                  },
                  child: Center(
                    child:
                        Text('Submit', style: TextStyle(color: Colors.white)),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginForm(BuildContext context) {
    return new Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(50, 0, 50, 30),
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text('Email',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                )),
          ),
          Container(
            height: 50,
            child: TextFormField(
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintText: 'Type your email here',
                hintStyle: TextStyle(color: Colors.black, fontSize: 10.0),
              ),
              style: TextStyle(color: Colors.black, fontSize: 12.0),
              controller: emailController,
              validator: (val) {
                Pattern pattern =
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                RegExp regex = RegExp(pattern.toString());
                if (val!.isEmpty) {
                  return 'Please enter email';
                }
              },
              //  onSaved: (input) => loginRequestModel.email = input.toString(),
            ),
          ),
        ],
      ),
    );
  }

  otpVerify() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('passwordEmail', emailController.text);
    var data = {"email": emailController.text, "reason": "password_reset"};

    CallApi().getOtp(data, 'users/get-otp/').then((value) async {
      if (value == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResetPassword(
                    email: emailController.text,
                  )),
        );
      } else {
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
}
