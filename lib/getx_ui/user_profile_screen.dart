

import 'package:communtiy/controllers/onboarding_controller.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    // print("FirebaseAuth user:${loginUser.displayName},${loginUser.email},${loginUser.photoURL}");

    List<ChartData> chartData = [];

    chartData.add(ChartData(3, 15, const Color(0xff7E3299)));
    chartData.add(ChartData(2, 10, const Color(0xffBEA86D)));
    chartData.add(ChartData(1, 20, const Color(0xff8CDB80)));

    var t = Theme.of(context);
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
                                  fontSize: 24,
                                  color: Colors.white
                              ),):Text("Legend",style: t.textTheme.headline1!.copyWith(
                                  fontSize: 24,
                                  color: Colors.white
                              ),),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          RotatedBox(
                            quarterTurns: 1,
                            child: SizedBox(
                              width: w*0.45,
                              height: h*0.2,
                              child: BarChart(BarChartData(
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
                                    BarChartRodData(toY: 6,
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(10)),
                                        width: 15,
                                        color: Colors.green)
                                  ]),
                                  BarChartGroupData(x: 2,barRods: [
                                    BarChartRodData(toY: 5,
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(10)),
                                        width: 15,
                                        color: Theme.of(context).canvasColor)
                                  ]),
                                  BarChartGroupData(x: 3,barRods: [
                                    BarChartRodData(toY: 7,
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
                  const SizedBox(height: 20,),

                  Padding(
                    padding: EdgeInsets.only(left: w*0.02),
                    child: Text("League Wallet",style: t.textTheme.headline1!.copyWith(
                      fontSize: 20,
                      color: Colors.white
                    ),),
                  ),
                  Container(
                    width: w*0.7,
                    height: 35,
                    decoration: BoxDecoration(
                      color: t.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)
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
                          Text("Balance: 50 coins",style: t.textTheme.headline1!.copyWith(
                            color: t.primaryColor,
                            fontSize: 20,
                          ),),
                          Text('Refill',style: t.textTheme.headline1!.copyWith(
                            color: const Color(0xff417ACF),
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                          ),)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25,),

                  // buildProfileListTile(w, context,'Bookmarks','Parties and people',Icons.bookmark),
                  buildProfileListTile(w, context, 'History', 'All parties attended', Icons.history),
                  buildProfileListTile(w, context, 'Invite and earn', 'Invite will earn you a free party including cover charges',Icons.repeat),
                  buildProfileListTile(w, context, 'Credentials', 'Phone No,name,password',Icons.vpn_key_rounded),
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
    return Padding(
      padding:EdgeInsets.only(bottom: w*0.05),
      child: InkWell(
        onTap: (){
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
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                logoutOfAccount();
                              },
                              child: const Center(child: Text("Confirm",style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.redAccent,
                                  fontSize: 16
                              ),),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: const Center(child: Text("Cancel",style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1A3841),

                                  fontSize: 16
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
                                  fontSize: 20,
                                  color: Colors.white
                                ),),
                                Text(subHeading,style: Theme.of(context).textTheme.headline1!.copyWith(
                                  fontSize: 12,
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






