

import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackapp/blank.dart';

class AuthController {
  static login(Map UserData) async {
    print(UserData);

    var response = {"user_id": "99", "user_token": "xx8894jjdsdhsuur"};
    var any = await SharedPreferences.getInstance();

    any.setString("userData", json.encode(response));
    // Get.off(Home());
    Get.off(() => Home());
  }
}
