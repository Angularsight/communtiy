

import 'package:communtiy/getx_ui/user_upload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  late LiquidController liquidController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    liquidController = LiquidController();
  }

  @override
  Widget build(BuildContext context) {

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final pages = [
      buildPageOne(h,w),
      buildPageTwo(h,w),
      buildPageThree(h,w),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: LiquidSwipe(
        pages: pages,
        liquidController: liquidController,
        slideIconWidget: const Icon(Icons.arrow_back_ios_rounded,color: Colors.black,),
        waveType: WaveType.liquidReveal,
        enableSideReveal: true,
        ignoreUserGestureWhileAnimating: true,
        enableLoop: false,
        positionSlideIcon: 0.5,
        fullTransitionValue: 800,
      ),
    );
  }

  Widget buildPageOne(double h,double w) {

    const descriptionText = "Finding a place where everyone you see \nis single is sometimes considered as \nparadise. We at leagues are here to make \nthat place available to everyone.";

    return Container(
      width: double.infinity,
        color: const Color(0xffC34A4A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height:h*0.2),
          Container(
            width: w*0.75,
            height: h*0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // border: Border.all(color: Colors.black),
              image: const DecorationImage(image: AssetImage("assets/images/onboarding 1.png"),fit: BoxFit.cover)
            ),
          ),
          SizedBox(
            child: CustomPaint(
              size: Size(w*0.8,(h*0.3*
                  0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
              painter: RPSCustomPainter(),
            ),
          ),

          const SizedBox(height: 2,),

          const Text("A place where",style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),),

          // const SizedBox(height: 10,),
          Text("Everyone is single",style: Theme.of(context).textTheme.caption!.copyWith(
            fontSize: 30,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(0,4),
                blurRadius: 4
              )
            ]
          ),),

          const SizedBox(height: 10,),
          Text(descriptionText,textAlign: TextAlign.center,style: GoogleFonts.ptSans(
            fontSize: 14,
            // color: const Color(0xff353535),

          ))


        ],
      ),
    );
  }

  Widget buildPageTwo(double h,double w){

    const descriptionText = 'Swiping through 1000 profiles to get\n1 match is something no one wants.\nHere at leagues, each event or party you \ngo to is a fixed match since you will be \nmeeting someone. So indirectly you are \nskipping the swiping and texting phase.';

    return Container(
      width: double.infinity,
      color: const Color(0xffFC8C0F),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height:h*0.05),
          Container(
            width: w*0.75,
            height: h*0.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(color: Colors.black),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: h*0.21,
                  left: w*0.08,
                  child: ClipOval(
                    child: Container(
                      width: w*0.6,
                      height: h*0.18,
                      // alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.elliptical(100, 50)),
                        color: Theme.of(context).scaffoldBackgroundColor
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: w*0.08,bottom: 20),
                  child: Container(
                    width: w*0.6,
                    height: h*38,
                    decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/images/onboarding 2.png"),fit: BoxFit.cover)
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            child: CustomPaint(
              size: Size(w*0.6,(h*0.3*
                  0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
              painter: RPSCustomPainter(),
            ),
          ),

          const SizedBox(height: 2,),

          const Text("Beginning of",style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),),

          // const SizedBox(height: 10,),
          Text("End of swipes",style: Theme.of(context).textTheme.caption!.copyWith(
              fontSize: 30,
              color: Colors.white,
              shadows: [
                Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0,4),
                    blurRadius: 4
                )
              ]
          ),),

          const SizedBox(height: 10,),
          Text(descriptionText,textAlign: TextAlign.center,style: GoogleFonts.ptSans(
            fontSize: 14,
            // color: const Color(0xff353535),

          ))


        ],
      ),
    );
  }

  Widget buildPageThree(double h,double w){

    const descriptionText = "This app gives you the freedom to choose,\nthe place you want, the time of your choice \nand finally the partner of your match.";

    return Container(
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height:h*0.05),
          Container(
            width: w*0.75,
            height: h*0.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(color: Colors.black),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: h*0.21,
                  left: w*0.08,
                  child: ClipOval(
                    child: Container(
                      width: w*0.6,
                      height: h*0.18,
                      // alignment: Alignment.bottomCenter,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.elliptical(100, 50)),
                          color: Color(0xffEEE741)
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: w*0.14,top: h*0.1),
                  child: Container(
                    width: w*0.5,
                    height: h*38,
                    decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/images/onboaring 3.png"),fit: BoxFit.contain)
                    ),
                  ),
                )

              ],
            ),
          ),
          SizedBox(
            child: CustomPaint(
              size: Size(w*0.6,(h*0.3*
                  0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
              painter: RPSCustomPainter2(),
            ),
          ),

          const SizedBox(height: 2,),

          const Text("Who Where When",style: TextStyle(
            fontSize: 14,
            color: Color(0xffEEE741),
          ),),

          // const SizedBox(height: 10,),
          Text("You Here Now",style: Theme.of(context).textTheme.caption!.copyWith(
              fontSize: 30,
              color: Color(0xffEEE741),
              shadows: [
                Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0,4),
                    blurRadius: 4
                )
              ]
          ),),

          const SizedBox(height: 10,),
          Expanded(
            child: Text(descriptionText,textAlign: TextAlign.center,style: GoogleFonts.ptSans(
              fontSize: 14,
              color: const Color(0xff969696),
            )),
          ),



          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: Container(
                    width: w*0.3,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xffEEE741),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(child: Text("Next",style: GoogleFonts.ptSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),),),
                  ),
                  onTap: (){
                    Get.to(()=>UserUpload());
                  },
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color = const Color(0xff222222).withOpacity(0.1)
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

class RPSCustomPainter2 extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color = const Color(0xff222222)
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
