



import 'package:communtiy/controllers/auth_controller.dart';
import 'package:communtiy/getx_ui/bottom_nav_page.dart';
import 'package:communtiy/getx_ui/new_ui/onboarding_screens.dart';
import 'package:communtiy/getx_ui/phone_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

import '../utils/theme.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  const OTPScreen({Key? key,required this.phoneNumber}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final AuthController authController = Get.find();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinNode = FocusNode();
  // final AuthController authController = Get.find();

  ///For phone verification
  String _verificationCode = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///This will call the below function which will send the OTP ASAP
    _verifyPhone();
  }


  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(15),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          gradient: Themes.logoGradient
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: (){
              _pinNode.unfocus();
            },
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                Center(
                  child: Text("Verify your \n Phone number",textAlign: TextAlign.center,style:GoogleFonts.roboto(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        const Shadow(
                            color: Colors.black,
                            offset: Offset(0,4),
                            blurRadius: 2
                        )
                      ]
                  )  ,),
                ),
                const SizedBox(height: 7,),
                Center(child:Text("Enter your OTP code here",style: GoogleFonts.roboto(
                  fontSize: 15,
                  color: Colors.grey.withOpacity(0.5),
                  fontWeight: FontWeight.normal,
                ),)),
                const SizedBox(height: 25,),


                Pinput(
                  closeKeyboardWhenCompleted: false,
                  length: 6,
                  keyboardType: TextInputType.number,
                  showCursor: false,
                  focusNode: _pinNode,
                  textInputAction: TextInputAction.none,
                  controller: _pinPutController,
                  onCompleted: (String pin)async{
                    try{
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(verificationId: _verificationCode, smsCode: pin))
                          .then((value) async{
                        if(value.user!=null){
                          print('User Logged in Successfully via pinPut');

                          ///Checking if the user(phoneNumber) already exists
                          ///If yes: Then we direct the user to the home screen
                          ///Else : We proceed to the on boarding section
                          var userExists = await authController.checkUserExistence2(int.parse(widget.phoneNumber));
                          if(userExists){
                            Get.to(()=>BottomNavigationPage());
                          }else{
                            Get.to(()=>OnBoardingScreen(phoneNumber: widget.phoneNumber,));
                          }
                        }
                      });
                    }catch(e){
                      FocusScope.of(context).unfocus();
                      Fluttertoast.showToast(
                          msg: 'Invalid OTP Entered',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                  },
                  submittedPinTheme: submittedPinTheme,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                ),


                const SizedBox(height: 25,),
                Center(child:Text("Didn't receive any code?",style:GoogleFonts.roboto(
                  fontSize: 15,
                  color: Colors.grey.withOpacity(0.5),
                  fontWeight: FontWeight.normal,
                ) ,)),
                const SizedBox(height: 10,),
                Center(child:InkWell(
                  onTap: (){
                    _verifyPhone();
                  },
                  child: Text("Resend OTP",style:GoogleFonts.roboto(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                  ) ,),
                )),
                SizedBox(height: h*0.05,),
                CircleAvatar(
                  radius: w*0.4,
                  backgroundColor: Theme.of(context).canvasColor,
                  child: Lottie.asset(
                      'assets/lottie/66346-marking-a-calendar.json',
                      width: w,
                      height: h*0.5
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: InkWell(
                    onTap: (){
                      Get.offAll(()=>PhoneLoginScreen());
                    },
                    child: Container(
                      width: w*0.5,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child:Text("Change Number",style: GoogleFonts.roboto(
                        color:Theme.of(context).scaffoldBackgroundColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _verifyPhone()async{
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phoneNumber}',

        /// On successful entry of the sent OTP the below function will be called
        verificationCompleted: (PhoneAuthCredential credential)async{
          await FirebaseAuth.instance.signInWithCredential(credential).then((value) async{
            if(value.user!=null){
              // _onBoardingController.loginType.value = 'Phone';
              print("User logged in successfully via _verifyPhone");
              var userExists = await authController.checkUserExistence2(int.parse(widget.phoneNumber));
              if(userExists){
                Get.to(()=>BottomNavigationPage());
              }else{
                Get.to(()=>OnBoardingScreen(phoneNumber: widget.phoneNumber,));
              }
            }else{
              print('Failure in logging in process');
            }
          });
        },
        verificationFailed: (FirebaseException e){
          print("Phone Verification error occured:${e.message}");
        },

        /// CodeSent sends the OTP to the mentioned phoneNumber
        codeSent: (String verificationID, int? resendToken){
          setState(() {
            _verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID){
          setState(() {
            _verificationCode = verificationID;
          });
        }

    );
  }


}
