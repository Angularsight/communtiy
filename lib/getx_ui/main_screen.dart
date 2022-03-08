import 'dart:ui';

import 'package:communtiy/controllers/bottom_nav_controller.dart';
import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/getx_ui/party_details.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:communtiy/utils/icons.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:get/get.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseController partyController = Get.find();
  final bottomNavController = Get.put(BottomNavController());

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  late PageController pageController;
  int currentPage = 0;

  bool queryComplete = false;
  List<UserDetailsModel> userQueryImages = [];
  List<PartyDetails> partyQueryImages = [];
  int imagesLength = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: 0,viewportFraction: 0.8);
    pageController.addListener(() {
      int next = pageController.page!.round();
      if(currentPage!=next){
        setState(() {
          currentPage = next;
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          searchFocusNode.unfocus();
          searchController.clear();
        },
        child: CustomScrollView(
          slivers: [
            buildAppBar(context),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Column(
                  children:  [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06,vertical: Get.height * 0.03),
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          focusNode: searchFocusNode,
                          controller: searchController,
                          autocorrect: true,
                          autofocus: false,
                          showCursor: true,
                          decoration: InputDecoration(
                            focusColor: Colors.transparent,
                            border:  OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    style: BorderStyle.none)),
                            filled: true,
                            fillColor: Theme.of(context).canvasColor,
                            hintText: "Dont think just look it up",
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            hintStyle: Theme.of(context).textTheme.headline1!.copyWith(
                                color: Colors.black.withOpacity(0.5)
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xff505050),
                            ),
                          ),
                          onEditingComplete: () async {
                            Future.wait([
                              partyController.searchQueryUser(searchController.text).then((value) {
                                queryComplete = true;
                                searchFocusNode.unfocus();
                                userQueryImages = value;
                                print('user details : ${userQueryImages}');
                              }),
                              partyController.searchQueryParty(searchController.text).then((value) {
                                queryComplete = true;
                                searchFocusNode.unfocus();
                                partyQueryImages = value;
                                print('party details : ${partyQueryImages}');
                              })
                            ]);
                          },
                        ),
                      )
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: PageView.builder(
                        controller: pageController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: partyController.parties.length,
                          itemBuilder: (context,index){
                          bool isActive = (index==currentPage);
                          return pageViewCard(index,isActive);
                        }),
                    ),

                  ],
                ),
              )
            )
          ],
        ),
      )

    );
  }

  // Column buildMainScreen(BuildContext context) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Flexible(
  //           flex: 8,
  //           child: GetX<FirebaseController>(builder: (controller) {
  //             /// Search Bar Queries
  //             /// For both users and parties
  //             return TextField(
  //               focusNode: searchFocusNode,
  //               controller: searchController,
  //               autocorrect: true,
  //               autofocus: false,
  //               decoration: InputDecoration(
  //                 focusColor: Colors.transparent,
  //                 border: const OutlineInputBorder(
  //                     borderSide: BorderSide(
  //                         color: Colors.transparent,
  //                         style: BorderStyle.none)),
  //                 filled: true,
  //                 hintText: controller.parties[0].partyName.toString(),
  //                 hintStyle: TextStyle(
  //                     color: Colors.grey.withOpacity(0.5)
  //                 ),
  //                 suffixIcon: const Icon(
  //                   Icons.search,
  //                   color: Colors.grey,
  //                 ),
  //               ),
  //               onEditingComplete: () async {
  //                 Future.wait([
  //                   controller.searchQueryUser(searchController.text).then((value) {
  //                     queryComplete = true;
  //                     searchFocusNode.unfocus();
  //                     userQueryImages = value;
  //                     // controller.partyQueryImages.value = [];
  //                     print('userQueryImages : ${controller.userQueryImages.value}');
  //                   }),
  //                   controller.searchQueryParty(searchController.text).then((value) {
  //                     queryComplete = true;
  //                     searchFocusNode.unfocus();
  //                     partyQueryImages = value;
  //                     // controller.userQueryImages.value = [];
  //                   })
  //                 ]);
  //               },
  //             );
  //           })),
  //       Flexible(
  //         flex: 8,
  //         child: GetX<FirebaseController>(builder: (controller) {
  //           if (controller.parties == null && controller == null) {
  //             return const Center(
  //               child: CircularProgressIndicator(),
  //             );
  //           } else {
  //             return Column(
  //               children: [
  //                 /// Displaying image if search query request is successful
  //                 /// Else displaying an empty SizedBox() instead of its place
  //                 controller.queryComplete.value ? Expanded(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Container(
  //                       width: double.infinity,
  //                       height: 300,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(10)),
  //                       child: ListView.separated(
  //                         itemBuilder: (context, index) {
  //                           if(userQueryImages.isEmpty){
  //                             return Image.network(partyQueryImages[0].images![index], fit: BoxFit.cover,);
  //                           }else{
  //                             return Image.network(userQueryImages[0].images![index], fit: BoxFit.cover,);
  //                           }
  //                         },
  //                         separatorBuilder: (context, index) => const SizedBox(width: 10,),
  //                         itemCount: 2,
  //                         scrollDirection: Axis.horizontal,
  //                       ),
  //                     ),
  //                   ),
  //                 ) : const SizedBox(),
  //                 const SizedBox(
  //                   height: 30,
  //                 ),
  //                 Text("${controller.parties[0].time}"),
  //               ],
  //             );
  //           }
  //         }),
  //       ),
  //       Flexible(
  //         flex: 4,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             TextButton(
  //               onPressed: () {
  //                 Get.to(() =>  PartyDetails2(index: currentPage,));
  //               },
  //               child: Container(
  //                 width: MediaQuery.of(context).size.width * 0.3,
  //                 height: 40,
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(20),
  //                     gradient: const LinearGradient(
  //                         colors: [Colors.red, Colors.yellow],
  //                         begin: Alignment.topLeft,
  //                         end: Alignment.bottomRight)),
  //                 child: const Center(
  //                     child: Text(
  //                       "Party Details",
  //                       style: TextStyle(color: Colors.black),
  //                     )),
  //               ),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

  buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: 50,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Themes.appBarGradient,
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(17),
                bottomLeft: Radius.circular(17)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: Offset(0,4),
              blurRadius: 4,
              spreadRadius: 0
            )
          ]
        ),
      ),
      title:Padding(
        padding: EdgeInsets.only(left: Get.width * 0.15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                children: [
                  Text(
                    "Community",
                    style: Theme.of(context).textTheme.caption!.copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.black
                    ),
                  ),
                  Text(
                    "Community",
                    style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Theme.of(context).primaryColor
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
            padding: const EdgeInsets.only(bottom: 20.0,top: 10),
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
            padding: const EdgeInsets.only(top: 10.0, right: 10),
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

  Widget pageViewCard(int index, bool isActive) {
    double paddingTop = isActive?0:40;
    // double containerHeight = isActive?150:100;
    return InkWell(
      onTap: (){
        print('currentPageIndex:$currentPage');
        Get.to(() =>  PartyDetails2(index:currentPage));
      },
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 400),
        padding: EdgeInsets.only(top: paddingTop,right: 30),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              SizedBox(
                height: 400,
                // duration: const Duration(milliseconds: 400),
                child: Image.network(partyController.parties[index].images![0].toString(),fit: BoxFit.cover,),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 300),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: Themes.softBlackGradient
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(partyController.parties[index].partyName.toString(),style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Colors.white
                          ),),
                          const SizedBox(width: 10,),
                          Icon(CustomIcons.bookmark,color: Theme.of(context).canvasColor,)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("${partyController.parties[index].time.toString()} pm",style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.white),),
                          Text(partyController.parties[index].location.toString(),style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.white),),
                          Text("Rs.${partyController.parties[index].entryFee}",style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.white),),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),

      ),
    );
  }
}
