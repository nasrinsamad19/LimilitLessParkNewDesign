import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:limitlesspark_new/screens/guide/option_screen.dart';
import 'package:limitlesspark_new/screens/login/view/intro_ui.dart';

class GuideScreen3 extends StatefulWidget {
  const GuideScreen3({Key? key}) : super(key: key);

  @override
  _GuideScreen3State createState() => _GuideScreen3State();
}

class _GuideScreen3State extends State<GuideScreen3> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20,right: 20),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              '''Manage Your Parking 
 From Your Smartphone''',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorNames().blue, fontSize: 23.0,fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
                height: height/3,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage("assets/images/intro3.png"),
                    fit: BoxFit.fill,
                  ),
                )
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorNames().blue,
                          width: 4
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorNames().blue,
                          width: 4
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: ColorNames().blue,
                      border: Border.all(
                          color: ColorNames().blue,
                          width: 4
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: height / 15,
              // width: width / 2,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [ColorNames().blue,ColorNames().blue]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => intro_ui()),
                        );
                      },
                      child: Center(
                        child: Text('Next',
                            style: TextStyle(color: Colors.white,fontSize: 27)),
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height / 15,
                // width: width / 2,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [ColorNames().lightBlue,ColorNames().lightBlue]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => intro_ui()),
                          );
                        },
                        child: Center(
                          child: Text('Skip',
                              style: TextStyle(color: Colors.white,fontSize: 27)),
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
}
