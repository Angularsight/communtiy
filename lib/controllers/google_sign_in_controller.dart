

import 'dart:async';

import 'package:communtiy/controllers/onboarding_controller.dart';
import 'package:communtiy/getx_ui/bottom_nav_page.dart';
import 'package:communtiy/getx_ui/user_upload.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';


/// Can extract name,profile pic, email from the google account
class GoogleSignInController extends GetxController{
  final googleSignIn = GoogleSignIn();


  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  // final OnBoardingController _onBoardingController = Get.put(OnBoardingController());

  var signedInBool = true.obs;

  Future googleLogin() async{
    final googleUser = await googleSignIn.signIn();
    if(googleUser==null) return null;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credentials = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken);
    await FirebaseAuth.instance.signInWithCredential(credentials);
    update();
    signedInBool.value = false;
    Get.to(()=>UserUpload());

  }

  // late StreamSubscription subscription;
  // var _hasInternet = false.obs;
  // bool get hasInternet => _hasInternet.value;
  //
  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result){
  //     _hasInternet.value = true;
  //   });
  // }
  //
  // @override
  // void onReady() {
  //   // TODO: implement onReady
  //   super.onReady();
  //   ever(_hasInternet, _handleInternetIssue);
  // }
  //
  // @override
  // void onClose() {
  //   // TODO: implement onClose
  //   super.onClose();
  //   subscription.cancel();
  // }
  //
  // _handleInternetIssue(bool internet){
  //   if(internet==false){
  //     _hasInternet.value = false;
  //   }else{
  //     _hasInternet.value = true;
  //   }
  // }


}