import 'package:flutter/material.dart';
import 'package:limitlesspark_new/screens/api/api.dart';
import 'package:limitlesspark_new/screens/book_now/view/book_now-ui.dart';
import 'package:limitlesspark_new/screens/common/app_constants.dart';
import 'package:limitlesspark_new/screens/site_list/view/car_list.dart';
import 'package:limitlesspark_new/screens/site_list/view/parking_spot_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Site_list extends StatefulWidget {
  const Site_list({Key? key}) : super(key: key);

  @override
  _Site_listState createState() => _Site_listState();
}

class _Site_listState extends State<Site_list> {
  TextEditingController controller = TextEditingController();
  List<String> dataList = [];
  final ScrollController _controller = ScrollController();
  late List<String> newDataList=[];

  onItemChanged(String value) {
    setState(() {
      // if(newDataList.contains(value)){
      //
      // } else{
      //   print('here');
      //   newDataList.clear();
      // }
      newDataList = dataList
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();

    });
  }


  var _isloading= true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CallApi().fetchsites().then((value) {
      setState(() {
        _isloading= false;
        print(_isloading);
        print(value);
        dataList = value.sites;
        print(dataList);
        newDataList = dataList;
        print(newDataList);

      });


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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 50,right: 50),
        child: Column(
          children: [
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 10,right: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorNames().blue),
                  borderRadius: BorderRadius.circular(20),
                color: ColorNames().lightShadeBlue,
              ),
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Image.asset('assets/images/search.png'),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(color: ColorNames().blue, fontSize: 10.0),
                  contentPadding: EdgeInsets.only(bottom: 20,top: 20)
                ),
                style: TextStyle(color: ColorNames().blue, fontSize: 12.0),
                controller: controller,
                onChanged: onItemChanged,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please enter Name';
                  } else if (val.contains(RegExp(r'[0-9]'))) {
                    return 'Please check your entry';
                  }
                },
                //onSaved: (val) => fname = val.toString(),
              ),
            ),
            SizedBox(height: 30,),
            _isloading?
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/infy.gif'),
                  // CircularProgressIndicator()
                ],
              ),
            ):
            Container(
              height: height/2,
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 15,
                    );
                  },
                controller: _controller,
                itemCount: newDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('site', newDataList[index]);
                      print(prefs.getString('site'));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CarList_ui()),
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/images/park.png'),
                        SizedBox(width: 10,),
                        Text(
                            newDataList[index],
                            style: TextStyle(
                                color:
                                ColorNames().blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        SizedBox(height: 10,),

                      ],
                    ),
                  );
                }),)
          ],
        ),
      )

    );
  }
}
