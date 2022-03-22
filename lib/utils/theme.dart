import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static LinearGradient appBarGradient = LinearGradient(colors: [
    const Color(0xff333333),
    const Color(0xff303030).withOpacity(0.47)
  ]);

  static LinearGradient transparentGradient = LinearGradient(colors: [
    const Color(0xffC4C4C4).withOpacity(0.25),
    const Color(0xffC4C4C4).withOpacity(0.35)
  ]);

  static LinearGradient tempBodyGradient = LinearGradient(colors: [
    const Color(0xff2E3549),
    const Color(0xff040404).withOpacity(0.89),
    const Color(0xff040404)
  ], stops: const [0.7, 0.9, 1],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);

  static LinearGradient softBlackGradient = LinearGradient(colors: [Colors.black.withOpacity(0.0),const Color(0xff0C0C0C).withOpacity(0.7),const Color(0xff0C0C0C).withOpacity(0.8)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.0,0.5,1]
  );

  static LinearGradient partyDetailsGradient = const LinearGradient(colors: [
    Color(0xffE3D170),
    Color(0xffFFFFFF)
  ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter
  );

  static LinearGradient softBlackGradientReverse = LinearGradient(colors: [const Color(0xff0C0C0C).withOpacity(0.8),const Color(0xff0C0C0C).withOpacity(0.7),Colors.black.withOpacity(0.0),],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.0,0.5,1]
  );

  ThemeData themeData() {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xff292929),
      primaryColor: const Color(0xffFAFF00),
      canvasColor: const Color(0xffE3D170),
      backgroundColor: Colors.white,
      textTheme: TextTheme(
          caption: GoogleFonts.rancho(fontWeight: FontWeight.normal, fontSize: 30),
          headline1: GoogleFonts.reemKufi(fontSize: 18),
          headline2: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          headline3: GoogleFonts.ptSerif(fontSize: 16, fontWeight: FontWeight.normal)),
    );
  }
}