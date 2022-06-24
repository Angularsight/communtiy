


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communtiy/controllers/onboarding_controller.dart';
import 'package:communtiy/controllers/razorpay_controller.dart';
import 'package:communtiy/getx_ui/bottom_nav_page.dart';
import 'package:communtiy/models/host/host.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketPage extends StatelessWidget {
   TicketPage({Key? key}) : super(key: key);

   final RazorPayController razorPayController = Get.find();
   final OnBoardingController userController = Get.find();




   void uploadGuestToParty(PartyDetails party)async{

     /// Getting the documentId using partyId which is unique to each party
     var v = await FirebaseFirestore.instance.collection("PartyDetails").where('partyId',isEqualTo: party.partyId).get();
     var docId = v.docs[0].id;
     print("DocumentId :$docId");

     /// Uncomment the below part to add current user to the guest List.
     /// Updating guestList of the particular party using docId
     List<dynamic> newGuestList = party.guests!;

     ///If the user is already in the party then no need to add him again
     if(!newGuestList.contains(FirebaseAuth.instance.currentUser!.uid)){
       print("ADDED NEW GUEST TO FIREBASE");
       newGuestList.add(FirebaseAuth.instance.currentUser!.uid);
     }


     FirebaseFirestore.instance.collection("PartyDetails").doc(docId).update({
       'guests': newGuestList
     });


     /// Add partyId to history list
     /// Instead of storing the qr Image we have stored the information required to generate the QR image
     /// The same information can be used to replicate the QR code in party history tab
     var userDoc = await FirebaseFirestore.instance.collection("UserDetails").where('userId',isEqualTo: userController.currentUser.uid).get();
     var userDocId = userDoc.docs[0].id;
     FirebaseFirestore.instance.collection("UserDetails").doc(userDocId).collection("History").doc().set({
       'partyId':party.partyId,
       'partyImage':party.images![0],
       'partyName':party.partyName,
       'partyDate':party.date,
       'partyTime':party.time,
       'partyVenue':party.location,
       'partyHost':razorPayController.host!.hostName,
       'qrDetail': razorPayController.paymentId,
     });

   }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final t = Theme.of(context);
    final party = razorPayController.partyDetails;
    final host = razorPayController.host;
    uploadGuestToParty(party!);

    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(party.images![0]),
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1),BlendMode.dstATop),
                    fit: BoxFit.cover)
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: h*0.15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: w*0.9,
                        height: h*0.55,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CustomPaint(
                            size: Size(w*0.9,(h*0.55*0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                            painter: RPSCustomPainter2(),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0,right: 10,top: 100),
                              child: Column(
                                children: [
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

                                  const SizedBox(height: 5,),
                                  buildPartyDetailRow(context, "Date", party.date!, "Time", party.time!),
                                  const SizedBox(height: 15,),
                                  insertDottedLine(),
                                  const SizedBox(height: 20,),
                                  buildPartyDetailRow(context, "Venue", party.location!, "Organiser", host!.hostName!),


                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: h*0.095),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          radius: 55,
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
                      size: Size(100,(75*
                          0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                      painter: RPSCustomPainter(),
                    ),
                  ),

                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: h*0.56),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: h*0.32,
                    width: w*0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(colors: [
                        Color(0xff1B1B1B),
                        Color(0xff525252),
                        Color(0xff525252)
                      ],
                        stops: [0,0.7,1],
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: h*0.03,),
                        Container(
                          height: h*0.2,
                          width: w*0.415,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: t.canvasColor,width: 1)
                          ),

                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: fetchQrImage(party, host),
                            ),
                          ),


                        ),
                        const SizedBox(height: 10,),
                        Text("Booking Confirmed",style: t.textTheme.caption!.copyWith(
                          fontSize: 30,
                          color: Colors.white
                        ),),
                        Text("Ticket ID: ${razorPayController.paymentId}",style: GoogleFonts.ptSans(
                          fontSize: 12,
                          color: const Color(0xff6D6D6D)
                        ),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 80,
              bottom: 20,
              child: InkWell(
                onTap: (){

                  /// Removes or pops all previous pages in the stack
                  Get.offAll(()=>BottomNavigationPage(),
                      transition: Transition.downToUp,
                      duration: const Duration(milliseconds: 500)
                  );
                },
                child: Container(
                  width: w*0.6,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: t.canvasColor,
                  ),
                  child: Center(
                    child: Text("Back to Home",style: t.textTheme.headline1!.copyWith(
                      fontSize: 18,
                      color: Colors.black
                    ),),
                  ),

                ),
              ),
            ),


          ],
        ),
      );
  }

  QrImage fetchQrImage(PartyDetails party, HostModel host) {

    return QrImage(
                              data:'partyName:${party.partyName}\n'
                                  'paymentId:${razorPayController.paymentId} \n '
                                  'Date:${party.date} @${party.time} \n '
                                  'Venue:${party.location} \n '
                                  'Host:${host.hostName}',
                              backgroundColor: Colors.white,
                              size: 200,);
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

   Padding insertDottedLine() {
     return  Padding(
       padding: const EdgeInsets.only(left: 10.0),
       child: DottedLine(
         // dashRadius: 6,
         // dashGapRadius: 6,
         dashLength: 6,
         // lineThickness: 6,
         dashGapLength: 5,
         dashColor: Colors.grey.withOpacity(0.7),
       ),
     );
   }


  // Future<String> saveImageToGallery(BuildContext context,Uint8List screenshot) async{
  //
  //   /// SAVING IMAGE PART
  //   /// Requesting storage permission from the mobile to store the image in gallery
  //   // await [Permission.storage].request();
  //
  //   final imageName = 'ticket_${DateTime.now().toIso8601String().replaceAll('.', "_").replaceAll(":", "_")}';
  //
  //   /// This saves the taken screenshot into the gallery and returns the path of the file
  //   final result = await ImageGallerySaver.saveImage(screenshot,name: imageName);
  //   Scaffold.of(context).showSnackBar(SnackBar(content: Container(
  //     width: double.infinity,
  //     height: 50,
  //     child: Row(
  //       children: [
  //         Text("Screenshot saved to Gallery",style: Theme.of(context).textTheme.headline1!.copyWith(
  //           fontSize: 18,
  //           color: Colors.white
  //         ),),
  //         const SizedBox(width: 10,),
  //         Icon(CustomIcons.check,color: Colors.green,)
  //       ],
  //     ),
  //   )));
  //   return result['filePath'];
  //
  // }


}

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color = const Color(0xff363636)
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

    var rect = Offset.zero & size;
    Paint paint0 = Paint()
      ..shader = Themes.transparentGradient.createShader(rect)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;


    Path path0 = Path();
    path0.moveTo(0,0);
    path0.lineTo(size.width,0);
    path0.lineTo(size.width,size.height*0.4700000);
    path0.quadraticBezierTo(size.width*0.9587500,size.height*0.4742857,size.width*0.9583333,size.height*0.4985714);
    path0.quadraticBezierTo(size.width*0.9587500,size.height*0.5232143,size.width,size.height*0.5285714);
    path0.lineTo(size.width,size.height);
    path0.lineTo(0,size.height);
    path0.lineTo(0,size.height*0.5300000);
    path0.quadraticBezierTo(size.width*0.0412500,size.height*0.5250000,size.width*0.0416667,size.height*0.4985714);
    path0.quadraticBezierTo(size.width*0.0412500,size.height*0.4703571,0,size.height*0.4714286);
    path0.lineTo(0,0);
    path0.close();

    canvas.drawPath(path0, paint0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}



