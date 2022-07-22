

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communtiy/getx_ui/bottom_nav_page.dart';
import 'package:communtiy/getx_ui/phone_login_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/user_details/user_detail.dart';

class AuthController extends GetxController{
  static AuthController instance = Get.find();

  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  var userEnteredPhoneNumber = ''.obs;

  late StreamSubscription subscription;
  var _hasInternet = false.obs;
  bool get hasInternet => _hasInternet.value;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result){
      _hasInternet.value = true;
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());

    ///The below function is a GetX feature
    ///Which listens to change in _user variable throughout the app
    ///If there is any change it will implement the given function
    ever(_hasInternet, _handleInternetIssue);
    ever(_user, _initializeApp);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    subscription.cancel();
  }

  _handleInternetIssue(bool internet){
    if(internet==false){
      _hasInternet.value = false;
    }else{
      _hasInternet.value = true;
    }
  }

  _initializeApp(User? user){
    if(user==null){
      print('Moving to login page');
      Get.offAll(()=>PhoneLoginScreen());
    }else{
      print('Already logged in');
      Get.off(()=>BottomNavigationPage());
    }
  }


  Future<bool> checkUserExistence2(int phoneNumber)async{
    final res = await FirebaseFirestore.instance
        .collection("UserDetails")
        .where("phoneNumber",isEqualTo: phoneNumber)
        .get()
        .then((query) {
          var users = query.docs.map((e) => UserDetailsModel.fromDocument(e)).toList();
          return users;
        });
    print("result of checkUserExistence2:${res.length}");
    bool existenceOfUser = res.length >=1;
    return existenceOfUser;
  }

  Future<bool> checkUserExistence3(String userId)async{
    final res = await FirebaseFirestore.instance
        .collection("UserDetails")
        .where("userId",isEqualTo: userId)
        .get()
        .then((query) {
      var users = query.docs.map((e) => UserDetailsModel.fromDocument(e)).toList();
      return users;
    });
    print("result of checkUserExistence3:${res.length}");
    bool existenceOfUser = res.length >=1;
    return existenceOfUser;
  }

}