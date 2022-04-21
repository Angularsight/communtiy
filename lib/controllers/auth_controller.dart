

import 'package:communtiy/getx_ui/bottom_nav_page.dart';
import 'package:communtiy/getx_ui/main_screen.dart';
import 'package:communtiy/getx_ui/phone_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{
  static AuthController instance = Get.find();

  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());

    ///The below function is a GetX feature
    ///Which listens to change in _user variable throughout the app
    ///If there is any change it will implement the given function

    ever(_user, _initializeApp);
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

}