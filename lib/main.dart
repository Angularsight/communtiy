import 'package:communtiy/bindings/bindings.dart';
import 'package:communtiy/controllers/auth_controller.dart';
import 'package:communtiy/controllers/google_sign_in_controller.dart';
import 'package:communtiy/getx_ui/bottom_nav_page.dart';
import 'package:communtiy/getx_ui/guest_list.dart';
import 'package:communtiy/getx_ui/party_details.dart';
import 'package:communtiy/getx_ui/splash_screen.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'getx_ui/main_screen.dart';
import 'getx_ui/matched_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Future.delayed(const Duration(seconds: 5)).then((value) => Get.put(AuthController()));
    Get.put(GoogleSignInController());
  });
  runApp(const MyApp2());
}


class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      /// InitialRoute always displays the first screen which appears after Hot Restart
      /// Irrespective of what is mentioned in home: field
      // initialRoute: '/bottomNav',
      // initialBinding: ControllerBindings(),
      defaultTransition: Transition.rightToLeftWithFade,
      themeMode: ThemeMode.light,
      theme: Themes().themeData(),
      home: const SplashScreen(),
      getPages: [
        GetPage(name: '/bottomNav',page: ()=> BottomNavigationPage()),
        GetPage(name: '/main', page: ()=> MainScreen()),
        GetPage(name: '/partyDetails', page: ()=> PartyDetails2()),
        GetPage(name: '/guestList', page: ()=> GuestList2()),
        GetPage(name: '/matched', page: ()=>MatchedScreen())
      ],
    );
  }
}



