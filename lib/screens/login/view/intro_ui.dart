import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:limitlesspark_new/screens/login/view/login_ui.dart';
import 'package:limitlesspark_new/screens/login/view/signup_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class intro_ui extends StatefulWidget {
  const intro_ui({Key? key}) : super(key: key);

  @override
  _intro_uiState createState() => _intro_uiState();
}

class _intro_uiState extends State<intro_ui> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      width: width,

      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 2.5,
            ),
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 100,
            ),
            Text(
              'Welcome to the'.toUpperCase(),
              style: TextStyle(
                  color: ColorNames().blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0),
            ),
            Text(
              'Limitless Park'.toUpperCase(),
              style: TextStyle(
                  color: ColorNames().blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: height / 12,
              width: width / 2,
              padding: EdgeInsets.fromLTRB(50, 0, 50, 20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [ColorNames().lightBlue, Colors.blue]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => loginUi()),
                        );
                      },
                      child: Center(
                        child: Text('Log In'.toUpperCase(),
                            style: TextStyle(color: Colors.white)),
                      )),
                ),
              ),
            ),
            Container(
              height: height / 12,
              width: width / 2,
              padding: EdgeInsets.fromLTRB(50, 0, 50, 20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue, ColorNames().lightBlue]),
                  boxShadow: [],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: Center(
                        child: Text('Sign Up'.toUpperCase(),
                            style: TextStyle(color: Colors.white)),
                      )),
                ),
              ),
            ),
            // GestureDetector(
            //   child: RichText(
            //     text: new TextSpan(
            //       // Note: Styles for TextSpans must be explicitly defined.
            //       // Child text spans will inherit styles from parent
            //       style: new TextStyle(
            //         fontSize: 14.0,
            //         color: Colors.black,
            //       ),
            //       children: <TextSpan>[
            //         new TextSpan(
            //           text: 'Forgot your password?'.toUpperCase(),
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 13.0),
            //         ),
            //       ],
            //     ),
            //   ),
            //   onTap: () {
            //     otpVerify();
            //   },
            // )
          ],
        ),
      ),
    ));
  }
// otpVerify() async {
//   final prefs = await SharedPreferences.getInstance();
//   var email=prefs.getString('email');
//   var data ={
//     "email": email,
//     "reason": "password_reset"
//   };
//
//   CallApi().getOtp(data, 'users/get-otp/').then((value) async {
//     if (value== 200){
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ResetPassword()),
//       );
//     }}
//   );
//
// }
}
