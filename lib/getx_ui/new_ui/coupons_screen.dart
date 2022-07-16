

import 'package:carousel_slider/carousel_slider.dart';
import 'package:communtiy/controllers/onboarding_controller.dart';
import 'package:communtiy/models/coupons/coupon_images.dart';
import 'package:communtiy/models/coupons/discountAndImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CouponsScreen extends StatelessWidget {
  final CouponImages couponImages;
  final List<DiscountAndImage> discountAndImage;
  CouponsScreen({Key? key,required this.couponImages,required this.discountAndImage}) : super(key: key);

  final OnBoardingController user = Get.find();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final t = Theme.of(context);
    user.carouselIndicatorIndex.value = 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(w*0.05),
            child: GetX<OnBoardingController>(
              builder: (ctrl) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
                        SizedBox(width: w*0.03,),
                        Text("Leagues",style: t.textTheme.headline1!.copyWith(
                          color: Colors.white,
                          fontSize: 25
                        ),)
                      ],
                    ),
                    // SizedBox(height: h*0.01,),

                    Container(
                          width: w,
                          height: h*0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CarouselSlider.builder(
                              itemCount: 3,
                              itemBuilder: (context,index,realIndex){
                                return Image.network(
                                  couponImages.images![index], fit: BoxFit.contain,
                                );
                              },
                              options: CarouselOptions(
                                  autoPlay: true,
                                  // autoPlayAnimationDuration: const Duration(seconds: 3),
                                  height: h*0.7,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  viewportFraction: 1,
                                  enableInfiniteScroll: false,
                                  enlargeCenterPage: true,
                                  initialPage: 0,
                                  onPageChanged: (int index,reason){
                                    ctrl.carouselIndicatorIndex.value = index;
                                  }
                                )),
                        ),

                    Center(
                      child: AnimatedSmoothIndicator(
                            count: 3,
                            activeIndex:ctrl.carouselIndicatorIndex.value ,
                            effect: WormEffect(
                                radius: 10,
                                dotWidth: 12,
                                dotHeight: 12,
                                activeDotColor: t.primaryColor
                            ),
                      ),
                    ),
                    SizedBox(height: h*0.02,),
                    Container(
                      width: w*0.3,
                      height: h*0.05,
                      decoration: BoxDecoration(
                        color: t.primaryColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text("Streaks : ${ctrl.userProfile.value.streaks}",style: t.textTheme.headline1!.copyWith(
                          // color: Color(0xffDFA91D),
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),

                    SizedBox(height: h*0.02,),
                    Text("Streak Rewards",style: t.textTheme.headline1!.copyWith(
                      color: Colors.white,
                      fontSize: 18
                    ),),

                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: EdgeInsets.only(top: h*0.015),
                            child: Container(
                              width: w,
                              height: h*0.15,
                              decoration: BoxDecoration(
                                color: const Color(0xff1D4956),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top:w*0.03,left: w*0.02,bottom: w*0.03),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            Text(discountAndImage[index].name.toString(),style:t.textTheme.headline1!.copyWith(
                                              color: Colors.white,
                                              fontSize: 20
                                            ),),
                                            Expanded(
                                              child: Text("Get ${discountAndImage[index].discount}% off on any event you enter",style: t.textTheme.headline1!.copyWith(
                                                color: Colors.white.withOpacity(0.6),
                                                fontSize: 14
                                              ),),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                print("pressed on claim code $index");
                                              },
                                              child: Container(
                                                width: w*0.25,
                                                height: h*0.03,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(5),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.75),
                                                      offset: const Offset(0,2),
                                                      blurRadius: 2,
                                                      spreadRadius: 0
                                                    ),
                                                  ]
                                                ),
                                                child: Center(child:Text("Claim Code",style: t.textTheme.headline1!.copyWith(
                                                  color: const Color(0xff1D4956),
                                                  fontSize: 14
                                                ),)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        child: SizedBox(
                                          width: w*0.32,
                                          height: h*0.15,
                                          child: Image.network(discountAndImage[index].image.toString(),fit: BoxFit.cover,),
                                        ),
                                      )
                                    ],
                                  ),

                                  Positioned(
                                    right: w*0.03,
                                    child: Container(
                                      width: w*0.03,
                                      height: h*0.03,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff1D4956),
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)
                                        )
                                      ),
                                      child: Center(child: Text((index+1).toString(),style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      ),),),
                                    ),
                                  )

                                ],
                              ),
                            ),
                          );
                        }
                    )

                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
