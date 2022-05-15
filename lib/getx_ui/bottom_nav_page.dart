

import 'package:communtiy/controllers/auth_controller.dart';
import 'package:communtiy/controllers/bottom_nav_controller.dart';
import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/getx_ui/main_screen.dart';
import 'package:communtiy/getx_ui/upload_tab.dart';
import 'package:communtiy/getx_ui/user_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      return Scaffold(
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
}