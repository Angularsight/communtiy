

import 'package:communtiy/controllers/onboarding_controller.dart';
import 'package:communtiy/controllers/razorpay_controller.dart';
import 'package:communtiy/models/host/host.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/utils/icons.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../utils/theme.dart';

class CheckoutPage extends StatelessWidget {
  final PartyDetails party;
  final HostModel host;
  CheckoutPage({Key? key,required this.party,required this.host}) : super(key: key);
  final RazorPayController razorPayController = Get.find();
  final OnBoardingController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final t = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: Themes.logoGradient
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: w*0.015,right: w*0.015,bottom: w*0.015,top: h*0.1),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      // radius: 55,
                      radius: w*0.125,
                      child: ClipOval(
                          child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(party.images![0]),
                                  fit: BoxFit.cover
                                )
                              ),
                          ),
                      )
                    )
                  ],
                ),
                SizedBox(
                  child: CustomPaint(
                    size: Size(100,(50*
                        0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                    painter: RPSCustomPainter(),
                  ),
                ),

                Text(party.partyName!,style: t.textTheme.caption!.copyWith(
                  shadows: [
                    const Shadow(
                      color: Colors.black,
                      offset: Offset(0,4),
                      blurRadius: 2
                    ),
                    const Shadow(
                        color: Colors.black,
                        offset: Offset(0,4),
                        blurRadius: 1
                    )
                  ],
                  fontSize: 32,
                  color: Colors.white
                ),),

                SizedBox(height: h*0.018,),
                buildPartyDetailRow(context, "Date", party.date!, "Time", party.time!),
                // const SizedBox(height: 10,),
                SizedBox(height: h*0.013,),
                buildPartyDetailRow(context, "Venue", party.location!, "Organiser", host.hostName!),

                insertDottedLine(),
                SizedBox(height: h*0.013,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: w*0.015,horizontal: h*0.018),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Payment Details",style: t.textTheme.headline3!.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                              color: Colors.black,
                              offset: Offset(0,4),
                              blurRadius: 2
                          ),
                          const Shadow(
                              color: Colors.black,
                              offset: Offset(0,4),
                              blurRadius: 1
                          )
                        ]
                      ),),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: h*0.013),
                    child:buildPaymentDetailsRow(context, "Entry Fee", "Rs.${party.entryFee}")),

                buildPaymentDetailsRow(context, "Finders fee", "Rs.20"),
                buildPaymentDetailsRow(context, "Discount", "20%"),
                Padding(
                  padding: EdgeInsets.only(left: h*0.02,top: h*0.008 ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: w*0.3,
                          height: h*0.028,
                          child: Text("Grand Total",style: t.textTheme.headline3!.copyWith(
                              color: const Color(0xffFAFF00),
                              fontSize: 18
                          ),)),
                      SizedBox(
                          width: w*0.2,
                          height: h*0.028,
                          child: Text("Rs.${(party.entryFee! - (party.entryFee! * 0.2)).toInt()}",style: t.textTheme.headline3!.copyWith(
                              color: const Color(0xffFAFF00),
                              fontSize: 18
                          ),))
                    ],
                  ),
                ),
                // const SizedBox(height: 20,),
                SizedBox(height: h*0.025,),
                insertDottedLine(),
                // const SizedBox(height: 10,),
                SizedBox(height: h*0.013,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Party Info",style: t.textTheme.headline3!.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                        shadows: [
                          const Shadow(
                              color: Colors.black,
                              offset: Offset(0,4),
                              blurRadius: 2
                          ),
                          const Shadow(
                              color: Colors.black,
                              offset: Offset(0,4),
                              blurRadius: 1
                          )
                        ]
                      ),),
                    ],
                  ),
                ),

                buildPartyInfo(t),
                // const SizedBox(height: 25,),
                SizedBox(height: h*0.03,),

                Stack(
                  children: [
                    Container(
                      width: w*0.7,
                      height: h*0.05,
                      // height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: t.canvasColor
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Rs.${(party.entryFee! - (party.entryFee! * 0.2)).toInt()}",
                        style: t.textTheme.headline3!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                        ),
                      ),

                    ),
                    Positioned(
                      left: 80,
                      child: Container(
                        width: w*0.45,
                        height: h*0.05,
                        // height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: t.canvasColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: const Offset(-4,4),
                              blurRadius: 4,
                              spreadRadius: 0
                            )
                          ]
                        ),
                        child: InkWell(
                          onTap: (){
                            if(userController.userProfile.value.userName==null){
                              Fluttertoast.showToast(
                                  msg: "Complete onboarding in profile to proceed",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }else{
                              razorPayController.updateTicketDetails(party,host);
                              razorPayController.openCheckout(
                                  party.partyName!,
                                  (party.entryFee! - (party.entryFee! * 0.2)).toInt(),
                                  "7411001185",
                                  "angularsight77@gmail.com",
                                  ["Gpay","paytm","PhonePe"],
                                  "9482397595");
                            }

                          },
                          child: Center(
                            child: Text("Proceed to Payment",
                              style: t.textTheme.headline3!.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                fontWeight: FontWeight.normal
                              ),
                            ),
                          ),
                        ),

                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildPartyInfo(ThemeData t) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Ratio",style: t.textTheme.headline3!.copyWith(
                      color: Colors.white,
                    ),),
                    Text("1:1.2",style: t.textTheme.headline3!.copyWith(
                      color: Colors.orange,
                      fontSize: 14
                    ),),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Event Scale",style: t.textTheme.headline3!.copyWith(
                      color: Colors.white,
                    ),),
                    Row(
                      children: [
                        Text("Medium",style: t.textTheme.headline3!.copyWith(
                            color: Colors.white,
                            fontSize: 14
                        ),),
                        const SizedBox(width: 5,),
                        Icon(Icons.info_outline,size: 14,color: Colors.white,)
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Percentage",style: t.textTheme.headline3!.copyWith(
                      color: Colors.white,
                    ),),
                    Text("58%",style: t.textTheme.headline3!.copyWith(
                        color: Colors.green,
                        fontSize: 14
                    ),),
                  ],
                ),
              ],
            );
  }

  Padding insertDottedLine() {
    return const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: DottedLine(
                dashRadius: 5,
                dashGapRadius: 5,
                dashLength: 5,
                lineThickness: 5,
                dashGapLength: 5,
                dashColor: Color(0xffC4C4C4),
              ),
            );
  }

  Padding buildPaymentDetailsRow(BuildContext context, String title , String text) {
    final w = MediaQuery.of(context).size.width;
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 18, ),
      child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: w*0.2,
                      height: 25,
                      child: Text(title,style: t.textTheme.headline3!.copyWith(
                        color: Colors.white,
                        fontSize: 14
                      ),)),
                  SizedBox(
                      width: w*0.2,
                      height: 25,
                      child: Text(text,style: t.textTheme.headline3!.copyWith(
                          color: Colors.white,
                          fontSize: 14
                      ),)),
                ],
              ),
    );
  }

  Padding buildPartyDetailRow(BuildContext context,String head,String headText, String tail ,String tailText) {
    final t = Theme.of(context);
    final w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height:head=="Date"? 60:90,
                    width: w*0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(head,style: t.textTheme.headline3!.copyWith(
                          color: const Color(0xffB5B5B5),
                          fontSize: 18
                        ),),
                        const SizedBox(height: 5,),
                        Text(headText,style: t.textTheme.headline3!.copyWith(
                          color: Colors.white,
                          fontSize: 18
                        ),)
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 60,
                    width: w*0.22,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tail,style: t.textTheme.headline3!.copyWith(
                          color: const Color(0xffB5B5B5),
                            fontSize: 18
                        ),),
                        const SizedBox(height: 5,),
                        Text(tailText,style: t.textTheme.headline3!.copyWith(
                            color: Colors.white,
                            fontSize: 18
                        ),)
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 65, 71, 75)
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

