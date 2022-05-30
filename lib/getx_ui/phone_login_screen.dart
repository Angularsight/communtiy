

import 'package:communtiy/controllers/auth_controller.dart';
import 'package:communtiy/controllers/google_sign_in_controller.dart';
import 'package:communtiy/getx_ui/OTP_screen.dart';
import 'package:communtiy/getx_ui/bottom_nav_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/onboarding_controller.dart';
import '../utils/theme.dart';
class PhoneLoginScreen extends StatelessWidget {
  PhoneLoginScreen({Key? key}) : super(key: key);


  final TextEditingController _phoneNoController = TextEditingController();

  final FocusNode _phoneNoNode = FocusNode();

  String email ='';
  String password = '';

  final GoogleSignInController googleSignInController = Get.find();
  final AuthController authController = Get.find();
  // final OnBoardingController onBoardingController = Get.put(OnBoardingController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final t = Theme.of(context);
    return GestureDetector(
      onTap: (){
        _phoneNoNode.unfocus();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: Themes.logoGradient
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          // backgroundColor: const Color(0xff292929),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: w,
                      height: h*0.4,
                      child: CustomPaint(
                        size: Size(w,(h*0.4*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                        painter: RPSCustomPainter(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: h*0.1,
                              width: 2,
                              color: const Color(0xff595959),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: h*0.05,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hi",style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: const Color(0xff909090),
                              fontWeight: FontWeight.bold
                          ),),
                          Text("Let's get you acquainted",style:GoogleFonts.roboto(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                const Shadow(
                                    color: Colors.black,
                                    offset: Offset(0,4),
                                    blurRadius: 2
                                )
                              ]
                          ) ,),
                          SizedBox(height: h*0.02,),
                          TextFormField(
                            controller: _phoneNoController,
                            focusNode: _phoneNoNode,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                letterSpacing: 18,
                                fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                                focusColor: Colors.transparent,
                                filled: true,
                                fillColor: const Color(0xff393939),
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

                          SizedBox(height: h*0.02,),
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
                                child: const Center(child: Text("Sign up via OTP",style:TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ) ,),),
                              ),
                            ),
                          ),
                          SizedBox(height: h*0.01,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account?",style: t.textTheme.headline1!.copyWith(
                                fontSize: 14,
                                color: const Color(0xff8E8E8E),
                              ),),
                              InkWell(
                                onTap: (){},
                                child: Text(" Login",style: t.textTheme.headline1!.copyWith(
                                  fontSize: 14,
                                  color: const Color(0xff439ACB),
                                )),
                              )
                            ],
                          ),
                          SizedBox(height: h*0.005,),

                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: w*0.45,
                          height: 1,
                          color: const Color(0xffC4C4C4),
                        ),
                        const SizedBox(width: 5,),
                        const Text("or",style: TextStyle(
                            color: Color(0xff838383)
                        ),),
                        const SizedBox(width: 5,),
                        Container(
                          width: w*0.48,
                          height: 1,
                          color: const Color(0xffC4C4C4),
                        ),
                      ],
                    ),
                    SizedBox(height: h*0.01,),
                    Center(
                      child: InkWell(
                        onTap: (){
                          // googleSignInController.googleLogin();
                        },
                        child: Container(
                          width: w*0.75,
                          height: h*0.055,
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
                          child: Padding(
                            padding:  const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Continue with Google",style:TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ) ,),
                                CircleAvatar(
                                    radius:25,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(child: Image.asset('assets/images/google logo.png',fit: BoxFit.contain)))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h*0.015,),
                    Center(
                      child: Container(
                        width: w*0.75,
                        height: h*0.055,
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
                        child:  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Continue with Instagram",style:TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ) ,),
                              CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/images/insta logo.png',fit: BoxFit.cover,))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: h*0.08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(child: Image.asset('assets/images/disco ball.png',fit: BoxFit.cover,)),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: h*0.25,
                right: w*0.05,
                child: Column(
                  children: [
                    SizedBox(
                      height: h*0.2,
                      width: w*0.4,
                      child: Image.asset('assets/images/image 9.png',fit: BoxFit.contain,),
                    ),
                    SizedBox(
                      child: CustomPaint(
                        size: Size(w*0.4,(75*
                            0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                        painter: RPSCustomPainter2(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
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
          colors: [Color(0xff060606),Color(0xffC4C4C4).withOpacity(0)],
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