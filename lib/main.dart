import 'package:communtiy/getx_ui/bottom_nav_page.dart';
import 'package:communtiy/getx_ui/guest_list.dart';
import 'package:communtiy/getx_ui/party_details.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/providers/firebase_provider.dart';
import 'package:communtiy/ui/home_page.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


import 'getx_ui/main_screen.dart';
import 'getx_ui/matched_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      defaultTransition: Transition.rightToLeftWithFade,
      themeMode: ThemeMode.light,
      theme: Themes().themeData(),
      home: BottomNavigationPage(),
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



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>FirebaseProvider()),
        ChangeNotifierProvider(create: (_)=>PartyDetails())
      ],

      builder: (context,child){
        return MaterialApp(
          title: 'Project Community',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
