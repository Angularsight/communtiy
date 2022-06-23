

import 'dart:async';

import 'package:communtiy/getx_ui/main_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController{


  final _bottomNavIndex = 0.obs;
  int get bottomIndex => _bottomNavIndex.value;


  void changeIndex(int index){
    _bottomNavIndex.value = index;
  }


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
    ever(_hasInternet, _handleInternetIssue);
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



}