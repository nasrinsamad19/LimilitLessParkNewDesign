import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notification_ui extends StatefulWidget {
  const Notification_ui({Key? key}) : super(key: key);

  @override
  _Notification_uiState createState() => _Notification_uiState();
}

class _Notification_uiState extends State<Notification_ui> {
  bool first = true;
  late int count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //CallApi().fetchNotifictions();
    getList();
    Timer mytimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        getList();
      }
    });
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   setState(() {
  //     getList();
  //
  //   });
  //   super.didChangeDependencies();
  // }
  bool _isLoading = true;

  var body;
  var id;
  var title;
  var carId2;
  late List<String> names = <String>[];
  late List<String> titles = <String>[];

  var list = [];
  var titleList = [];

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
                    style: TextStyle(color: ColorNames().blue, fontSize: 15.0),
                  ),
                ],
              ))),

      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () => getList(),
        child: list != null
            ? ListView.builder(
                itemCount: list != null ? list.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Card(
                      color: ColorNames().ash,
                      child: Container(
                        height: 60,
                        padding: EdgeInsets.all(10),
                        child: Stack(
                          fit: StackFit.passthrough,
                          overflow: Overflow.visible,
                          children: [
                            // Positioned(
                            //     right: 0,
                            //     child: Row(
                            //       children: [
                            //         Icon(Icons.access_time,
                            //             size: 9, color: Colors.grey),
                            //         Text('12:00 AM',
                            //             style: TextStyle(
                            //               color: Colors.grey,
                            //               fontSize: 9,
                            //             )),
                            //       ],
                            //     )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(titleList[index],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(list[index],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : Container(),
      )),
      bottomNavigationBar: Container(
        child: Container(
          height: height / 10,
          width: width / 1.5,
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
                    getnotification();
                  },
                  child: Center(
                    child:
                        Text('REFRESH', style: TextStyle(color: Colors.white)),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      list = prefs.getStringList('name')!;
      print(list);

      titleList = prefs.getStringList('Titles')!;
      print(titleList);
    });
  }

  void getnotification() async {
    // WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();
    // FirebaseMessaging.instance.getInitialMessage();
    //
    // FirebaseMessaging.onMessage.listen((message) async {
    //   if (message.notification != null) {
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     id = prefs.getString('ID');
    //
    //
    //   }
    // });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //list= prefs.getStringList('name');

    setState(() {
      body = prefs.getString('body');
      body != null ? names.insert(0, body) : null;
      body != null ? prefs.setStringList('name', names) : null;
      print(prefs.getStringList('name'));
      list = prefs.getStringList('name')!;
      body = null;
      prefs.remove('body');
    });
    title = prefs.getString('title');
    id = prefs.getString('ID');

    // if (id == carId1 && id !=null) {
    //   setState(() {
    //     body = prefs.getString('body');
    //   });
    //   print('ddd' + body);
    // }
    // if (id == carId2) {
    //   body = prefs.getString('body');
    //   print(body);
    // }
  }
}
