

import 'package:communtiy/controllers/auth_controller.dart';
import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/controllers/history_controller.dart';
import 'package:communtiy/controllers/onboarding_controller.dart';
import 'package:communtiy/getx_ui/new_ui/new_user_upload.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'new_ui/about_you_screen.dart';
import 'new_ui/party_history.dart';



class ChartData {
  final double label;
  final int qty;
  final Color? color;

  ChartData(this.label, this.qty, this.color);
}

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({Key? key}) : super(key: key);
  final OnBoardingController userController = Get.put(OnBoardingController());
  final HistoryController historyController = Get.put(HistoryController());
  final FirebaseController partyController = Get.find();
  // final loginUser = FirebaseAuth.instance.currentUser!;

  void bindStreamToUser(){
    userController.userProfile.bindStream(userController.connectUserToApp());
  }

  @override
  Widget build(BuildContext context) {
    bindStreamToUser();
    var user = userController.userProfile.value;
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final s = MediaQuery.of(context).textScaleFactor;

    // print("FirebaseAuth user:${loginUser.displayName},${loginUser.email},${loginUser.photoURL}");

    List<ChartData> chartData = [];

    chartData.add(ChartData(3, 15, const Color(0xff7E3299)));
    chartData.add(ChartData(2, 10, const Color(0xffBEA86D)));
    chartData.add(ChartData(1, 20, const Color(0xff8CDB80)));

    var t = Theme.of(context);

    double streaksValue = -1;
    if(userController.userProfile.value.streaks!=null){
      streaksValue = userController.userProfile.value.streaks!.toDouble();
    } else{
      streaksValue = 0.5;
    }

    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          // physics: const RangeMaintainingScrollPhysics(),
          child: GetX<OnBoardingController>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: w*0.02,top: w*0.05),
                            child: SizedBox(
                              width: w*0.42,
                              child: controller.userProfile.value.userName!=null?Text("${user.userName}",style: t.textTheme.headline1!.copyWith(
                                  fontSize: 23*s,
                                  color: Colors.white
                              ),):Text("Legend",style: t.textTheme.headline1!.copyWith(
                                  fontSize: 23*s,
                                  color: Colors.white
                              ),),
                            ),
                          ),
                          SizedBox(height: h*0.023,),

                          RotatedBox(
                            quarterTurns: 1,
                            child: SizedBox(
                              width: w*0.35,
                              height: h*0.2,
                              child: BarChart(BarChartData(
                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    fitInsideVertically: true,
                                    direction: TooltipDirection.top,
                                  )
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                  border: const Border(
                                    top: BorderSide.none,
                                    right: BorderSide.none,
                                    left: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)
                                  ),
                                ),
                                titlesData: FlTitlesData(show: false),
                                gridData: FlGridData(show: false),
                                groupsSpace: 25,
                                barGroups: [
                                  BarChartGroupData(x: 1,barRods: [
                                    BarChartRodData(toY: historyController.historyList.value.length.toDouble(),
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(10)),
                                        width: 15,
                                        color: Colors.green)
                                  ]),
                                  BarChartGroupData(x: 2,barRods: [
                                    BarChartRodData(toY: streaksValue.toDouble(),

                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(10)),
                                        width: 15,
                                        color: Theme.of(context).canvasColor)
                                  ]),
                                  BarChartGroupData(x: 3,barRods: [
                                    BarChartRodData(toY: partyController.parties.length.toDouble(),
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(10)),
                                        width: 15,
                                        color: const Color(0xff7E3299))
                                  ])
                                ]
                              )),
                            ),
                          )
                        ],
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(200),
                        ),
                        child: Container(
                          width: w*0.55,
                          height: h*0.35,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: controller.userProfile.value.userProfilePic!=null?
                          Image.network(user.userProfilePic.toString(),fit: BoxFit.cover,)
                              :Image.asset('assets/images/Drinks with Wings 3.png',fit: BoxFit.cover,),
                          // child: fetchProfileImage(user),
                          // child: Image.asset('assets/images/Rectangle 101.png',fit: BoxFit.cover,),
                        ),
                      )

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 5,
                          ),
                          const SizedBox(width: 2,),
                          Text("Attended",style: t.textTheme.headline1!.copyWith(
                            color: Colors.white,
                            fontSize: 15*s,
                          ))
                        ],
                      ),
                      SizedBox(width: w*0.03,),

                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).canvasColor,
                            radius: 5,
                          ),
                          const SizedBox(width: 2,),
                          Text("Streaks",style: t.textTheme.headline1!.copyWith(
                            color: Colors.white,
                            fontSize: 15*s,
                          ))
                        ],
                      ),
                      SizedBox(width: w*0.03,),

                      Row(
                        children:  [
                          const CircleAvatar(
                            backgroundColor: Colors.purple,
                            radius: 5,
                          ),
                          const SizedBox(width: 2,),
                          Text("Total Events",style: t.textTheme.headline1!.copyWith(
                            color: Colors.white,
                            fontSize: 15*s,
                          ))
                        ],
                      ),

                    ],
                  ),
                  SizedBox(height: h*0.023,),

                  Container(
                    width: w*0.7,
                    height: h*0.043,
                    decoration: BoxDecoration(
                      color: t.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0,4),
                          blurRadius: 4,
                          spreadRadius: 0
                        )
                      ]
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w*0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("League Wallet",style: t.textTheme.headline1!.copyWith(
                            color: t.primaryColor,
                            fontSize: 19*s,
                          ),),
                          Text('coming soon',style: t.textTheme.headline1!.copyWith(
                            color: const Color(0xff417ACF),
                            fontSize: 13*s,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                          ),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: h*0.031,),

                  // buildProfileListTile(w, context,'Bookmarks','Parties and people',Icons.bookmark),
                  buildProfileListTile(w, context, 'History', 'All parties attended', Icons.history),
                  buildProfileListTile(w, context, 'Invite and earn', 'Coming Soon',Icons.repeat),
                  buildProfileListTile(w, context, 'About You', 'Your credentials and details',Icons.vpn_key_rounded),
                  buildProfileListTile(w, context, 'Switch Account', 'Want to login from a different account?', Icons.logout)

                ],
              );
            }
          ),
        ),
      )
    );
  }

  Image fetchProfileImage(UserDetailsModel user) {
    try{
      return Image.network(user.userProfilePic.toString(),fit: BoxFit.cover,);
    }catch(e){
      return Image.asset('assets/images/Rectangle 101.png',fit: BoxFit.cover,);
    }

  }

  Widget buildProfileListTile(double w, BuildContext context, String heading, String subHeading, IconData icon) {
    final s = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding:EdgeInsets.only(bottom: w*0.05),
      child: InkWell(
        onTap: ()async{
          if(heading=="Switch Account"){
            // logoutOfAccount();
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    backgroundColor: Theme.of(context).canvasColor,
                    title: const Text("Log Out"),
                    content: const Text("Are you sure you want to log out of this account?"),
                    actions: [
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(w*0.02),
                            child: InkWell(
                              onTap: (){
                                logoutOfAccount();
                              },
                              child: Center(child: Text("Confirm",style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.redAccent,
                                  fontSize: 15*s
                              ),),),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(w*0.02),
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Center(child: Text("Cancel",style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff1A3841),
                                  fontSize: 15*s
                              ),),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                });
          }else if(heading=="History"){
            Get.to(()=> PartyHistory());

          }else if(heading=='About You'){
            final AuthController authController = Get.find();
            var userExistence = await authController.checkUserExistence3(FirebaseAuth.instance.currentUser!.uid);

            if(userExistence==true){
              var interests = await userController.fetchUserInterests(userController.userProfile.value.userId.toString());
              Get.to(()=> AboutYouScreen(interests: interests,));
            }else{
              Get.to(()=>NewUserUpload(phoneNumber: FirebaseAuth.instance.currentUser!.phoneNumber,));
            }

          }
        },
        child: Container(
                      width: w,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(50)
                          ),
                          border: Border.all(color: Colors.transparent),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(0,4),
                                blurRadius: 4,
                                spreadRadius: 0
                            )
                          ]
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w*0.02,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(heading,style: Theme.of(context).textTheme.headline1!.copyWith(
                                  fontSize: 19*s,
                                  color: Colors.white
                                ),),
                                Text(subHeading,style: Theme.of(context).textTheme.headline1!.copyWith(
                                  fontSize: 11.5*s,
                                  color: const Color(0xff707070)
                                ),)
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(w*0.03),
                              child: Icon(icon,color: Theme.of(context).primaryColor,size: 25,),
                            )
                          ],
                        ),
                      ),
                    ),
      ),
    );
  }
  logoutOfAccount()async{
    await FirebaseAuth.instance.signOut();
  }
}






