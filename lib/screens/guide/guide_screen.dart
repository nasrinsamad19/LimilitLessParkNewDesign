import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:limitlesspark_new/screens/guide/guide_screen2.dart';
import 'package:limitlesspark_new/screens/guide/option_screen.dart';
import 'package:limitlesspark_new/screens/login/view/intro_ui.dart';
import 'package:limitlesspark_new/screens/login/view/login_ui.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({Key? key}) : super(key: key);

  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  SwiperController controller = SwiperController();
  final List imgList = [
    'assets/images/intro1.png',
    'assets/images/intro2.png',
    'assets/images/intro3.png',
  ];
  final List title = [
    '''Find Parking Around You Easily''',
    '''Easy Booking And 
   Secure Payment''',
    '''Manage Your Parking 
   From Your Smartphone''',
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 45, right: 45, top: 80, bottom: 100),
        child: Column(
          children: [
            SizedBox(
              height: height / 1.6,
              child: Swiper(
                pagination: new SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: new DotSwiperPaginationBuilder(
                      color: Colors.grey,
                      activeColor: ColorNames().blue,
                      size: 18,
                      activeSize: 18),
                ),
                controller: controller,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      child: Column(
                        children: [
                          Text(
                            title[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorNames().blue,
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                              height: height / 3,
                              width: width / 1,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                image: DecorationImage(
                                  image: AssetImage(imgList[index]),
                                  fit: BoxFit.fill,
                                ),
                              )),
                        ],
                      ),
                      padding: EdgeInsets.only(bottom: 40));
                },
                itemCount: 3,
                itemWidth: 100.0,
                layout: SwiperLayout.DEFAULT,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: height / 15,
              // width: width / 2,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [ColorNames().blue, ColorNames().blue]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        controller.next();
                      },
                      child: Center(
                        child: Text('Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Roboto',
                            )),
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
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      ColorNames().lightBlue,
                      ColorNames().lightBlue
                    ]),
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
                          child: Text('Skip',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
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
}
