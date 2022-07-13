

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../models/user_details/history.dart';
import 'firebase_controller.dart';
import 'onboarding_controller.dart';

class HistoryController extends GetxController{

  final OnBoardingController onBoardingController = Get.find();
  final FirebaseController firebaseController = Get.find();
  var historyList = [History()].obs;


  getHistoryList()async{
    try{
      var userDocId = await onBoardingController.fetchUserDocId();
      historyList.value = await firebaseController.fetchPartiesHistory(userDocId);
    }catch (r){
      historyList.value = [];
      Fluttertoast.showToast(
          msg: "Complete onboarding to see history",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

  }


  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    await getHistoryList();
  }

}