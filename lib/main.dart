import 'package:communtiy/controllers/auth_controller.dart';
import 'package:communtiy/controllers/google_sign_in_controller.dart';
import 'package:communtiy/getx_ui/bottom_nav_page.dart';
import 'package:communtiy/getx_ui/guest_list.dart';
import 'package:communtiy/getx_ui/party_details.dart';
import 'package:communtiy/getx_ui/splash_screen.dart';
import 'package:communtiy/utils/local_notification_service.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'getx_ui/main_screen.dart';
import 'getx_ui/matched_screen.dart';

///Receive message when app is in background solution for on message
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background Message:${message.notification?.title}");
  print("Background Message :${message.notification?.body}");
  LocalNotificationService.display(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Future.delayed(const Duration(seconds: 5)).then((value) => Get.put(AuthController()));
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp2());
}

class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  State<MyApp2> createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    LocalNotificationService.initialize(context);

    /// Allows user to go to BottomNavigationPage on tap
    /// When app is in terminated state
    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if(message.notification != null){
        print(message.notification!.body);
        print(message.notification!.title);
      }
      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if(message.notification != null){
        print(message.notification!.body);
        print(message.notification!.title);
      }
      Get.to(()=>BottomNavigationPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    ///Prevents app from going into landscape view or mode
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
        GetPage(name: '/bottomNav', page: () => BottomNavigationPage()),
        GetPage(name: '/main', page: () => MainScreen()),
        GetPage(name: '/partyDetails', page: () => PartyDetails2()),
        GetPage(name: '/guestList', page: () => GuestList2()),
        GetPage(name: '/matched', page: () => MatchedScreen())
      ],
    );
  }
}
