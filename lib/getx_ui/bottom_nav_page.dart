

import 'dart:io';

import 'package:communtiy/controllers/bottom_nav_controller.dart';
import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/getx_ui/main_screen.dart';
import 'package:communtiy/getx_ui/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'matched_screen.dart';
class BottomNavigationPage extends StatelessWidget {
  BottomNavigationPage({Key? key}) : super(key: key);

  final BottomNavController controller = Get.put(BottomNavController());
  final FirebaseController firebaseController = Get.put(FirebaseController());


  @override
  Widget build(BuildContext context) {


    return GetX<BottomNavController>(
      /// init: This is very important here because we havent initialized the controller in this page
      /// If we run the code it will throw : Null check used on null operator error
      //   init: Get.put(BottomNavController()),
        builder: (controller){
      return controller.hasInternet==false?buildNoInternetPage(context):Scaffold(
        resizeToAvoidBottomInset: false,
          body: IndexedStack(
            index: controller.bottomIndex,
            children:  [
              MainScreen(),
              MatchedScreen(),
              // UploadTab(),
              UserProfileScreen(),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: BottomNavigationBar(
              onTap: (int index){
                controller.changeIndex(index);
              },

              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).primaryColor,
              currentIndex: controller.bottomIndex,
              unselectedItemColor: const Color(0xff707070),
              items: const [
                BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(Icons.all_inclusive)
                ),
                BottomNavigationBarItem(
                    label: 'Matched',
                    icon: Icon(Icons.watch)),
                // BottomNavigationBarItem(
                //     label: 'Boss',
                //     icon: Icon(Icons.add_box_outlined)),
                BottomNavigationBarItem(
                    label: 'Profile',
                    icon: Icon(Icons.account_circle_outlined)),
              ],
            ),
          ),
        extendBody: true,
      );
    });
  }

  Widget buildNoInternetPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(17),
                  bottomLeft: Radius.circular(17)),
          ),
        ),
        leading: InkWell(
            onTap: (){
              Get.off(()=>BottomNavigationPage());
            },
            child: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
              'assets/lottie/90478-disconnect.json',
              fit: BoxFit.contain,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4
          ),
          Text("Device is not connected to internet!",style: Theme.of(context).textTheme.caption!.copyWith(
              color: Theme.of(context).primaryColor
          ),)
        ],
      ),
    );
  }

}