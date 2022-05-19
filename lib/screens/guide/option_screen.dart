import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/activities/view/activities_ui.dart';
import 'package:limitlesspark_new/screens/api/api.dart';
import 'package:limitlesspark_new/screens/book_now/view/book_now-ui.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:limitlesspark_new/screens/guide/guide_screen.dart';
import 'package:limitlesspark_new/screens/my_vehicles/view/my_vehicles_ui.dart';
import 'package:limitlesspark_new/screens/notifiction/view/notification_ui.dart';
import 'package:limitlesspark_new/screens/profile/view/profile.dart';
import 'package:limitlesspark_new/screens/site_list/view/site_list_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  _OptionScreenState createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  final List ItemList = [
    ['assets/images/calender.png','Reserve',Site_list(),],
    ['assets/images/cars.png','My Trips',Activities_ui()],
    ['assets/images/myCar.png','My Vehicles',MyVehicles_ui()],
    ['assets/images/notification.png','Notifications',Notification_ui()],
    ['assets/images/profile.png','Profile',ProfileUI()]
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CallApi().checkReservation().then((value) async {
      if (value.active == false) {
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('plateNo', value.data.licensePlate);
        prefs.setString('Nsite', value.data.site);
        prefs.setString('Nstate', value.data.state);
        print(prefs.getString('plateNo'));
        print( prefs.getString('Nsite'));
        print( prefs.getString('Nstate'));
      }
    });
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GuideScreen()),
              );
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
                    style: TextStyle(color: ColorNames().blue, fontSize: 15.0,fontFamily: 'Roboto',),
                  ),
                ],
              ))),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 30,right: 30,top: 30),
        child:  Column(
         // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Book Hassle Free Parking With Limitless App',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorNames().blue, fontSize: 23.0,fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',),
            ),
            SizedBox(
              height: 10,
            ),
            Image.asset("assets/images/homeImage.png"),
            SizedBox(
              height: 20,
            ),
            Container(
              height: height/2,
              padding: EdgeInsets.only(right: 20,left: 20),
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                        height: 15
                    );
                  },
                  //controller: _controller,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  ItemList[index][2],),
                        );
                      },
                      selectedTileColor: ColorNames().border,
                      title: Row(
                        crossAxisAlignment:CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: ColorNames().border,
                               // borderRadius: BorderRadius.all(Radius.circular(20)),
                                shape: BoxShape.circle
                              ),
                            child: Image.asset(ItemList[index][0],height: 20,),
                           //height: height/7,
                           width: width/7,
                            padding: EdgeInsets.all(15),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                              ItemList[index][1],
                              style: TextStyle(
                                  color:
                                  ColorNames().blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'Roboto')),
                          Spacer(),
                          Image.asset(
                            'assets/images/arrow.png',height: 60,
                          ),
                        ],
                      ),
                    );
                  }
              ),
            )
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   color: ColorNames().blue,
      //   height: 60,
      // ),
    );
  }
}
