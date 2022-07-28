
import 'package:carousel_slider/carousel_slider.dart';
import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/controllers/razorpay_controller.dart';
import 'package:communtiy/getx_ui/checkout_page.dart';
import 'package:communtiy/getx_ui/guest_list.dart';
import 'package:communtiy/models/host/host.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:communtiy/utils/icons.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/onboarding_controller.dart';
import '../models/party_details.dart';

class PartyDetails2 extends StatelessWidget {
  final int? index;
  PartyDetails2({Key? key, this.index}) : super(key: key);

  final FirebaseController controller = Get.find();
  final RazorPayController razorPayController = Get.put(RazorPayController());
  final OnBoardingController userController = Get.find();
  // PageController pageController = PageController(initialPage: 0,viewportFraction: 0.8);

  List<HostModel> host = [];
  List<UserDetailsModel> guests = [];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h =  MediaQuery.of(context).size.height;
    final t = Theme.of(context);
    const defaultImageString = 'http://www.lyon-ortho-clinic.com/files/cto_layout/img/placeholder/book.jpg';
    List<String> imagesList = [];
    for (var element in controller.parties[index!].images!) {
      imagesList.add(element.toString());
    }

    return Scaffold(

      bottomNavigationBar: InkWell(
        onTap: ()async{
          var discountAndImages = await userController.fetchDiscountAndImages();
          Get.to(()=>CheckoutPage(party: controller.parties[index!], host: host[0],discountAndImage: discountAndImages,));
        },
        child: Container(
          width: w,
          height: h*0.06,
          decoration: BoxDecoration(
            color: t.primaryColor,
          ),
          child: Center(child:Text("Enter Fest",style: t.textTheme.headline2!.copyWith(
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0,3),
                  blurRadius: 4,
                )
              ],
              color: Colors.black,
              fontSize: 18
          ),)),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                SafeArea(
                  child: SizedBox(
                    height: h*0.6,
                    width: w,
                    // child: ListView.separated(
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (context,thisIndex){
                    //       return InkWell(
                    //           onTap: (){
                    //             openFullImageView(index,imagesList);
                    //           },
                    //           child: imageCard(context,thisIndex,w));
                    //     },
                    //     separatorBuilder: (context,index)=>const SizedBox(width: 0,),
                    //     itemCount: controller.parties[index!].images!.length),
                    child: CarouselSlider.builder(
                        itemCount: controller.parties[index!].images!.length,
                        itemBuilder: (context,thisIndex,realIndex){
                          return imageCard(context,thisIndex,w);
                        },
                        options: CarouselOptions(
                            height: h*0.6,
                            viewportFraction: 1,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: true,
                            initialPage: 0,
                            onPageChanged: (int index,reason){
                              // controller.pageIndicatorIndex.value = index;
                              controller.partyDetailsCarouselIndex.value = index;
                            }
                        )),
                  ),
                ),


                Column(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: h*0.55,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GetX<FirebaseController>(
                          builder: (ctr) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedSmoothIndicator(
                                  count: controller.parties[index!].images!.length ,
                                  activeIndex: ctr.partyDetailsCarouselIndex.value,
                                  effect: WormEffect(
                                      radius: 10,
                                      dotWidth: 12,
                                      dotHeight: 12,
                                      activeDotColor: t.primaryColor
                                  ),
                                ),
                              ],
                            );
                          }
                      ),
                    ),
                    Container(
                      // height: h*1.2,
                        width: w,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30)
                            ),
                            // gradient: Themes.partyDetailsGradient
                          color: Theme.of(context).scaffoldBackgroundColor
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  // width: w*0.50,
                                  height: h*0.07,
                                  decoration: BoxDecoration(
                                    color: t.primaryColor,
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30)
                                    ),
                                  ),
                                  child:  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: w*0.1),
                                    child: Center(
                                      child: Text(controller.parties[index!].partyName.toString(),style: t.textTheme.headline2!.copyWith(
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(0.2),
                                              offset: const Offset(0,3),
                                              blurRadius: 4,
                                            )
                                          ],
                                          color: Colors.black,
                                          fontSize: 18
                                      ),),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: h*0.025),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [


                                  SizedBox(height: h*0.02,),
                                  Row(
                                    children: [
                                      buildStrokeText2("Venue : ${controller.parties[index!].location}", t, Colors.white, Colors.black,17),
                                      SizedBox(width: w*0.02,),
                                      InkWell(
                                        onTap: ()async{
                                          var party = controller.parties[index!];
                                          String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${party.latitude}%2C${party.longitude}';
                                          if(await canLaunch(googleUrl)){
                                            await launch(googleUrl);
                                          }
                                        },
                                        child: Text('Directions',style: t.textTheme.headline1!.copyWith(
                                          color: const Color(0xff417ACF),
                                          fontSize: 14,
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 2,
                                        ),),
                                      )
                                    ],
                                  ),

                                  SizedBox(height: h*0.015,),
                                  Flexible(
                                    flex: 5,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: h*0.04),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height:h*0.03,
                                              width: w*0.56,
                                              child: Text("Date : ${controller.parties[index!].date}",style: t.textTheme.headline3!.copyWith(
                                                color: const Color(0xffCBCBCB)
                                              ),)),
                                          SizedBox(
                                              height:h*0.03,
                                              width: w*0.3,
                                              child: Text("Time : ${controller.parties[index!].time}",style: t.textTheme.headline3!.copyWith(
                                                  color: const Color(0xffCBCBCB)
                                              ),)),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: h*0.01,),
                                  Flexible(
                                    flex: 5,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: h*0.04),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height:h*0.03,
                                              width: w*0.56,
                                              child: Text("Ratio : Will be updated ",style: t.textTheme.headline3!.copyWith(
                                                  color: const Color(0xffCBCBCB)
                                              ),)),
                                          // Text("Host : ${controller.parties[index!].hostId}",style: t.textTheme.headline3,),
                                          GetX<FirebaseController>(
                                              builder: (controller) {
                                                return FutureBuilder(
                                                  builder: (context,AsyncSnapshot<List<HostModel>>snapshot){
                                                    try{
                                                      host = snapshot.data!;
                                                      if(snapshot.hasData) {
                                                        return SizedBox(

                                                            child: Text("Host : ${host[0].hostName}",style: t.textTheme.headline3!.copyWith(
                                                                color: const Color(0xffCBCBCB)
                                                            ),));
                                                      } else {
                                                        return const CircularProgressIndicator();
                                                      }
                                                    }catch(e){
                                                      return ClipRRect(
                                                        borderRadius: BorderRadius.circular(5),
                                                        child: Shimmer.fromColors(
                                                          baseColor: const Color(0xffd5d7d5),
                                                          highlightColor: const Color(0xfff3f3f3),
                                                          child: Container(
                                                            width: h*0.05,
                                                            height: h*0.022,
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(5)
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }

                                                  },
                                                  future: controller.fetchHostDetailsFuture(controller.parties[index!].hostId.toString()),

                                                );
                                              }
                                          )
                                        ],
                                      ),
                                    ),
                                  ),


                                  SizedBox(height: h*0.02,),
                                  Flexible(
                                    flex: 5,
                                    child: Row(
                                      children: [
                                        buildStrokeText2("Guest List", t, Colors.white, Colors.black,17),
                                        Padding(
                                          padding: EdgeInsets.only(right: w*0.05),
                                          child: InkWell(
                                              splashColor: Colors.white,
                                              onTap: ()async{
                                                /// Fetching Guests and their interests of that particular party in this page itself
                                                await controller.fetchGuestsInterests(controller.parties[index!].guests!).then((value) {
                                                  return Get.to(() =>  GuestList2(guests: guests,interests: value,));
                                                });
                                              },
                                              child: Icon(CustomIcons.chevronRight,color: Colors.white.withOpacity(0.75),)),
                                        )
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    ),
                                  ),
                                  SizedBox(height: h*0.01,),

                                  GetX<FirebaseController>(
                                      builder: (controller) {
                                        return FutureBuilder(builder: (context,AsyncSnapshot<List<UserDetailsModel>> snapshot){
                                          try{
                                            guests = snapshot.data!;
                                            if(snapshot.hasData) {
                                              final radius = w*0.1;
                                              return SizedBox(
                                                width: w,
                                                height: h*0.1,
                                                child: ListView.separated(
                                                    scrollDirection: Axis.horizontal,
                                                    itemBuilder: (context,thisIndex){
                                                      return CircleAvatar(
                                                        // radius: 40,
                                                        radius: radius,
                                                        backgroundColor: const Color(0xffEEE741),
                                                        child: CircleAvatar(
                                                          radius: radius-2,
                                                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                          // radius: 38,
                                                          child: ClipOval(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(controller.guests[thisIndex].userProfilePic.toString()),
                                                                      fit: BoxFit.cover
                                                                  )
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder: (context,index)=>SizedBox(width: w*0.025),
                                                    itemCount: controller.parties[index!].guests!.length),
                                              );
                                            } else {
                                              return CircularProgressIndicator(color: Theme.of(context).scaffoldBackgroundColor,);
                                            }
                                          }catch(e){
                                            return Shimmer.fromColors(
                                              baseColor: const Color(0xffd5d7d5),
                                              highlightColor: const Color(0xfff3f3f3),
                                              child: const CircleAvatar(
                                                radius: 40,
                                                backgroundColor: Colors.white,
                                              ),);
                                          }

                                        },
                                          future: controller.fetchGuests(controller.parties[index!].guests!),
                                        );
                                      }
                                  ),


                                  SizedBox(height: h*0.01,),
                                  buildStrokeText2("Time to celebrate", t, Colors.white, Colors.black,17),
                                  SizedBox(height: h*0.01,),
                                  Text("${controller.parties[index!].description} ",style: t.textTheme.headline3!.copyWith(
                                      color: const Color(0xffCBCBCB)
                                  ),),
                                  SizedBox(height: h*0.01,),
                                  buildStrokeText2("Activities", t, Colors.white, Colors.black,17),
                                  buildActivitiesSection2(context,controller.parties[index!]),
                                  SizedBox(height: h*0.01,),
                                  buildStrokeText2("Special Appearances", t, Colors.white, Colors.black,17),
                                  buildSpecialAppearanceSection2(context,controller.parties[index!]),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),

                  ],
                ),

                Positioned(
                  right: 10,
                  top: h*0.55,
                  child:InkWell(
                      onTap: (){
                        openFullImageView(index,imagesList);
                      },
                      child: const Icon(Icons.fullscreen,color: Colors.white,size: 25,)),
                )

              ],
            )


          ],
        ),
      ),
    );
  }

  Stack buildStrokeText(String text, ThemeData t,Color color,Color strokeColor,double fontSize) {
    return Stack(
      children: [
        Text(text,style: t.textTheme.headline2!.copyWith(
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0,3),
                blurRadius: 4,
              ),
            ],
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1
              ..color = strokeColor,
            fontSize: fontSize
        ),),
        Text(text.toString(),style: t.textTheme.headline2!.copyWith(
            color: color,
            fontSize: fontSize
        ),)
      ],
    );
  }

  Stack buildStrokeText2(String text, ThemeData t,Color color,Color strokeColor,double fontSize) {
    return Stack(
      children: [
        Text(text,style: t.textTheme.headline2!.copyWith(
            shadows: [
              const Shadow(
                color: Colors.black,
                offset: Offset(0,3),
                blurRadius: 4,
              ),
            ],
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = strokeColor,
            fontSize: fontSize,
          fontWeight: FontWeight.normal
        ),),
        Text(text.toString(),style: t.textTheme.headline2!.copyWith(
            color: color,
            fontSize: fontSize,
          fontWeight: FontWeight.normal
        ),)
      ],
    );
  }

  Widget imageCard(BuildContext context,int thisIndex,double w) {
    return Padding(
      padding: EdgeInsets.only(right: w*0.015),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width,
          child: Image.network(controller.parties[index!].images![thisIndex],fit: BoxFit.cover,),
        ),
      ),
    );
  }

  Widget buildActivitiesSection(BuildContext context, PartyDetails party) {
    final activities = {};
    for (String element in party.activities!) {
      final split = element.toString().split(',');
      activities[split[0]] = split[1];
    }

    if(activities.isEmpty){
      activities['Null'] = 1;
    }

    final t = Theme.of(context);
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
            minHeight: h*0.05,
            maxHeight: h*0.3
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color:t.scaffoldBackgroundColor),
        ),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: activities.length,
            itemBuilder: (context,index){
              return !activities.keys.contains("Null")?Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    buildStrokeText(activities.keys.toList()[index], t, Colors.black87, Colors.white, 14),
                    Text(activities[activities.keys.toList()[index]].toString(),style: t.textTheme.headline3),
                    SizedBox(height: h*0.01,)
                  ],
                ),
              ):Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(child: Text("No activities in this event as of yet",style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                )),)
              );
            }),
      ),
    );
  }

  Widget buildActivitiesSection2(BuildContext context, PartyDetails party) {
    final activities = {};
    for (String element in party.activities!) {
      final split = element.toString().split(',');
      activities[split[0]] = split[1];
    }

    if(activities.isEmpty){
      activities['Null'] = 1;
    }

    final t = Theme.of(context);
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
            minHeight: h*0.05,
            maxHeight: h*0.3
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color:const Color(0xffCBCBCB)),
        ),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: activities.length,
            itemBuilder: (context,index){
              return !activities.keys.contains("Null")?Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    buildStrokeText2(activities.keys.toList()[index], t, Colors.white, Colors.black, 14),
                    Text(activities[activities.keys.toList()[index]].toString(),style: t.textTheme.headline3!.copyWith(
                        color: const Color(0xffCBCBCB),
                      fontSize: 15
                    )),
                    SizedBox(height: h*0.01,)
                  ],
                ),
              ):Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(child: Text("No activities in this event as of yet",style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  )),)
              );
            }),
      ),
    );
  }

  Widget buildSpecialAppearanceSection(BuildContext context, PartyDetails party) {
    final t = Theme.of(context);
    final h = MediaQuery.of(context).size.height;
    if (party.specialAppearance!) {
      return Padding(
      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.05,top: 10,bottom: h*0.025),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(party.djPhoto!),
                    fit: BoxFit.cover),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)
                )
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.8),
                      offset: const Offset(0,4),
                      blurRadius: 4,
                      spreadRadius: 0
                  )
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(party.djName!,style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ) ,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: h*0.03,
                      child: Text("Playing : ",style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.normal
                      ),),
                    ),
                    SizedBox(
                      height: h*0.03,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index)=>index!=party.playing!.length-1?Text("${party.playing![index]},",style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.normal
                          )):Text("${party.playing![index]}",style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.normal
                          )),
                          separatorBuilder: (context,index)=>const SizedBox(width: 2,),
                          itemCount: party.playing!.length)
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: h*0.01,right: h*0.015,bottom: h*0.025),
        child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color:t.scaffoldBackgroundColor),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Text("Not available for this event ",style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              )),
              Text("Keep looking in other parties",style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: const Color(0xff5B5B5B),
                  fontSize: 18
              ),)
            ],
          ),
        ),
    ),
      );
    }
  }

  Widget buildSpecialAppearanceSection2(BuildContext context, PartyDetails party) {
    final t = Theme.of(context);
    final h = MediaQuery.of(context).size.height;
    if (party.specialAppearance!) {
      return Padding(
        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.05,top: 10,bottom: h*0.025),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(party.djPhoto!),
                      fit: BoxFit.cover),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)
                  )
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: const Offset(0,4),
                        blurRadius: 4,
                        spreadRadius: 0
                    )
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(party.djName!,style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ) ,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: h*0.03,
                        child: Text("Playing : ",style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.normal
                        ),),
                      ),
                      SizedBox(
                          height: h*0.03,
                          child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context,index)=>index!=party.playing!.length-1?Text("${party.playing![index]},",style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal
                              )):Text("${party.playing![index]}",style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal
                              )),
                              separatorBuilder: (context,index)=>const SizedBox(width: 2,),
                              itemCount: party.playing!.length)
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: h*0.01,right: h*0.015,bottom: h*0.025),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color:const Color(0xffCBCBCB)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Text("Not available for this event ",style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                )),
                Text("Check out other parties",style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 18
                ),)
              ],
            ),
          ),
        ),
      );
    }
  }

  void openFullImageView(int? index, List<String> imagesList) {
    Get.to(()=>FullImageView(imageList:imagesList));
  }
}

class FullImageView extends StatefulWidget {
  final List<String> imageList;
  const FullImageView({Key? key,required this.imageList}) : super(key: key);

  @override
  _FullImageViewState createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          itemCount: widget.imageList.length,
          builder: (context,index){
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.imageList[index]),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 4,
            );
          }),
    );
  }
}
