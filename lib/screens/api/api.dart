import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:limitlesspark_new/screens/activities/model/model.dart';
import 'package:limitlesspark_new/screens/book_now/model/model.dart';
import 'package:limitlesspark_new/screens/car_registration/model/model.dart';
import 'package:limitlesspark_new/screens/login/view/model.dart';
import 'package:limitlesspark_new/screens/profile/model/model.dart';
import 'package:limitlesspark_new/screens/site_list/model/sites.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  // final String _baseUrl = "http://userlbs-1736480021.us-east-1.elb.amazonaws.com/";
  final String _baseUrl =
      "http://USERLBS-1736480021.us-east-1.elb.amazonaws.com/";

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  postData(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final res =
        await http.get(Uri.parse(_baseUrl + 'reservations/list/'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token ${token}',
    });
    print("Result: ${res.body}");
    print(res.statusCode);
    print(res.body);
    print(res.reasonPhrase);
    if (res.statusCode == 201) {
      print('sucees');
      Profile.fromJson(jsonDecode(res.body));
      return true;
    } else {
      return false;
    }
  }

  postCarRegistration(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var res =
        await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token ${token}',
    });
    print(res.statusCode);
    print(res.reasonPhrase);
    print(res.body);
    if (res.statusCode == 201) {
      print('sucees');
      // User.fromJson(jsonDecode(res.body));
      return true;
    } else {
      return false;
    }
  }

  postSocialGoogleLogin(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    var res = await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
    print(res.statusCode);
    print(res.reasonPhrase);
    print(res.body);
    if (res.statusCode == 201) {
      print('sucees');
      //User.fromJson(jsonDecode(res.body));
      return true;
    } else {
      return false;
    }
  }

  postSocialFacebbokLogin(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    var res = await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
    print(res.statusCode);
    print(res.reasonPhrase);
    print(res.body);
    if (res.statusCode == 201) {
      print('sucees');
      //User.fromJson(jsonDecode(res.body));
      return true;
    } else {
      return false;
    }
  }

  Future<Object> login(LoginRequestModel loginRequestModel) async {
    String lurl = 'users/token/';
    String url = _baseUrl + lurl;
    final response =
        await http.post(Uri.parse(url), body: loginRequestModel.toJson());
    print(response.statusCode);
    print(response.reasonPhrase);
    final responseJson = json.decode(response.body);
    print(responseJson);
    if (response.statusCode == 200) {
      // Profile profile = Profile.fromJson(json.decode(response.body));
      // print(profile.user.firstName);
      // await prefs.setString('firstName', profile.user.firstName);
      // await prefs.setString('lastName', profile.user.lastName);
      // await prefs.setString('email', profile.user.email);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', responseJson['access']);
      await prefs.setString('refresh', responseJson['refresh']);

      var access = prefs.getString('access');
      var refresh = prefs.getString('refresh');

      if (access!.isEmpty) {
        String lurl = 'users/token/refresh';
        String url = _baseUrl + lurl;
        var data = {'refresh': refresh};
        final response = await http.post(Uri.parse(url), body: data);
        print(response.statusCode);
        print(response.reasonPhrase);
        final responseJson = json.decode(response.body);
        print(responseJson);
        await prefs.setString('access', responseJson['access']);
      }
      // prefs.setString('alreadyloggedin', 'true');
      return 200;
    } else if (response.statusCode == 401) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('loginError', responseJson['detail']);
      return false;
    } else {
      Map<String, dynamic> responseJson = json.decode(response.body);
      if (responseJson.containsKey('error_code')) {
        return 400;
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('loginError', responseJson['message']);
        return false;
      }
    }
  }

  Future<Activities> fetchActivities(apiUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accesstoken = prefs.getString('access');
    final response = await http.get(Uri.parse(_baseUrl + apiUrl), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token ${accesstoken}',
    });
    print(response.statusCode);
    print(response.reasonPhrase);
    print(response.body);
    return Activities.fromJson(json.decode(response.body));
  }

  postBookNow(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accesstoken = prefs.getString('access');
    var res =
        await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token ${accesstoken}',
    });
    print(res.statusCode);
    print(res.reasonPhrase);
    print(res.body);
    if (res.statusCode == 200) {
      print('sucees');
      return true;
    } else {
      return res.body;
    }
  }

  postUpdateProfile(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accesstoken = prefs.getString('access');
    var res =
        await http.patch(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token ${accesstoken}',
    });
    print(res.statusCode);
    print(res.reasonPhrase);
    print(res.body);
    if (res.statusCode == 200) {
      print('sucees');
      return 200;
    } else {
      if (res.statusCode == 500) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('updateError', 'Internal Server Error');
      } else {
        Map<String, dynamic> responseJson = json.decode(res.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('updateError', responseJson['message']);
        return false;
      }
    }
  }

  postUpdateCar(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(data[0]);
    var res =
        await http.put(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token ${token}',
    });
    print(res.statusCode);
    print(res.reasonPhrase);
    print(res.body);
    if (res.statusCode == 200) {
      print('sucees');
      return true;
    } else {
      return false;
    }
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response =
        await http.get(Uri.parse(_baseUrl + 'accounts/logout/'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token ${token}',
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('sucees');
      return true;
    } else {
      return false;
    }
  }

  Future<http.Response> fetchNotifictions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http
        .get(Uri.parse("https://api.catapush.com/1/messages"), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    print(response.body);
    return jsonDecode(response.body);
  }

  register(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    var res =
        await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    print(res.body);
    if (res.body
        .toString()
        .contains('registrationToken already exists in the system')) {
      print(res.reasonPhrase);
    }
    if (res.statusCode == 201) {
      print('sucees');
      return 201;
    } else if (res.body.toString().contains(
        'Wrong or Empty data is not allowed for fullName or Email or license_plate')) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('error',
          'Wrong or Empty data is not allowed for fullName or Email or license_plate');
      return 400;
    } else if (res.body
        .toString()
        .contains("'NoneType' object has no attribute 'replace'")) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('error',
          'Firebase token not generated, please update play store to latest version');
      return 400;
    } else {
      if (res.statusCode == 500) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('error', 'Internal Server Error');
        return 400;
      } else {
        Map<String, dynamic> responseJson = json.decode(res.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('error', responseJson['message']);
        return 400;
      }
    }
  }

  Future<Profile> fetchprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accesstoken = prefs.getString('access');
    final response =
        await http.post(Uri.parse(_baseUrl + 'users/profile/'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token ${accesstoken}',
    });
    print(response.body);
    var jsonResponse = json.decode(response.body);
    return Profile.fromJson(json.decode(response.body));
  }

  postExtend(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accesstoken = prefs.getString('access');
    var res =
        await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token ${accesstoken}',
    });
    print(res.statusCode);
    print(res.reasonPhrase);
    print(res.body);
    if (res.statusCode == 200) {
      print('sucees');
      // User.fromJson(jsonDecode(res.body));
      return 200;
    } else {
      if (res.statusCode == 500) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('updateError', 'Internal Server Error');
      } else {
        Map<String, dynamic> responseJson = json.decode(res.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('updateError', responseJson['message']);
        return false;
      }
    }
  }

  postCancel(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accesstoken = prefs.getString('access');
    var res =
        await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token ${accesstoken}',
    });
    print(res.statusCode);
    print(res.reasonPhrase);
    print(res.body);
    if (res.statusCode == 200) {
      print('sucees');
      // User.fromJson(jsonDecode(res.body));
      return 200;
    } else {
      if (res.statusCode == 500) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('updateError', 'Internal Server Error');
      } else {
        Map<String, dynamic> responseJson = json.decode(res.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('updateError', responseJson['message']);
        return false;
      }
    }
  }

  Future<Reservation> checkReservation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accesstoken = prefs.getString('access');
    final response = await http.post(
        Uri.parse(_baseUrl + 'reservations/check-reservation/'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token ${accesstoken}',
        });
    print(response.reasonPhrase);
    print(response.statusCode);
    print(response.body);
    var jsonResponse = json.decode(response.body);
    return Reservation.fromJson(json.decode(response.body));
  }

  getOtp(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    var res =
        await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      //'Authorization': 'Token ${accesstoken}',
    });
    print(data);
    print(res.statusCode);
    print(res.reasonPhrase);
    print(res.body);
    if (res.statusCode == 200) {
      print('sucees');
      return 200;
    } else {
      if (res.statusCode == 500) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('getOtpError', 'Internal Server Error');
      } else {
        Map<String, dynamic> responseJson = json.decode(res.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('getOtpError', responseJson['message']);
        return false;
      }
    }
  }

  emailVerification(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    print(data);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accesstoken = prefs.getString('access');
    var res =
        await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      //'Authorization': 'Token ${accesstoken}',
    });
    print(res.statusCode);
    print(res.reasonPhrase);
    print(res.body);
    if (res.statusCode == 200) {
      print('sucees');
      final responseJson = json.decode(res.body);
      print(responseJson);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', responseJson['access_token']);
      // prefs.setString('alreadyloggedin', 'true');
      // User.fromJson(jsonDecode(res.body));
      return 200;
    } else {
      if (res.statusCode == 500) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('emailVerror', 'Internal Server Error');
      } else {
        Map<String, dynamic> responseJson = json.decode(res.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('emailVerror', responseJson['message']);
        return false;
      }
    }
  }

  resetVerification(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    print(data);
    var res =
        await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      //'Authorization': 'Token ${accesstoken}',
    });
    print(res.statusCode);
    print(res.reasonPhrase);
    print(res.body);
    if (res.statusCode == 200) {
      print('sucees');
      final responseJson = json.decode(res.body);
      print(responseJson);
      return 200;
    } else {
      if (res.statusCode == 500) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('resetVerificationerror', 'Internal Server Error');
      } else {
        Map<String, dynamic> responseJson = json.decode(res.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('resetVerificationerror', responseJson['message']);
        return false;
      }
    }
  }

  Future<States> fetchstates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accesstoken = prefs.getString('access');
    print(accesstoken);
    final response =
        await http.get(Uri.parse(_baseUrl + 'users/get-states/'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      //'Authorization': 'Token ${accesstoken}',
    });
    print(response.body);
    var jsonResponse = json.decode(response.body);
    return States.fromJson(json.decode(response.body));
  }

  Future<Sites> fetchsites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accesstoken = prefs.getString('access');
    print(accesstoken);
    final response =
        await http.get(Uri.parse(_baseUrl + 'users/get-sites/'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      //'Authorization': 'Token ${accesstoken}',
    });
    print(response.body);
    var jsonResponse = json.decode(response.body);
    return Sites.fromJson(json.decode(response.body));
  }
}
