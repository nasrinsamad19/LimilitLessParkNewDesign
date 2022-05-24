import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/api/api.dart';
import 'package:limitlesspark_new/screens/book_now/view/book_now-ui.dart';
import 'package:limitlesspark_new/screens/car_registration/view/add_more_car.dart';
import 'package:limitlesspark_new/screens/car_registration/view/car_registration_ui.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:limitlesspark_new/screens/profile/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyVehicles_ui extends StatefulWidget {
  const MyVehicles_ui({Key? key}) : super(key: key);

  @override
  _MyVehicles_uiState createState() => _MyVehicles_uiState();
}

class _MyVehicles_uiState extends State<MyVehicles_ui> {

  var _isloading= true;
  List dataList = [];
  final ScrollController _controller = ScrollController();
  late List<String> newDataList=[];
  var car1;
  var car2;
  var dataLIstLength;
  var value;
  var selected;
  late List<Car> list;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CallApi().fetchCars().then((value) {
      setState(() {
        _isloading= false;
        print(_isloading);
        print(value);
        dataList= value.cars  as List;
        print(dataList);
        dataLIstLength=value.cars.length;
        car1 = value.cars.first.licensePlate;
        print(value.cars.length);
        if(value.cars.length >1){
          car2 = value.cars.last.licensePlate;
        }
        print(dataList);
        //newDataList = dataList;
        print(newDataList);
      });
    });
  }

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
                    style: TextStyle(color: ColorNames().blue, fontSize: 15.0,fontFamily: 'Roboto',),
                  ),
                ],
              ))),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 30,right: 30,bottom: 30),
          child:  _isloading?
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/infy.gif'),
              ],
            ),
          ):
          Column(
            children: [
              Text(
                  'My Vehicles',
                  style: TextStyle(
                      color:
                      ColorNames().blue,
                      fontSize: 18,
                    fontFamily: 'Roboto',)),
              SizedBox(
                height: 30,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                        height: 15
                    );
                  },
                  controller: _controller,
                  itemCount: dataLIstLength,
                  itemBuilder: (BuildContext context, int index) {
                    return RadioListTile(
                      tileColor: ColorNames().offwhite,
                      contentPadding: EdgeInsets.all(10),
                      value: index,
                      selectedTileColor: ColorNames().border,
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                            color: index!=value?ColorNames().border : ColorNames().blue),
                      ),
                      activeColor: ColorNames().blue,
                      groupValue: value,
                      onChanged: (val) async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        setState(() {
                          print(val);
                          value=val;
                          print(value);
                          selected = index;
                          prefs.setString('selectedCar', dataList[index].licensePlate);
                          prefs.setString('state', dataList[index].state);

                        });
                      },
                      title: Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children: [
                          Text(
                              dataList[index].name,
                              style: TextStyle(
                                color:
                                ColorNames().blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,fontFamily: 'Roboto',)),
                          Text(
                              dataList[index].licensePlate,
                              style: TextStyle(
                                color:
                                ColorNames().blue,
                                fontSize: 12,fontFamily: 'Roboto',)),
                        ],
                      ),
                      //subtitle: Text("caption/subtext"),
                      secondary: Image.asset('assets/images/car.png',),
                      toggleable: true,
                      controlAffinity: ListTileControlAffinity.trailing,
                    );
                  }
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: height / 14,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [ColorNames().blue,ColorNames().blue]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddMoreCar()),
                        );
                      },
                      child: Center(
                        child: Text('Add New Vehicle',
                            style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Roboto',)),
                      )),
                ),
              ),
            ],
          )

      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context,value) {
    return new AlertDialog(
      title: const Text(' Message'),
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
