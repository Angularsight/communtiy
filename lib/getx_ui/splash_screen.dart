import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:communtiy/getx_ui/bottom_nav_page.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final t = Theme.of(context);
    final s = MediaQuery.of(context).textScaleFactor;

    /// SHOULD NOT USE THIS TIMER SINCE THE ROUTING IS ALREADY BEING DONE IN main.dart via getX authentication (line : 20)
    // Timer(const Duration(seconds: 5), (){
    //   print("Went to Bottom nav via Splash Screen");
    //   Get.to(()=>BottomNavigationPage());
    // });
    return Container(
      decoration: BoxDecoration(
        gradient: Themes.logoGradient
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bare logo.png',
              width: w,
              height: h*0.15,
            ),
            SizedBox(height: h*0.05,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildLetters(w, t, "L"),
                buildLetters(w, t, "E"),
                buildLetters(w, t, "A"),
                buildLetters(w, t, "G"),
                buildLetters(w, t, "U"),
                buildLetters(w, t, "E"),
                buildLetters(w, t, "S"),
                // buildLetters(w, t, "T"),
                // buildLetters(w, t, "Y"),
              ],
            ),
            SizedBox(height: h*0.01,),

            SizedBox(
              width: w,
              height: h*0.05,
              child: DefaultTextStyle(
                style: t.textTheme.headline3!.copyWith(
                    fontSize: 17*s,
                  foreground: Paint()
                    ..shader = LinearGradient(
                                  colors: [const Color(0xffC4C4C4),const Color(0xffC4C4C4).withOpacity(0.22)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  pause: const Duration(milliseconds: 200),

                    animatedTexts: [
                      RotateAnimatedText("A place where everyone is single"),
                      // RotateAnimatedText("Who|When|Where"),
                      // RotateAnimatedText("You|Here|Now"),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildLetters(double w, ThemeData t, String letter) {
    return Container(
      width: w * 0.1,
      height: w * 0.1,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: t.primaryColor)),
      child: Center(
          child: Text(
        letter,
        style: t.textTheme.headline1!.copyWith(
            fontSize: w*0.05, fontWeight: FontWeight.bold, color: t.primaryColor),
      )),
    );
  }
}
