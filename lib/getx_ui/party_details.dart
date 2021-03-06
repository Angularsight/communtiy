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
import 'package:shimmer/shimmer.dart';

class PartyDetails2 extends StatelessWidget {
  final int? index;
  PartyDetails2({Key? key, this.index}) : super(key: key);

  final FirebaseController controller = Get.find();
  final RazorPayController razorPayController = Get.put(RazorPayController());
  PageController pageController = PageController(initialPage: 0,viewportFraction: 0.8);

  List<HostModel> host = [];
  List<UserDetailsModel> guests = [];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h =  MediaQuery.of(context).size.height;
    final t = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Column(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: SizedBox(
                        height: h*0.3,
                        width: w,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context,thisIndex){
                              return imageCard(context,thisIndex);
                            },
                            separatorBuilder: (context,index)=>const SizedBox(width: 10,),
                            itemCount: controller.parties[index!].images!.length),
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    Container(
                        height: h*0.9,
                        width: w,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                            ),
                            gradient: Themes.partyDetailsGradient
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    GestureDetector(
                                      onTap:(){
                                        final partyDetails = controller.parties[index!];
                                        Get.to(()=>CheckoutPage(party: partyDetails, host: host[0],));
                                      },
                                      child: Container(
                                        width: w*0.3,
                                        height: h*0.07,
                                        decoration: BoxDecoration(
                                          color: t.primaryColor,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(30),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text("Enter Fest",style: t.textTheme.headline2!.copyWith(
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
                                    )
                                  ],
                                ),
                              ),

                              const SizedBox(height: 25,),
                              Flexible(
                                flex:5,
                                child: Container(
                                  width: w*0.50,
                                  height: h*0.07,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: Colors.black,width: 1.5)
                                  ),
                                  child: Center(child:buildStrokeText(controller.parties[index!].partyName!, t,Colors.black,Colors.white,22)),
                                ),
                              ),

                              const SizedBox(height: 20,),
                              buildStrokeText("Venue : ${controller.parties[index!].location}", t, Color(0xff5B5B5B), Colors.white,17),

                              const SizedBox(height: 15,),
                              Flexible(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 40.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Date : ${controller.parties[index!].date}",style: t.textTheme.headline3,),
                                      Text("Time : ${controller.parties[index!].time} pm",style: t.textTheme.headline3,),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Flexible(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 50.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text("Ratio : Will be updated ",style: t.textTheme.headline3,)),
                                      // Text("Host : ${controller.parties[index!].hostId}",style: t.textTheme.headline3,),
                                      FutureBuilder(
                                        builder: (context,AsyncSnapshot<List<HostModel>>snapshot){
                                          try{
                                            host = snapshot.data!;
                                            if(snapshot.hasData) {
                                              return Text("Host : ${host[0].hostName}",style: t.textTheme.headline3,);
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
                                                  width: 50,
                                                  height: 15,
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

                                      )
                                    ],
                                  ),
                                ),
                              ),


                              const SizedBox(height: 20,),
                              Flexible(
                                flex: 5,
                                child: Row(
                                  children: [
                                    buildStrokeText("Guest List", t, Color(0xff5B5B5B), Colors.white,17),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15.0),
                                      child: InkWell(
                                          splashColor: Colors.white,
                                          onTap: ()async{
                                            /// Fetching Guests and their interests of that particular party in this page itself
                                            await controller.fetchGuestsInterests(controller.parties[index!].guests!).then((value) {
                                              return Get.to(() =>  GuestList2(guests: guests,interests: value,));
                                            });
                                          },
                                          child: Icon(CustomIcons.chevronRight,color: const Color(0xff5B5B5B),)),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              const SizedBox(height: 10,),

                              FutureBuilder(builder: (context,AsyncSnapshot<List<UserDetailsModel>> snapshot){
                                try{
                                  guests = snapshot.data!;
                                  if(snapshot.hasData) {
                                    return SizedBox(
                                      width: w,
                                      height: h*0.1,
                                      child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context,thisIndex){
                                            return CircleAvatar(
                                              radius: 40,
                                              backgroundColor: Color(0xff1BC100),
                                              child: CircleAvatar(
                                                radius: 38,
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
                                          separatorBuilder: (context,index)=>const SizedBox(width: 12,),
                                          itemCount: controller.parties[index!].guests!.length),
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
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
                              ),


                              const SizedBox(height: 10,),
                              buildStrokeText("Time to celebrate", t, Color(0xff5B5B5B), Colors.white,17),
                              const SizedBox(height: 10,),
                              Text("${controller.parties[index!].description} ",style: t.textTheme.headline3,),

                            ],
                          ),
                        )
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(left: 0,top: h*0.34),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xff1BC100),
                    child: CircleAvatar(
                      radius: 48,
                      child: ClipOval(
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(controller.hostDetails[0].profilePic.toString()),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                      ),
                    ),
                  ),
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

  Widget imageCard(BuildContext context,int thisIndex) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0,bottom: 25,left: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width *0.8,
          child: Image.network(controller.parties[index!].images![thisIndex],fit: BoxFit.cover,),
        ),
      ),
    );
  }
}