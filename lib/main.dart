import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/api/api.dart';
import 'package:limitlesspark_new/screens/book_now/view/book_now-ui.dart';
import 'package:limitlesspark_new/screens/car_registration/view/car_registration_ui.dart';
import 'package:limitlesspark_new/screens/guide/welcome_screen.dart';
// import 'package:limitlesspark_new/screens/splash_screen.dart';
//
// void main() {
//   runApp( MyApp());
// }
//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Web Views',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         fontFamily: "Arial",
//       ),
//       home: Splashcreen(),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:limitlesspark_new/screens/notifiction/view/notification_ui.dart';
import 'package:limitlesspark_new/screens/site_list/view/site_list_ui.dart';
import 'package:limitlesspark_new/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('Handling a background message ${message.messageId}');
  print(message.data);
  AndroidNotification? android = message.notification?.android;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('body', message.notification!.body.toString());

  flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          // channel.description,
          icon: android?.smallIcon,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  SharedPreferences prefs = await SharedPreferences.getInstance();

  //runApp(const MyApp());
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  var token;
  var loggedin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loggedinfn();

    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('onMessageOpenedApp');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var test = 'EXtend';
        var cancel = 'Cancel';
        setState(() {
          prefs.setString('body', notification.body.toString());
          prefs.setString('title', notification.title.toString());
          var body = prefs.getString('body');
          var title = prefs.getString('title');

          names.insert(0, body!);
          titles.insert(0, title!);
          prefs.setStringList('name', names);
          prefs.setStringList('Titles', titles);
          print(prefs.getStringList('Titles'));
          print(prefs.getStringList('name'));
        });
        print(prefs.getString('title'));
        if (message.data != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Notification_ui()),
          );
        }
        if (notification.title == test) {
          print('success');
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(
                context, 'Do you want to extend your reservation?'),
          );
        }
        if (notification.title == cancel) {
          print('cancel=-------');
          BookNowState().getCarList();

          callCheckReservation();
        }
        print(notification.body);
        print(message.data.keys);
        print(message.data.values);
        print(message.notification!.bodyLocArgs.toString());
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description,
                icon: android?.smallIcon,
              ),
            ));
      }
    });

    ///forground work
    // FirebaseMessaging.onMessage.listen((message) async {
    //   if (message.notification != null) {
    //
    //     var body = message.notification!.body;
    //     print(message.notification!.body);
    //     print(message.data.values.first.toString());
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     var id= await prefs.setString('ID', message.data.values.first.toString());
    //
    //    print(prefs.getString('ID'));
    //     await prefs.setString('body', message.notification!.body.toString());
    //     var value = message.data.values;
    //    print(value.toString());
    //
    //   }
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('onMessage');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var extend = 'EXtend';
        var cancel = 'Cancel';

        setState(() {
          prefs.setString('body', notification.body.toString());
          prefs.setString('title', notification.title.toString());
          var body = prefs.getString('body');
          var title = prefs.getString('title');

          names.insert(0, body!);
          titles.insert(0, title!);
          prefs.setStringList('name', names);
          prefs.setStringList('Titles', titles);
          print(prefs.getStringList('Titles'));
          print(prefs.getStringList('name'));
        });

        print(prefs.getString('title'));

        // if (message.data != null) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => Home(3)),
        //   );
        // }
        if (notification.title == extend) {
          print('extend');
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) =>
                _buildPopupDialog(context, extend),
          );
        } else if (notification.title == cancel) {
          setState(() {
            print('cancel---------');
            callCheckReservation();
          });
        }

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description,
                icon: android?.smallIcon,
              ),
            ));
      }
    });

    getToken();
    //getnotification();
  }

  //  popup() {
  //    showDialog(
  //      context: context,
  //      builder: (BuildContext context) => _buildPopupDialog(context,test),
  //    );
  // }

  var body;
  var id;
  var title;
  var carId2;
  final List<String> names = <String>[];
  late List<String> titles = <String>[];

  var list;

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
    list = prefs.getStringList('name');
    print(list);

    setState(() {
      body = prefs.getString('body');
      body != null ? names.insert(0, body) : null;
      body != null ? prefs.setStringList('name', names) : null;
      print(prefs.getStringList('name'));
      list = prefs.getStringList('name');
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

  NewToken() {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      final prefs = await SharedPreferences.getInstance();
      var currentToken = prefs.getString('token');
      if (currentToken != token) {
        print('token refresh: ' + token);
        // add code here to do something with the updated token
        await prefs.setString('token', token);
      }
    });
  }

  loggedinfn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedin = prefs.getString('alreadyloggedin');
    });
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseMessaging.instance.getToken().then((value) {
      print(value);
      if (value != null) {
        prefs.setString('token', value.toString());
        token = token;
        print('lll');
        print(value.toString());
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(context,
              'Token not generaed check internet connection or need google services '),
        );
      }
    });
  }

  callCheckReservation() {
    CallApi().checkReservation().then((value) {
      print(value.active);
      if (value.active == true) {
        BookNowState().getCarList();
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
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var car = prefs.getString('plateNo');
            var site = prefs.getString('Nsite');
            var state = prefs.getString('Nstate');
            var data = {
              "license_plate": car,
            "state": state,
            "site": site
            };
            CallApi()
                .postExtend(data, 'reservations/extend/')
                .then((value) async {
              if (value == 200) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var content = prefs.getString('error');
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupDialog(context, 'No active Booking'),
                );
              }
            });
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Extend'),
        ),
        new FlatButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var car = prefs.getString('plateNo');
            var site = prefs.getString('Nsite');
            var state = prefs.getString('Nstate');
            var data = {
              "license_plate": car,
              "state": state,
              "site": site
            };
            CallApi()
                .postCancel(data, 'reservations/cancel/')
                .then((value) async {
              if (value == 200) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var content = prefs.getString('error');
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupDialog(context, 'No active Booking'),
                );
                Navigator.pop(context);
              }
            });
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
       home: Splashcreen()
      //home: Site_list(),
    );
  }
}

