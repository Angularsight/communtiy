

import 'package:communtiy/controllers/onboarding_controller.dart';
import 'package:communtiy/controllers/razorpay_controller.dart';
import 'package:communtiy/models/coupons/discountAndImage.dart';
import 'package:communtiy/models/host/host.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../utils/theme.dart';

class CheckoutPage extends StatefulWidget {
  final PartyDetails party;
  final HostModel host;
  final List<DiscountAndImage> discountAndImage;
  CheckoutPage({Key? key,required this.party,required this.host,required this.discountAndImage}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final RazorPayController razorPayController = Get.find();
  final OnBoardingController userController = Get.find();

  final TextEditingController couponController = TextEditingController();
  final TextEditingController friend1Controller = TextEditingController();
  final TextEditingController friend2Controller = TextEditingController();
  final TextEditingController friend3Controller = TextEditingController();
  final TextEditingController friend4Controller = TextEditingController();
  final TextEditingController friend5Controller = TextEditingController();

  final FocusNode couponNode = FocusNode();
  final FocusNode friend1Node = FocusNode();
  final FocusNode friend2Node = FocusNode();
  final FocusNode friend3Node = FocusNode();
  final FocusNode friend4Node = FocusNode();
  final FocusNode friend5Node = FocusNode();

  int discountPartyFee = 0;
  int discountPercent = -1;
  int discountAmount = 0;
  int friendDiscount = 0;
  int multiplier = 1;



  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final t = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: Themes.logoGradient
      ),
      child: GestureDetector(
        onTap: (){
          couponNode.unfocus();
          friend1Node.unfocus();
          friend2Node.unfocus();
          friend3Node.unfocus();
          friend4Node.unfocus();
          friend5Node.unfocus();
        },
        child: Scaffold(
          bottomNavigationBar:buildPaymentButton(w, h, t),

          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                                        image: NetworkImage(widget.party.images![0]),
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

                      Text(widget.party.partyName!,style: t.textTheme.caption!.copyWith(
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
                      buildPartyDetailRow(context, "Date", widget.party.date!, "Time", widget.party.time!),
                      SizedBox(height: h*0.013,),
                      buildPartyDetailRow(context, "Venue", widget.party.location!, "Organiser", widget.host.hostName!),

                      // insertDottedLine(),
                      // SizedBox(height: h*0.013,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w*0.03),
                        child: Container(
                          width: w,
                          padding: EdgeInsets.symmetric(vertical: h*0.02,horizontal: w*0.02),
                          decoration: BoxDecoration(
                            color: const Color(0xff0F343F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [

                              buildCouponCodeTile(context,w,h,widget.party),
                              SizedBox(height: h*0.02,),
                              buildInviteAndDiscountTile(context,w,h,widget.party),

                              SizedBox(height: h*0.02,),
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
                                  child:buildPaymentDetailsRow(context, "Entry Fee", "Rs.${widget.party.entryFee}")),

                              buildPaymentDetailsRow(context, "Finders fee", "Rs.20"),
                              if (discountPercent!=-1 && friendDiscount !=0) buildPaymentDetailsRow(context, "Discount", "Rs.${friendDiscount + discountAmount}")
                              else if(friendDiscount!=0)buildPaymentDetailsRow(context, "Discount", "Rs.$friendDiscount")
                              else if(discountPercent!=-1) buildPaymentDetailsRow(context, "Discount", "$discountPercent%")
                              else Row(),

                              if(friendDiscount!=0) buildPaymentDetailsRow(context, "No of tickets", "$multiplier")
                              else Row(),

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
                                    buildGrandTotalRow(w, h, t,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // SizedBox(height: h*0.013,),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       Text("Party Info",style: t.textTheme.headline3!.copyWith(
                      //           fontSize: 18,
                      //           color: Colors.white,
                      //         shadows: [
                      //           const Shadow(
                      //               color: Colors.black,
                      //               offset: Offset(0,4),
                      //               blurRadius: 2
                      //           ),
                      //           const Shadow(
                      //               color: Colors.black,
                      //               offset: Offset(0,4),
                      //               blurRadius: 1
                      //           )
                      //         ]
                      //       ),),
                      //     ],
                      //   ),
                      // ),
                      //
                      // buildPartyInfo(t),
                      // // const SizedBox(height: 25,),
                      // SizedBox(height: h*0.03,),

                    ],
                  )
            ),
          ),
        ),
      ),
    );
  }

  Padding buildPaymentButton(double w, double h, ThemeData t) {
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: w*0.16,vertical: h*0.01),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: w*0.8,
                height: h*0.05,
                // height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: t.canvasColor
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Rs.${getCheckAmount()}",
                    style: t.textTheme.headline3!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  )
                ),

              ),
              Positioned(
                left: w*0.2,
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
                      int checkoutAmount = getCheckAmount();
                      if(userController.userProfile.value.userName==null){
                        Fluttertoast.showToast(
                            msg: "Complete About You in profile to proceed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.SNACKBAR,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }else{
                        razorPayController.updateTicketDetails(widget.party,widget.host);
                        razorPayController.openCheckout(
                            widget.party.partyName!,
                            checkoutAmount,
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
                        const Icon(Icons.info_outline,size: 14,color: Colors.white,)
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

  Padding buildPaymentDetailsRow(BuildContext context, String title , String text) {
    final w = MediaQuery.of(context).size.width;
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 18, ),
      child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: w*0.3,
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

  Widget buildCouponCodeTile(BuildContext context,double w,double h,PartyDetails party) {

    String appliedCoupon ='';
    int couponStreakNo = 0; /// No coupon has streak=0, hence it can set as default value
    int couponIndex = -1;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: ExpansionTile(
            iconColor: Colors.white,
            backgroundColor: const Color(0xff062732),
            collapsedIconColor: Colors.white,
            collapsedBackgroundColor: const Color(0xff062732),
            title: Text("Apply Coupon Code",style: Theme.of(context).textTheme.headline1!.copyWith(
                color: Colors.white,
                fontSize: 18
            ),),
            children: [
              SizedBox(height: h*0.01,),
              SizedBox(
                width: w*0.8,
                child: TextFormField(
                  decoration: InputDecoration(
                      suffix: InkWell(
                          onTap: (){
                            print("Entered suffix :${couponController.text}");
                            /// Checking if applied coupon exists by looping through all coupon docs
                            /// Saving name and streakCount of applied coupon ie if it exists
                            for (var element in widget.discountAndImage) {
                              couponIndex+=1;
                              if(couponController.text == element.code){
                                print("Entered coupon exists");
                                appliedCoupon = couponController.text;
                                /// Below line will is used for fetching the coupon doc ID to upload all IDs the couponUsedBy list
                                userController.appliedCoupon.value = appliedCoupon;
                                couponStreakNo = element.streakCount!;
                                discountPercent = element.discount!;
                                print("appliedCoupon:$appliedCoupon \n couponStreak:$couponStreakNo \n couponIndex:$couponIndex");
                                break;
                              }
                            }
                            print("After appliedCoupon:$appliedCoupon \n couponStreak:$couponStreakNo \n couponIndex:$couponIndex");

                            /// If couponStreakNo is same as user streak
                            if((userController.userProfile.value.streaks==couponStreakNo)&&(appliedCoupon!='')){
                              print("Entered streak condition");
                              /// If the user hasn't already used the coupon
                              if(!widget.discountAndImage[couponIndex].couponUsedBy!.contains(userController.userProfile.value.userId)){
                                print("Satisfied all conditions for application of coupon");

                                /// Discount = partyFee - discountPercentage
                                setState(() {
                                  discountPercent = discountPercent;
                                  discountAmount = (party.entryFee! *(discountPercent/100)).toInt();
                                  discountPartyFee = (party.entryFee! - (party.entryFee! *(discountPercent/100))).toInt();
                                  print("DiscountedPartyFee:$discountPartyFee");
                                });

                                razorPayController.showSuccessDialogBox(context, w, h, discountAmount);

                              }
                            }

                          },
                          child: const Text("Apply",style: TextStyle(
                            color: Colors.white
                          ),)),
                      fillColor: const Color(0xff0F343F),
                      filled: true,
                      hintText: 'Paste coupon code here',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              style: BorderStyle.none))),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  key: const ValueKey('couponCode'),
                  controller: couponController,
                  focusNode: couponNode,
                  onFieldSubmitted: (String text){
                    couponController.text = text;
                  },
                ),
              ),
              SizedBox(height: h*0.01,),
            ],
          )
    );
  }

  Widget buildInviteAndDiscountTile(BuildContext context,double w, double h, PartyDetails party) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: ExpansionTile(
          iconColor: Colors.white,
          backgroundColor: const Color(0xff062732),
          collapsedIconColor: Colors.white,
          collapsedBackgroundColor: const Color(0xff062732),
          title: Text("Invite and get discount",style: Theme.of(context).textTheme.headline1!.copyWith(
              color: Colors.white,
              fontSize: 18
          ),),
        children: [
          Text("Invite 5 of your friends and get Rs.200/- off each",style: Theme.of(context).textTheme.headline1!.copyWith(
            color: const Color(0xffA0A0A0),
            fontSize: 14
          ),),
          Text("Invite 3 of your friends and get Rs.100/- off each ",style: Theme.of(context).textTheme.headline1!.copyWith(
              color: const Color(0xffA0A0A0),
              fontSize: 14
          )),
          SizedBox(height: h*0.01,),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: w*0.05,),
              Text("Copy your friends'  ID and paste here",style: Theme.of(context).textTheme.headline1!.copyWith(
                  color: Colors.white,
                  fontSize: 14
              )),
            ],
          ),
          buildFriendTextField(w,'Friend 1*',friend1Controller,friend1Node),
          buildFriendTextField(w, 'Friend 2*', friend2Controller, friend2Node),
          buildFriendTextField(w,'Friend 3*',friend3Controller,friend3Node),
          buildFriendTextField(w, 'Friend 4', friend4Controller, friend4Node),
          buildFriendTextField(w,'Friend 5',friend5Controller,friend5Node),
          SizedBox(height: h*0.01,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: ()async{
                  List<String> ids = [];
                  int existingGuestIndex = -1;
                  if(friend1Controller.text!=''&&friend2Controller.text!=''&&friend3Controller.text!=''){
                    if(friend4Controller.text!=''&& friend5Controller.text!=''){

                      if(friend5Controller.text=='' || friend4Controller.text==''){
                        Fluttertoast.showToast(
                            msg: 'Discounts are there are only for 3 or 5 people.',
                            backgroundColor: Colors.white
                        );
                      }
                      ids.add(friend1Controller.text);
                      ids.add(friend2Controller.text);
                      ids.add(friend3Controller.text);
                      ids.add(friend4Controller.text);
                      ids.add(friend5Controller.text);
                      razorPayController.friendsList.value = ids; // Storing ids to be used in ticket page for adding to guest list and increasing streaks
                      print("Friend 1:${friend1Controller.text}\n Friend 2:${friend2Controller.text} \n Friend 3:${friend3Controller.text} \n Friend 4:${friend4Controller.text} \n Friend 5:${friend5Controller.text}");

                      /// Check if these IDs are legit
                      var result = await userController.checkIfIdIsValid(ids);
                      if(result==5){
                        ///Check if they are already in the party

                        var partyGuests = party.guests!.cast<String>();
                        print('PartyGuests5 :$partyGuests');
                        for (var id in ids) {
                          print("Id in Ids5 :$id");
                          if (partyGuests.contains(id)) {
                            existingGuestIndex = ids.indexOf(id);
                            Fluttertoast.showToast(
                                msg: 'Friend ${existingGuestIndex +
                                    1} is already in the party\n Enter some other ID',
                                backgroundColor: Colors.white
                            );
                            return;
                          }
                        }

                        ///All conditions are satisfied for 5 friends
                        setState(() {
                          friendDiscount = 1000; // For 5 people
                          multiplier = 6; /// 6 coz 5+1 where 1 is the user himself
                        });
                        razorPayController.showSuccessDialogBox(context, w, h, friendDiscount);

                      }else{
                        Fluttertoast.showToast(
                            msg: '${3-result} of the ID is not correct',
                            backgroundColor: Colors.redAccent.shade200
                        );
                      }
                    }else{
                      ids.add(friend1Controller.text);
                      ids.add(friend2Controller.text);
                      ids.add(friend3Controller.text);
                      razorPayController.friendsList.value = ids; // Storing ids to be used in ticket page for adding to guest list and increasing streaks
                      print("Friend 1:${friend1Controller.text}\n Friend 2:${friend2Controller.text} \n Friend 3:${friend3Controller.text}");
                      /// Check if these IDs are legit
                      var result = await userController.checkIfIdIsValid(ids);
                      if(result==3){
                        ///Check if they are already in the party

                        var partyGuests = party.guests!.cast<String>();
                        print('PartyGuests :$partyGuests');
                        for (var id in ids) {
                          print("Id in Ids :$id");
                          if(partyGuests.contains(id)){
                            existingGuestIndex = ids.indexOf(id);
                            Fluttertoast.showToast(
                                msg: 'Friend ${existingGuestIndex+1} is already in the party\n Enter some other ID',
                                backgroundColor: Colors.white
                            );
                            return;
                          }
                        }

                        ///All conditions are satisfied for 3 friends
                        setState(() {
                          friendDiscount = 300;
                          multiplier = 4; /// 4 coz 3+1 where 1 is the user himself
                        });
                        razorPayController.showSuccessDialogBox(context, w, h, friendDiscount);

                      }else{
                        Fluttertoast.showToast(
                            msg: '${3-result} of the ID is not correct',
                            backgroundColor: Colors.redAccent.shade200
                        );
                      }
                    }


                  }else{
                    Fluttertoast.showToast(
                        msg: 'Enter at least 3 IDs to unlock discount',
                      backgroundColor: Colors.white
                    );
                  }
                },
                child: Container(
                  width: w*0.2,
                  height: h*0.05,
                  decoration: BoxDecoration(
                    color: const Color(0xff0F343F),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Center(child:Text("Apply",style: TextStyle(
                    color: Colors.white,
                  ),)),
                ),
              ),
              SizedBox(width: w*0.05,),
            ],
          ),
          SizedBox(height: h*0.01,),

        ],
      ),
    );
  }

  Padding buildFriendTextField(double w,String hintText,TextEditingController controller,FocusNode focusNode) {
    return Padding(
      padding: EdgeInsets.only(top: w*0.01),
      child: SizedBox(
            width: w*0.8,
            child: TextFormField(
              decoration: InputDecoration(

                  fillColor: const Color(0xff0F343F),
                  filled: true,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          style: BorderStyle.none))),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              controller: controller,
              focusNode: focusNode,
              onFieldSubmitted: (String text){
                controller.text = text;
              },
            ),
          ),
    );
  }

  SizedBox buildGrandTotalRow(double w, double h, ThemeData t) {
    if((discountPercent==-1)&& friendDiscount==0){
      return SizedBox(
          width: w*0.2,
          height: h*0.028,
          child: Text("Rs.${widget.party.entryFee!}",style: t.textTheme.headline3!.copyWith(
              color: const Color(0xffFAFF00),
              fontSize: 18
          ),));
    }else if((friendDiscount!=0)&&(discountPercent!=-1)){
      return SizedBox(
          width: w*0.2,
          height: h*0.028,
          child: Text("Rs.${(widget.party.entryFee!*multiplier)-friendDiscount-discountAmount}",style: t.textTheme.headline3!.copyWith(
              color: const Color(0xffFAFF00),
              fontSize: 18
          ),));
    }else if(friendDiscount!=0 && discountPercent==-1){
      return SizedBox(
          width: w*0.2,
          height: h*0.028,
          child: Text("Rs.${(widget.party.entryFee!*multiplier)-friendDiscount}",style: t.textTheme.headline3!.copyWith(
              color: const Color(0xffFAFF00),
              fontSize: 18
          ),));
    }else{
      return SizedBox(
          width: w*0.2,
          height: h*0.028,
          child: Text("Rs.$discountPartyFee",style: t.textTheme.headline3!.copyWith(
              color: const Color(0xffFAFF00),
              fontSize: 18
          ),));
    }
  }

  int getCheckAmount() {
    if((discountPercent==-1)&&friendDiscount==0){
      return widget.party.entryFee!.toInt();
    }else if((discountPercent!=-1)&&(friendDiscount!=0)){
      return ((widget.party.entryFee!.toInt()*multiplier) - discountAmount - friendDiscount);
    }else if(friendDiscount!=0 && discountPercent==-1){
      return ((widget.party.entryFee!.toInt()*multiplier) - friendDiscount);
    }else{
      return discountPartyFee;
    }
  }

}

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color = const Color(0xff868686)
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

