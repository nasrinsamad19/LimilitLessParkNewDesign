import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/book_now/view/book_now-ui.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:limitlesspark_new/screens/site_list/view/car_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParkingSpotList extends StatefulWidget {
  const ParkingSpotList({Key? key}) : super(key: key);

  @override
  _ParkingSpotListState createState() => _ParkingSpotListState();
}

class _ParkingSpotListState extends State<ParkingSpotList> {
  var _isloading = true;
  List dataList = [];
  final ScrollController _controller = ScrollController();
  late List<String> newDataList = [];
  var car1;
  var car2;
  var dataLIstLength;
  var value;
  var selected;

  //late List<Car> list;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
          child:
              // _isloading?
              // Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Image.asset('assets/images/infy.gif'),
              //     ],
              //   ),
              // ):
              Column(
            children: [
              Text('Pick parking spot',
                  style: TextStyle(
                    color: ColorNames().blue,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  )),
              SizedBox(
                height: 30,
              ),
              Container(
                height: height / 2,
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 15);
                    },
                    controller: _controller,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                        tileColor: ColorNames().offwhite,
                        contentPadding: EdgeInsets.only(
                            left: 20, right: 10, bottom: 10, top: 10),
                        value: index,
                        selectedTileColor: ColorNames().border,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(
                              color: index != value
                                  ? ColorNames().border
                                  : ColorNames().blue),
                        ),
                        activeColor: ColorNames().blue,
                        groupValue: value,
                        onChanged: (val) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            print(val);
                            value = val;
                            print(value);
                            selected = index;
                            // prefs.setString('selectedCar', dataList[index].licensePlate);
                            // prefs.setString('state', dataList[index].state);
                          });
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('05 slot available',
                                style: TextStyle(
                                  color: ColorNames().blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                )),
                            // Text(
                            //     dataList[index].licensePlate,
                            //     style: TextStyle(
                            //         color:
                            //         ColorNames().blue,
                            //         fontSize: 12,
                            //         fontFamily: 'Roboto',)),
                          ],
                        ),
                        //subtitle: Text("caption/subtext"),
                        secondary: Text('Level',
                            style: TextStyle(
                              color: ColorNames().blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                              fontFamily: 'Roboto',
                            )),
                        toggleable: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                      );
                    }),
              )
            ],
          )),
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
                onTap: () async {
                  print(value);
                  if (value != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CarList_ui()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context, 'Select parking area'),
                    );
                  }
                },
                child: Center(
                  child: Text('continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontFamily: 'Roboto',
                      )),
                )),
          ),
        ),
      ),
    );
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
