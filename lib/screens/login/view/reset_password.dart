import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/api/api.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:limitlesspark_new/screens/guide/option_screen.dart';
import 'package:limitlesspark_new/screens/login/view/passwordChnage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  final String email;

  const ResetPassword({Key? key, required this.email}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  void initState() {
    super.initState();
    // Firebase.initializeApp().whenComplete(() {
    //   print("completed");
    //   setState(() {});
    // });
  }

  @override
  TextEditingController emailController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  final auth = FirebaseAuth.instance;

  // 4 text editing controllers that associate with the 4 input fields
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  // This is the entered code
  // It will be displayed in a Text widget
  String? _otp;

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
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
          'Register your account'.toUpperCase(),
          style: TextStyle(color: ColorNames().blue, fontSize: 15.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 100,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Align(
              child: Text(
                'Thanks for registring in the limiltess park app'.toUpperCase(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Please verify your account',
              style: TextStyle(
                  color: ColorNames().darkBlue,
                  //fontWeight: FontWeight.bold,
                  fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Enter the code we sent to your register email address',
              style: TextStyle(
                  color: Colors.black,
                  //fontWeight: FontWeight.bold,
                  fontSize: 19.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OtpInput(_fieldOne, true),
                OtpInput(_fieldTwo, false),
                OtpInput(_fieldThree, false),
                OtpInput(_fieldFour, false),
                OtpInput(_fieldFive, false),
                OtpInput(_fieldSix, false)
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                child: Text(
                  'Resent OTP?',
                  style: TextStyle(color: Colors.black, fontSize: 11.0),
                ),
                onTap: () {
                  if (widget.email.contains('null')) {
                    print('null');
                    otpVerify();
                  } else if (widget.email.contains('loginEmail')) {
                    print('loginEmail');
                    otpVerifyLogin();
                  } else {
                    print('llll');
                    otpVerifyReset();
                  }
                },
              ),
            ),
            // Display the entered OTP code
            // Text(
            //   _otp ?? 'Please enter OTP',
            //   style: const TextStyle(fontSize: 30),
            // )
            // Container(
            //   height: height / 10,
            //   width: width / 1.5,
            //   padding: EdgeInsets.fromLTRB(50, 0, 50, 20),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //           colors: [Colors.blue, ColorNames().lightBlue]),
            //       boxShadow: [],
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     child: Material(
            //       color: Colors.transparent,
            //       child: InkWell(
            //           onTap: () {
            //             Authentication.initializeFirebase(context: context);
            //             if (_formKey.currentState!.validate()) {
            //               _formKey.currentState!.save();
            //               auth.sendPasswordResetEmail(email: email);
            //               Navigator.pop(context);
            //             }
            //           },
            //           child: Center(
            //             child: Text('Submit',
            //                 style: TextStyle(color: Colors.white)),
            //           )),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 50,right: 50),
        child: Container(
          height: height / 12,
         // width: width / 5,
          padding: EdgeInsets.fromLTRB(50, 0, 50, 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                ColorNames().blue,
                ColorNames().blue
              ]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      _otp = _fieldOne.text +
                          _fieldTwo.text +
                          _fieldThree.text +
                          _fieldFour.text +
                          _fieldFive.text +
                          _fieldSix.text;
                    });
                    if (_otp!.isNotEmpty) {
                      if (widget.email.contains('null')) {
                        emailVerify();
                      } else if (widget.email.contains('loginEmail')) {
                        loginActivation();
                      } else {
                        checkPasswordOtp();
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialog(context, 'Enter Otp'),
                      );
                    }
                  },
                  child: Center(
                    child:
                        Text('Verify', style: TextStyle(color: Colors.white)),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  otpVerify() async {
    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var data = {"email": email, "reason": "account_activation"};

    CallApi().getOtp(data, 'users/get-otp/').then((value) async {
      if (value == 200) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ResetPassword(email: 'null',)),
        // );
      }
    });
  }

  otpVerifyLogin() async {
    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('loginEmail');
    var data = {"email": email, "reason": "account_activation"};

    CallApi().getOtp(data, 'users/get-otp/').then((value) async {
      if (value == 200) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ResetPassword(email: 'ema',)),
        // );
      }
    });
  }

  otpVerifyReset() async {
    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('passwordEmail');
    var data = {"email": email, "reason": "password_reset"};

    CallApi().getOtp(data, 'users/get-otp/').then((value) async {
      if (value == 200) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ResetPassword(email: 'null',)),
        // );
      }
    });
  }

  emailVerify() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('otp', _otp.toString());
    var email = prefs.getString('email');
    print(email);
    print(_otp);
    var data = {"email": email, "otp_token": _otp};

    CallApi()
        .emailVerification(data, 'users/email-verify/')
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

  loginActivation() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('otp', _otp.toString());
    var email = prefs.getString('loginEmail');
    print(email);
    print(_otp);
    var data = {"email": email, "otp_token": _otp};

    CallApi()
        .emailVerification(data, 'users/email-verify/')
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

  checkPasswordOtp() async {
    print('reset');
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('otp', _otp.toString());
    print(_otp);
    var data = {"email": widget.email, "otp_token": _otp};

    CallApi()
        .resetVerification(data, 'users/check-password-otp/')
        .then((value) async {
      if (value == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangePassword()),
        );
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var content = prefs.getString('resetVerificationerror');
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

// Create an input widget that takes only one digit
class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;

  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
