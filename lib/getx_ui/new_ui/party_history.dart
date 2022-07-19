


import 'dart:ui';

import 'package:communtiy/controllers/history_controller.dart';
import 'package:communtiy/controllers/razorpay_controller.dart';
import 'package:communtiy/models/user_details/history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';


class PartyHistory extends StatelessWidget {
  PartyHistory({Key? key}) : super(key: key);

  final HistoryController historyController = Get.put(HistoryController());
  final RazorPayController razorPayController = Get.put(RazorPayController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back,color: Colors.white,)),
                    SizedBox(width: w*0.03,),
                    Text("History",style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: Colors.white,
                      fontSize: 25,
                    ),)
                  ],
                ),
                const SizedBox(height: 25,),
                GetX<HistoryController>(
                  builder: (c) {
                    if (c.historyList.value.isEmpty) {
                      return Padding(
                      padding: EdgeInsets.only(top: h*0.1),
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/lottie/lf20_bsvekh57.json',
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.4
                          ),
                          Text("Attend parties to fill your history",style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Theme.of(context).primaryColor
                          ),)
                        ],
                      ),
                    );
                    } else {
                      return SizedBox(
                      width: w,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: c.historyList.value.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return buildHistoryTile(context,index,w,h,c);
                          }));
                    }
                  }
                ),
              ],
            ),
          ),
          ),
      ),
      );
  }

  Widget buildHistoryTile(BuildContext context,int index,double w, double h, HistoryController c) {
        var history = c.historyList.value[index];
        var t = Theme.of(context).textTheme.headline1;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            width: w,
            height: h*0.4,
            decoration: BoxDecoration(
              color: const Color(0xff171717),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  offset: const Offset(0,2),
                  spreadRadius: 0,
                  blurRadius: 4
                )
              ]
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                children: [
                  if (history.partyImage==null)
                    SizedBox(
                        width: w,
                        height: h*0.3,
                        child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)))
                  else
                    Image.network(history.partyImage!,fit: BoxFit.cover,width: w,height: h*0.3,),
                  const SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(history.partyName.toString(),style: t!.copyWith(
                          color: Colors.white,
                          fontSize: 25,
                        ),),
                        InkWell(
                          onTap: (){
                            showQrCodeImage(context, history);
                          },
                          child: Container(
                            width: w*0.27,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).primaryColor
                            ),
                            child: Center(child: Text("QR Code",style: t.copyWith(
                              color: Colors.black,
                            ),),),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Venue : ${history.partyVenue}",style: t.copyWith(
                            color: Colors.white,
                            fontSize: 14
                        ),),
                        Text("Time : ${history.partyTime}",style: t.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        ),),
                        Text("Price: Rs.500",style: t.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        ),),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
  }

  void showQrCodeImage(BuildContext context,History history) {
    showDialog(
        context: context,
        builder: (context){
          var w = MediaQuery.of(context).size.width;
          var h = MediaQuery.of(context).size.height;
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Dialog(
              // backgroundColor: const Color(0xff737477).withOpacity(0.9),
              // backgroundColor: const Color(0xff182d4d),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: w*0.8,
                    height: h*0.38,
                    child: QrImage(
                      data:'partyName:${history.partyName}\n'
                          'paymentId:${history.qrDetail} \n '
                          'Date:${history.partyDate} @${history.partyTime} \n '
                          'NoOfTickets:${razorPayController.friendsList.value.length}'
                          'Venue:${history.partyVenue} \n '
                          'Host:${history.partyHost}',
                      backgroundColor: Colors.transparent,
                      size: h*0.5,)

                  ),
                ),
              ),
            ),
          );
        }
    );
  }


}
