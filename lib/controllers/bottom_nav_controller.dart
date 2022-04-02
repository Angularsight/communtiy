

import 'package:communtiy/getx_ui/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController{


  final _bottomNavIndex = 0.obs;
  int get bottomIndex => _bottomNavIndex.value;


  void changeIndex(int index){
    _bottomNavIndex.value = index;
  }





}