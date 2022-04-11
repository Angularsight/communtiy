

import 'package:communtiy/getx_ui/bottom_nav_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'phone_login_screen.dart';

class LoginReRouteScreen extends StatelessWidget {
  const LoginReRouteScreen({Key? key}) : super(key: key);

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
