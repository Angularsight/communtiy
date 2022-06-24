

import 'package:get/get.dart';

import '../models/user_details/history.dart';
import 'firebase_controller.dart';
import 'onboarding_controller.dart';

class HistoryController extends GetxController{

  final OnBoardingController onBoardingController = Get.find();
  final FirebaseController firebaseController = Get.find();
  final historyList = [History()].obs;


  getHistoryList()async{
    var userDocId = await onBoardingController.fetchUserDocId();
    historyList.value = await firebaseController.fetchPartiesHistory(userDocId);
  }


  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    await getHistoryList();
  }

}