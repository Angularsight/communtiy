import 'package:carousel_slider/carousel_slider.dart';
import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/getx_ui/party_details.dart';
import 'package:communtiy/utils/icons.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MatchedScreen extends StatelessWidget {
  MatchedScreen({Key? key}) : super(key: key);

  final FirebaseController controller = Get.find();
  final PageController pageController = PageController(initialPage: 0, viewportFraction: 1);
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
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: h*0.09),
            child: SizedBox(
              height: h*0.6,
              width: w,
              child: GetX<FirebaseController>(
                  builder: (ctr) {
                    return CarouselSlider.builder(
                        itemCount: controller.parties[controller.partyIndexForMatchedPage.value].images?.length ?? 0,
                        itemBuilder: (context,index,realIndex){
                          return GestureDetector(
                            onTap: (){
                              final partyIndex = controller.partyIndexForMatchedPage.value;
                              Get.to(()=>PartyDetails2(index: partyIndex,));
                            },
                            child: SizedBox(
                                height: h * 0.7,
                                width: w,
                                child: Image.network(
                                  controller.parties[ctr.partyIndexForMatchedPage.value].images![index].toString(), fit: BoxFit.cover,
                                )),
                          );
                        },
                        options: CarouselOptions(
                            height: h*0.7,
                            viewportFraction: 1,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: true,
                            initialPage: 0,
                            onPageChanged: (int index,reason){
                              controller.pageIndicatorIndex.value = index;
                            }
                        ));
                  }
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: h*0.64),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GetX<FirebaseController>(
                      builder: (ctr) {
                        return AnimatedSmoothIndicator(
                          count: ctr.parties[controller.partyIndexForMatchedPage.value].images?.length ?? 0,
                          activeIndex: ctr.pageIndicatorIndex.value,
                          effect: WormEffect(
                              radius: 10,
                              dotWidth: 12,
                              dotHeight: 12,
                              activeDotColor: t.primaryColor
                          ),
                        );
                      }
                  ),
                ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                        child: Text("Community",style: t.textTheme.caption!.copyWith(
                            color: Colors.white
                        ),),
                      ),
                      SizedBox(
                        width:w,
                        height: h*0.18,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap:(){
                                      controller.partyIndexForMatchedPage.value = index;
                                    },
                                    child: GetX<FirebaseController>(
                                        builder: (controller) {
                                          return Container(
                                            width: w * 0.3,
                                            height: h*0.13,
                                            margin: const EdgeInsets.only(right: 10,left: 10),
                                            decoration: BoxDecoration(
                                                border: index==controller.partyIndexForMatchedPage.value?Border.all(color: t.primaryColor):Border.all(color: Colors.transparent),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.network(controller.parties[index].images?[0].toString()?? defaultImageString,fit: BoxFit.cover,)),
                                          );
                                        }
                                    ),
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
                            },
                            separatorBuilder: (context, index) => const SizedBox(width: 2,),
                            itemCount: controller.parties.length),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          GetX<FirebaseController>(
              builder: (controller) {
                return Padding(
                  padding:  EdgeInsets.only(top:h*0.08),
                  child: Container(
                    height: h*0.12,
                    width: w,
                    decoration: BoxDecoration(
                      gradient: Themes.softBlackGradientReverse,
                    ),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("${controller.parties[controller.partyIndexForMatchedPage.value].time.toString()} pm",style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.white),),
                        Text(controller.parties[controller.partyIndexForMatchedPage.value].location.toString(),style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.white),),
                        Text("Rs.${controller.parties[controller.partyIndexForMatchedPage.value].entryFee}",style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.white),),
                      ],
                    ),
                  ),
                );
              }
          )

        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: Themes.appBarGradient,
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(17),
                  bottomLeft: Radius.circular(17)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                    spreadRadius: 0)
              ]),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: w * 0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Stack(
                  children: [
                    Text(
                      "Leagues",
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 4
                            ..color = Colors.black,
                          letterSpacing: 1,
                          fontSize: 30
                      ),
                    ),
                    Text(
                      "Leagues",
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 1,
                          fontSize: 30

                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding:EdgeInsets.only(bottom: h*0.02, top: h*0.01),
              child: IconButton(
                icon: Icon(
                  CustomIcons.hamburger,
                  size: 30,
                ),
                onPressed: () {
                  return Scaffold.of(context).openDrawer();
                },
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: h*0.01, right: h*0.015),
            child: InkWell(
              splashColor: Colors.red,
              onTap: () {},
              child: const Icon(
                Icons.account_circle,
                size: 30,
              ),
            ),
          ),
        ]
    );
  }


}