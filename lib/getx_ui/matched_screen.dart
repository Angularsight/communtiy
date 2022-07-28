import 'package:carousel_slider/carousel_slider.dart';
import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/getx_ui/party_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/onboarding_controller.dart';
import 'new_ui/coupons_screen.dart';

class MatchedScreen extends StatelessWidget {
  MatchedScreen({Key? key}) : super(key: key);

  final FirebaseController controller = Get.find();
  final PageController pageController = PageController(initialPage: 0, viewportFraction: 1);
  final OnBoardingController userController = Get.put(OnBoardingController());

  int currentIndex =0;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final t = Theme.of(context);
    const defaultImageString = 'http://www.lyon-ortho-clinic.com/files/cto_layout/img/placeholder/book.jpg';
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      // appBar: buildAppBar(context),

      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                buildHomeLocationBar2(context, w, h),
                SizedBox(height: h*0.01,),
                SizedBox(
                  height: h*0.57,
                  width: w,
                  child: GetX<FirebaseController>(
                      builder: (ctr) {
                        return InkWell(
                          onTap: (){
                            final partyIndex = controller.partyIndexForMatchedPage.value;
                            ctr.partyDetailsCarouselIndex.value =0;
                            Get.to(()=>PartyDetails2(index: partyIndex,));
                          },
                          child: Image.network(
                          controller.parties[ctr.partyIndexForMatchedPage.value].images![0].toString(), fit: BoxFit.cover,
                          ),
                        );
                        // return CarouselSlider.builder(
                        //     itemCount: controller.parties[controller.partyIndexForMatchedPage.value].images?.length ?? 0,
                        //     itemBuilder: (context,index,realIndex){
                        //       return GestureDetector(
                        //         onTap: (){
                        //           final partyIndex = controller.partyIndexForMatchedPage.value;
                        //           Get.to(()=>PartyDetails2(index: partyIndex,));
                        //         },
                        //         child: SizedBox(
                        //             height: h * 0.7,
                        //             width: w,
                        //             child: ClipRRect(
                        //               borderRadius: const BorderRadius.only(
                        //                 topRight: Radius.circular(10),
                        //                 topLeft: Radius.circular(10)
                        //               ),
                        //               child: Image.network(
                        //                 controller.parties[ctr.partyIndexForMatchedPage.value].images![index].toString(), fit: BoxFit.cover,
                        //               ),
                        //             )),
                        //       );
                        //     },
                        //     options: CarouselOptions(
                        //         height: h*0.7,
                        //         viewportFraction: 1,
                        //         enableInfiniteScroll: false,
                        //         enlargeCenterPage: true,
                        //         initialPage: 0,
                        //         onPageChanged: (int index,reason){
                        //           controller.pageIndicatorIndex.value = index;
                        //         }
                        //     ));
                      }
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: h*0.66),
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: GetX<FirebaseController>(
                //       builder: (ctr) {
                //         return AnimatedSmoothIndicator(
                //           count: ctr.parties[controller.partyIndexForMatchedPage.value].images?.length ?? 0,
                //           activeIndex: ctr.pageIndicatorIndex.value,
                //           effect: WormEffect(
                //               radius: 10,
                //               dotWidth: 12,
                //               dotHeight: 12,
                //               activeDotColor: t.primaryColor
                //           ),
                //         );
                //       }
                //   ),
                // ),
                Container(
                  height: h * 0.25,
                  width: w,
                  decoration: BoxDecoration(
                      color: t.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(13),
                          topLeft: Radius.circular(13)
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w*0.025,vertical: h*0.01),
                        child: Text("Leagues",style: t.textTheme.caption!.copyWith(
                            color: Colors.white
                        ),),
                      ),
                      GetX<FirebaseController>(
                        builder: (something) {
                          return SizedBox(
                            width:w,
                            height: h*0.18,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GetX<FirebaseController>(
                                    builder: (controller) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap:(){
                                              controller.partyIndexForMatchedPage.value = index;
                                            },
                                            child: Container(
                                                    width: w * 0.3,
                                                    height: h*0.13,
                                                    margin: EdgeInsets.symmetric(horizontal: w*0.025),
                                                    decoration: BoxDecoration(
                                                        border: index==controller.partyIndexForMatchedPage.value?Border.all(color: t.primaryColor):Border.all(color: Colors.transparent),
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: Image.network(controller.parties[index].images?[0].toString()?? defaultImageString,fit: BoxFit.cover,)),
                                                  )
                                          ),
                                          SizedBox(height: h*0.01,),

                                          Text(controller.parties[index].partyName.toString(),style: t.textTheme.headline3!.copyWith(
                                              color: Colors.white,
                                              fontSize: 17,
                                              shadows: [
                                                const Shadow(
                                                    color: Colors.black,
                                                    offset: Offset(0,4),
                                                    blurRadius: 4
                                                ),
                                                const Shadow(
                                                    color: Colors.black,
                                                    offset: Offset(1,4),
                                                    blurRadius: 4
                                                )
                                              ]
                                          ),)
                                        ],
                                      );
                                    }
                                  );
                                },
                                separatorBuilder: (context, index) => const SizedBox(width: 2,),
                                itemCount: controller.parties.length),
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // GetX<FirebaseController>(
          //     builder: (controller) {
          //       return Container(
          //         height: h*0.12,
          //         width: w,
          //         decoration: BoxDecoration(
          //           gradient: Themes.softBlackGradientReverse,
          //         ),
          //         child:Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             Text(controller.parties[controller.partyIndexForMatchedPage.value].time.toString(),style: Theme.of(context).textTheme.headline3!.copyWith(
          //                 color: Colors.white),),
          //             Text(controller.parties[controller.partyIndexForMatchedPage.value].location.toString(),style: Theme.of(context).textTheme.headline3!.copyWith(
          //                 color: Colors.white),),
          //             Text("Rs.${controller.parties[controller.partyIndexForMatchedPage.value].entryFee}",style: Theme.of(context).textTheme.headline3!.copyWith(
          //                 color: Colors.white),),
          //           ],
          //         ),
          //       );
          //     }
          // )

        ],
      ),
    );
  }

  Widget buildHomeLocationBar2(BuildContext context, double w,double h) {

    return GetX<OnBoardingController>(
      // init: Get.put(OnBoardingController()),
        builder: (userController) {
          // userController.userProfile.bindStream(userController.connectUserToApp());
          // final profilePic = userController.userProfile.value.userProfilePic;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06,vertical: h * 0.01),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.location_on_rounded,color: Theme.of(context).canvasColor,size: 30,),
                SizedBox(width: w*0.01,),
                // const SizedBox(width: 5,),
                Expanded(
                  child: InkWell(
                    onTap: (){},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Home",style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Colors.white,
                            fontSize: 18
                        ),),
                        userController.userProfile.value.location!=null?Text(userController.userProfile.value.location.toString(),
                          style: Theme.of(context).textTheme.headline1!.copyWith(
                              color: const Color(0xffB6B6B6),
                              fontSize: 12
                          ),):Text("Somewhere on earth",style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: const Color(0xffB6B6B6),
                            fontSize: 12
                        ),),
                      ],
                    ),
                  ),
                ),

                // Icon(Icons.notifications_none,color: Theme.of(context).canvasColor,size: 30,),
                SizedBox(width: w*0.03,),
                Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: ()async{
                      var couponImages = await userController.fetchCouponImages();
                      var discountAndImages = await userController.fetchDiscountAndImages();
                      Get.to(()=>CouponsScreen(couponImages: couponImages, discountAndImage: discountAndImages,));
                    },
                    child: ClipOval(
                      child: CircleAvatar(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          radius: w*0.042,
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/Drinks with wings 7.png'),
                                  fit: BoxFit.contain,
                                )
                            ),
                          )
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }


}