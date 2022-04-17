

import 'package:communtiy/controllers/google_sign_in_controller.dart';
import 'package:communtiy/getx_ui/bottom_nav_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'phone_login_screen.dart';

class LoginReRouteScreen extends StatelessWidget {
  LoginReRouteScreen({Key? key}) : super(key: key);

  final GoogleSignInController googleSignInController = Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child:CircularProgressIndicator(color: Theme.of(context).primaryColor,));
            }else if(snapshot.hasData){
              return BottomNavigationPage();
            }else if(snapshot.hasError){
              return const Center(child:Text("Error in logging in via firebase"));
            }else{
              return PhoneLoginScreen();
            }
          }),
    );
  }
}
