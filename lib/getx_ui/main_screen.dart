import 'dart:ui';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:communtiy/controllers/bottom_nav_controller.dart';
import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/getx_ui/party_details.dart';
import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:communtiy/utils/icons.dart';
import 'package:communtiy/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';


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
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
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
                              height: h*0.06,
                              child: TypeAheadField<PartyDetails?>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: searchController,
                                  focusNode: searchFocusNode,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    focusColor: Colors.transparent,
                                    border:  OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            style: BorderStyle.none)),
                                    filled: true,
                                    fillColor: Theme.of(context).canvasColor,
                                    hintText: "Look up parties",
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                    hintStyle: Theme.of(context).textTheme.headline1!.copyWith(
                                        color: Colors.black.withOpacity(0.5)
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Color(0xff505050),
                                    ),
                                  )
                                ),
                                  suggestionsBoxDecoration:  const SuggestionsBoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)
                                    ),
                                  ),
                                  suggestionsCallback: partyController.partyQuerySuggestions,
                                  itemBuilder: (context,PartyDetails? suggestions){
                                    return ListTile(
                                      leading: Container(
                                        height: 40,
                                        width:40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          image: DecorationImage(image: NetworkImage(suggestions!.images![0].toString()),fit: BoxFit.cover)
                                        ),
                                      ),
                                      title: Text("${suggestions.partyName}"),);
                                    },
                                  noItemsFoundBuilder: (context)=>Center(child:Text("Nothing found yet",style: Theme.of(context).textTheme.headline1,)),
                                  onSuggestionSelected: (PartyDetails? suggested){
                                  final partyIndex = partyController.parties.indexWhere((element) => element.partyName==suggested!.partyName);
                                  print(partyIndex);
                                    Get.to(()=>PartyDetails2(index: partyIndex,));
                                  }),
                              // child: TextField(
                              //   focusNode: searchFocusNode,
                              //   controller: searchController,
                              //   autocorrect: true,
                              //   autofocus: false,
                              //   showCursor: true,
                              //   decoration: InputDecoration(
                              //     focusColor: Colors.transparent,
                              //     border:  OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(7),
                              //         borderSide: const BorderSide(
                              //             color: Colors.transparent,
                              //             style: BorderStyle.none)),
                              //     filled: true,
                              //     fillColor: Theme.of(context).canvasColor,
                              //     hintText: "Dont think just look it up",
                              //     contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                              //     hintStyle: Theme.of(context).textTheme.headline1!.copyWith(
                              //         color: Colors.black.withOpacity(0.5)
                              //     ),
                              //     prefixIcon: const Icon(
                              //       Icons.search,
                              //       color: Color(0xff505050),
                              //     ),
                              //   ),
                              //   onEditingComplete: () async {
                              //     Future.wait([
                              //       partyController.searchQueryUser(searchController.text).then((value) {
                              //         queryComplete = true;
                              //         searchFocusNode.unfocus();
                              //         userQueryImages = value;
                              //         print('user details : ${userQueryImages}');
                              //       }),
                              //       partyController.searchQueryParty(searchController.text).then((value) {
                              //         queryComplete = true;
                              //         searchFocusNode.unfocus();
                              //         partyQueryImages = value;
                              //         print('party details : ${partyQueryImages}');
                              //       })
                              //     ]);
                              //   },
                              // ),
                            )
                        ),

                        GetX<FirebaseController>(
                          builder: (FirebaseController partyController) {
                            return SizedBox(
                              width: double.infinity,
                              height: h*0.55,
                              child: PageView.builder(
                                  controller: pageController,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: partyController.parties.length,
                                  itemBuilder: (context,index){
                                    bool isActive = (index==currentPage);
                                    try{
                                      return pageViewCard(index, isActive,h);
                                    }catch(e){
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          height: 400,
                                          width: w*0.9,
                                          color: const Color(0xff414141),
                                          child: Shimmer.fromColors(
                                            baseColor: const Color(0xff2d2d2d),
                                            highlightColor: const Color(0xff6a737c),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 300.0,left: 8,right: 8),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width * 0.4,
                                                    height: 25,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20,),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    // return pageViewCard(index,isActive);
                                  }),
                            );
                          }
                        ),

                        const SizedBox(height: 25,),
                        // GetX<FirebaseController>(
                        //   builder: (FirebaseController partyController) {
                        //     return buildActivitiesAndSpecialAppearance(context,partyController.parties[currentPage]);
                        //   }
                        // )


                      ],
                    ),
                  )
              )
            ],
          ),
        )

    );
  }

  Accordion buildActivitiesAndSpecialAppearance(BuildContext context, PartyDetails party) {
    try{
      final activities = {};
      for (String element in party.activities!) {
        final split = element.toString().split(',');
        activities[split[0]] = split[1];
      }
      return Accordion(
          scrollIntoViewOfItems: ScrollIntoViewOfItems.slow,
          maxOpenSections: 2,
          headerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          rightIcon: const Icon(Icons.keyboard_arrow_down,color: Colors.white,),
          contentBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          children: [
            AccordionSection(
                contentVerticalPadding: 0,
                header: Text("Activities",style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontSize: 16,
                    color: Colors.white
                ),),
                content:Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                      minHeight: 100,
                      maxHeight: 300
                  ),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: activities.length,
                      itemBuilder: (context,index){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(activities.keys.toList()[index],style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            )),
                            Text(activities[activities.keys.toList()[index]].toString(),style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.normal
                            )),
                            const SizedBox(height: 10,)
                          ],
                        );
                      }),
                )

            ),
            AccordionSection(
                contentVerticalPadding:MediaQuery.of(context).size.width * 0.05 ,
                header: Text("Special Appearance",style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontSize: 16,
                    color: Colors.white
                ),),
                content: party.specialAppearance!?Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
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
                      width: MediaQuery.of(context).size.width * 0.6,
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
                        children: [
                          Text(party.djName!,style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ) ,),
                          Text("Playing : ${party.playing![0]}, ${party.playing![1]}, ${party.playing![2]} ",style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.normal
                          ))
                        ],
                      ),
                    )
                  ],
                ) :
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Text("Not available for this event ",style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 15
                        )),
                        Text("Keep looking in other parties",style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Colors.white,
                            fontSize: 18
                        ),)
                      ],
                    ),
                  ),
                )

            ),
          ]);
    }catch(e){
      return Accordion(
          scrollIntoViewOfItems: ScrollIntoViewOfItems.slow,
          maxOpenSections: 2,
          headerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          rightIcon: const Icon(Icons.keyboard_arrow_down,color: Colors.white,),
          contentBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          children: [
            AccordionSection(
                header: Text("Activities",style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontSize: 16,
                    color: Colors.white
                ),),
                content: const Text("")),
            AccordionSection(
                header: Text("Special Appearance",style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontSize: 16,
                    color: Colors.white
                ),),
                content: const Text(""))

          ]);
    }

  }


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
                    offset: const Offset(0,4),
                    blurRadius: 4,
                    spreadRadius: 0
                )
              ]
          ),
        ),
        title:Padding(
          padding: EdgeInsets.only(left: Get.width * 0.35),
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
                          letterSpacing: 2
                      ),
                    ),
                    Text(
                      "Leagues",
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Theme.of(context).primaryColor,
                        letterSpacing: 2

                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        // leading: Builder(
        //   builder: (BuildContext context) {
        //     return Padding(
        //       padding: const EdgeInsets.only(bottom: 20.0,top: 10),
        //       child: IconButton(
        //         icon: Icon(
        //           CustomIcons.hamburger,
        //           size: 30,
        //         ),
        //         onPressed: () {
        //           return Scaffold.of(context).openDrawer();
        //         },
        //       ),
        //     );
        //   },
        // ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(top: 10.0, right: 10),
        //     child: InkWell(
        //       splashColor: Colors.red,
        //       onTap: () {},
        //       child: const Icon(
        //         Icons.account_circle,
        //         size: 30,
        //       ),
        //     ),
        //   ),
        // ],
    );
  }


  Widget pageViewCard(int index, bool isActive, double h) {
    double paddingTop = isActive?0:40;
    // double containerHeight = isActive?150:100;
    return InkWell(
      onTap: (){
        print('currentPageIndex:$currentPage');
        Get.to(() =>  PartyDetails2(index:currentPage));
      },
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 500),
        padding: EdgeInsets.only(top: paddingTop,right: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              SizedBox(
                height: h*0.55,
                // duration: const Duration(milliseconds: 400),
                child: Image.network(partyController.parties[index].images![0].toString(),fit: BoxFit.cover,),
              ),
              Padding(
                padding: EdgeInsets.only(top: h*0.43),
                child: Container(
                  height: h*0.12,
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