

import 'package:communtiy/controllers/onboarding_controller.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class ChartData {
  final double label;
  final int qty;
  final Color? color;

  ChartData(this.label, this.qty, this.color);
}

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({Key? key}) : super(key: key);
  final OnBoardingController userController = Get.put(OnBoardingController());

  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true,tooltipPosition: TooltipPosition.pointer,duration: 2,activationMode: ActivationMode.singleTap);
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
          physics: const BouncingScrollPhysics(),
          child: Column(
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
                          child: Text("${user.userName}",style: t.textTheme.headline1!.copyWith(
                              fontSize: 24,
                              color: Colors.white
                          ),),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: w*0.45,
                        height: h*0.2,
                        child: SfCartesianChart(
                            enableSideBySideSeriesPlacement: true,
                            plotAreaBorderWidth: 0,
                            margin: EdgeInsets.zero,
                            primaryXAxis: CategoryAxis(
                                majorTickLines: const MajorTickLines(size: 0,width: 0),
                                labelPosition: ChartDataLabelPosition.outside,
                                labelPlacement: LabelPlacement.betweenTicks,
                                labelAlignment: LabelAlignment.center,
                                borderColor: Colors.grey,
                                labelRotation: 0,
                                placeLabelsNearAxisLine: true,
                                tickPosition: TickPosition.inside,
                                majorGridLines: const MajorGridLines(width: 0),
                                axisLine: const AxisLine(width: 1,color: Colors.black87),
                                isVisible: false
                            ),

                            primaryYAxis: NumericAxis(
                                majorTickLines: const MajorTickLines(size: 0,width: 0),
                                isVisible: false,
                                majorGridLines: const MajorGridLines(width: 0),
                                axisLine: const AxisLine(width: 1,color: Colors.black87)
                            ),
                            tooltipBehavior: _tooltipBehavior,
                            series: <ChartSeries>[
                              BarSeries<ChartData, double>(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20)
                                  ),
                                  dataSource: chartData,
                                  enableTooltip: true,

                                  xValueMapper: (ChartData data, _) => data.label,
                                  yValueMapper: (ChartData data, _) => data.qty,
                                  pointColorMapper: (ChartData c,_)=>c.color,
                                  // Width of the bars
                                  width: 0.5,
                                  // Spacing between the bars
                                  spacing: 0.3
                              )
                            ]
                        ),
                      ),
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
                      child: fetchProfileImage(user),
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

              buildProfileListTile(w, context,'Bookmarks','Parties and people',Icons.bookmark),
              buildProfileListTile(w, context, 'History', 'All parties attended', Icons.history),
              buildProfileListTile(w, context, 'Invite and earn', 'Each invite will earn you a free party including cover charges', FlutterIcons.google_circles_communities_mco),
              buildProfileListTile(w, context, 'Credentials', 'Phone No,name,password',MaterialCommunityIcons.key_variant),
              buildProfileListTile(w, context, 'Switch Account', 'Want to login from a different account?', Icons.logout)

            ],
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
            logoutOfAccount();
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






