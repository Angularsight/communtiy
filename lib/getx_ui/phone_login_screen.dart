

import 'package:communtiy/controllers/auth_controller.dart';
import 'package:communtiy/controllers/google_sign_in_controller.dart';
import 'package:communtiy/getx_ui/OTP_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../utils/theme.dart';
class PhoneLoginScreen extends StatelessWidget {
  PhoneLoginScreen({Key? key}) : super(key: key);


  final TextEditingController _phoneNoController = TextEditingController();

  final FocusNode _phoneNoNode = FocusNode();

  String email ='';
  String password = '';

  /// Do not delete the below line since internet check is happening in GoogleSignInController
  final GoogleSignInController googleSignInController = Get.put(GoogleSignInController());
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final t = Theme.of(context);
    final s = MediaQuery.of(context).textScaleFactor;
    return GetX<AuthController>(
      builder: (controller) {
        if (controller.hasInternet==false) {
          return buildNoInternetPage(context);
        } else {
          return GestureDetector(
          onTap: (){
            _phoneNoNode.unfocus();
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: Themes.logoGradient
              // color: Theme.of(context).scaffoldBackgroundColor
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              // backgroundColor: const Color(0xff292929),
              extendBodyBehindAppBar: true,
              body: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: h*0.72),
                    child: Container(
                      width: w,
                      height: h*0.3,
                      decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30)
                          )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: h*0.07,),
                          Text("Pick up lines 101:",style:GoogleFonts.roboto(
                            fontSize: 16*s,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontWeight: FontWeight.bold,
                          ) ,),
                          const SizedBox(height: 10,),
                          Container(
                            width: w*0.85,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xff00171F),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(
                              child:Text("I ought to complain to Spotify for you not being named this week’s hottest single.",style:GoogleFonts.roboto(
                                fontSize: 13*s,
                                color: const Color(0xffB8B8B8),
                                fontWeight: FontWeight.bold,
                              ),textAlign: TextAlign.center,) ,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// OLD DESIGN IS IN PREVIOUS COMMITS COPY FROM THERE IF NEEDED
                        Lottie.asset(
                          'assets/lottie/78167-rollin.json',
                          width: w,
                          height: h*0.5
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text("Hi",style: GoogleFonts.roboto(
                        //           fontSize: 18,
                        //           // color: const Color(0xff909090),
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.bold
                        //       ),),
                        //       Text("Let's get you acquainted",style:GoogleFonts.roboto(
                        //           fontSize: 22,
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.bold,
                        //           shadows: [
                        //             const Shadow(
                        //                 color: Colors.black,
                        //                 offset: Offset(0,4),
                        //                 blurRadius: 2
                        //             )
                        //           ]
                        //       ) ,),
                        //       SizedBox(height: h*0.02,),
                        //       TextFormField(
                        //         controller: _phoneNoController,
                        //         focusNode: _phoneNoNode,
                        //         keyboardType: TextInputType.phone,
                        //         style: const TextStyle(
                        //             fontSize: 17,
                        //             color: Colors.white,
                        //             letterSpacing: 18,
                        //             fontWeight: FontWeight.bold,
                        //         ),
                        //         decoration: InputDecoration(
                        //           counterText: '',
                        //             focusColor: Colors.transparent,
                        //             filled: true,
                        //             fillColor: const Color(0xff393939),
                        //             border: OutlineInputBorder(
                        //                 borderRadius: BorderRadius.circular(12),
                        //                 borderSide: const BorderSide(
                        //                     style: BorderStyle.none
                        //                 ),
                        //             ),
                        //             prefix: const Text("+91",style: TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 17
                        //             ),),
                        //             // prefixIcon: const Icon(Icons.phone,color: Color(0xff767676),size: 35,),
                        //             hintText: "Phone Number",
                        //             hintStyle: const TextStyle(
                        //                 fontSize: 16,
                        //                 color: Color(0xff767676),
                        //               letterSpacing: 1
                        //             )
                        //         ),
                        //         maxLength: 10,
                        //         onFieldSubmitted: (text){
                        //           email = text;
                        //         },
                        //       ),
                        //
                        //       SizedBox(height: h*0.02,),
                        //       Center(
                        //         child: InkWell(
                        //           onTap: ()async{
                        //             /// Meaning we are closing these pages for good.
                        //             if(_phoneNoController.text.length!=10){
                        //               Fluttertoast.showToast(
                        //                   msg: "Phone Number is not 10 digits",
                        //                   toastLength: Toast.LENGTH_SHORT,
                        //                   gravity: ToastGravity.SNACKBAR,
                        //                   timeInSecForIosWeb: 1,
                        //                   backgroundColor: Colors.red,
                        //                   textColor: Colors.white,
                        //                   fontSize: 16.0
                        //               );
                        //             }else{
                        //               Get.offAll(()=> OTPScreen(phoneNumber: _phoneNoController.text,));
                        //             }
                        //           },
                        //           child: Container(
                        //             width: w*0.4,
                        //             height: h*0.05,
                        //             decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(20),
                        //                 color: const Color(0xff1E1E1E),
                        //                 boxShadow: [
                        //                   BoxShadow(
                        //                       color: Colors.black.withOpacity(0.8),
                        //                       offset: const Offset(0,4),
                        //                       blurRadius: 4,
                        //                       spreadRadius: 0
                        //                   )
                        //                 ]
                        //             ),
                        //             child: const Center(child: Text("Sign up via OTP",style:TextStyle(
                        //                 fontSize: 17,
                        //                 color: Colors.white,
                        //                 fontWeight: FontWeight.bold
                        //             ) ,),),
                        //           ),
                        //         ),
                        //       ),
                        //
                        //     ],
                        //   ),
                        // ),

                        Container(
                          width: w*0.9,
                          height: h*0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).canvasColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(0,4),
                                blurRadius: 5,
                                spreadRadius: 0
                              )
                            ]
                          ),
                          child:Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hi",style: GoogleFonts.roboto(
                                    fontSize: 17*s,
                                    // color: const Color(0xff909090),
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    fontWeight: FontWeight.bold
                                ),),
                                Text("Let's get you acquainted",style:GoogleFonts.roboto(
                                    fontSize: 19*s,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    fontWeight: FontWeight.bold,
                                ) ,),
                                SizedBox(height: h*0.02,),
                                Text("Phone Number",style:GoogleFonts.roboto(
                                  fontSize: 15*s,
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  fontWeight: FontWeight.bold,
                                ) ,),
                                TextFormField(
                                  controller: _phoneNoController,
                                  focusNode: _phoneNoNode,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      fontSize: 16*s,
                                      color: Colors.white,
                                      letterSpacing: 12,
                                      fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                      focusColor: Colors.transparent,
                                      filled: true,
                                      fillColor: const Color(0xff00171F),
                                      // fillColor: const Color(0xff393939),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              style: BorderStyle.none
                                          ),
                                      ),
                                      prefix: const Text("+91",style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17
                                      ),),
                                      // prefixIcon: const Icon(Icons.phone,color: Color(0xff767676),size: 35,),
                                      hintText: "Phone Number",
                                      hintStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff767676),
                                        letterSpacing: 1
                                      )
                                  ),
                                  maxLength: 10,
                                  onFieldSubmitted: (text){
                                    email = text;
                                  },
                                ),

                                SizedBox(height: h*0.04,),
                                Center(
                                  child: InkWell(
                                    onTap: ()async{
                                      /// Meaning we are closing these pages for good.
                                      if(_phoneNoController.text.length!=10){
                                        Fluttertoast.showToast(
                                            msg: "Phone Number is not 10 digits",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.SNACKBAR,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      }else{
                                        Get.offAll(()=> OTPScreen(phoneNumber: _phoneNoController.text,));
                                      }
                                    },
                                    child: Container(
                                      width: w*0.4,
                                      height: h*0.05,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: const Color(0xff1E1E1E),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black.withOpacity(0.8),
                                                offset: const Offset(0,4),
                                                blurRadius: 4,
                                                spreadRadius: 0
                                            )
                                          ]
                                      ),
                                      child: Center(child: Text("Sign up ",style:TextStyle(
                                          fontSize: 16*s,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ) ,),),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
        }
      }

    );
  }

  Widget buildNoInternetPage(BuildContext context) {
    return Scaffold(
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

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {


    var rect = Offset.zero & size;
    Paint paint0 = Paint()
      ..shader = LinearGradient(
          colors: [const Color(0xff060606),const Color(0xffC4C4C4).withOpacity(0)],
          // colors: [const Color(0xffC4C4C4),const Color(0xffC4C4C4).withOpacity(0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
      ).createShader(rect)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;


    Path path0 = Path();
    path0.moveTo(size.width*0.0008333,size.height*0.0014286);
    path0.lineTo(size.width*0.9991667,0);
    path0.lineTo(size.width,size.height*0.6414286);
    path0.quadraticBezierTo(size.width*0.8535417,size.height*0.8557143,size.width*0.7108333,size.height*0.8600000);
    path0.cubicTo(size.width*0.5333333,size.height*0.8582143,size.width*0.4650000,size.height*0.6489286,size.width*0.3333333,size.height*0.6457143);
    path0.quadraticBezierTo(size.width*0.1468750,size.height*0.6450000,0,size.height*0.9971429);
    path0.lineTo(size.width*0.0008333,size.height*0.0014286);
    path0.close();

    canvas.drawPath(path0, paint0);
    canvas.drawShadow(path0, Colors.black.withAlpha(100), 4.0, false);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class RPSCustomPainter2 extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
    // ..color = const Color(0xff222222)
      ..color = const Color(0xff222222).withOpacity(0.8)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;


    Path path0 = Path();
    path0.moveTo(size.width*0.0425000,size.height*0.5000000);
    path0.quadraticBezierTo(size.width*0.0691500,size.height*0.4356000,size.width*0.4991667,size.height*0.4271429);
    path0.quadraticBezierTo(size.width*0.9290750,size.height*0.4326286,size.width*0.9566667,size.height*0.5000000);
    path0.quadraticBezierTo(size.width*0.9220000,size.height*0.5474571,size.width*0.4994417,size.height*0.5717143);
    path0.quadraticBezierTo(size.width*0.0633000,size.height*0.5479429,size.width*0.0425000,size.height*0.5000000);
    path0.close();

    canvas.drawPath(path0, paint0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}