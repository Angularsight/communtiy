import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/models/user_details/interests.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:communtiy/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestList2 extends StatelessWidget {
  /// Guests and their interests who have entered the party
  final List<UserDetailsModel>? guests;
  final List<Interests>? interests;
  GuestList2({Key? key, this.guests, this.interests}) : super(key: key);

  final PageController pageController = PageController(initialPage: 0,viewportFraction: 0.8);
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
        body: GetX<FirebaseController>(
            builder: (controller) {
              return GestureDetector(
                onTap: (){
                  searchNode.unfocus();
                },
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 20),
                        //   child: SizedBox(
                        //     width: w ,
                        //     child: TextFormField(
                        //       decoration: InputDecoration(
                        //         suffixIcon: const Icon(Icons.search,color: Color(0xff505050),),
                        //           fillColor: const Color(0xff131313),
                        //           filled: true,
                        //           hintText: 'Search guests',
                        //           hintStyle: TextStyle(
                        //             color: Colors.white.withOpacity(0.4),
                        //           ),
                        //           border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(10),
                        //               borderSide: const BorderSide(
                        //                   style: BorderStyle.none))),
                        //       style: Theme.of(context).textTheme.headline1!
                        //           .copyWith(color: Colors.white, fontSize: 16),
                        //       textInputAction: TextInputAction.next,
                        //       keyboardType: TextInputType.name,
                        //       key: const ValueKey('username'),
                        //       controller: searchController,
                        //       focusNode: searchNode,
                        //       onChanged: (text) {
                        //       },
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          width: w,
                          child: ListView.builder(
                              itemCount: controller.guests.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return guestListTile(context, index, controller);
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  void openDialogBox(BuildContext context, UserDetailsModel guest, Interests interests) {
    var t = Theme.of(context);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 10,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: w * 0.75,
                height: h * 0.6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: w * 0.7 ,
                            height: w * 0.6,
                            child: PageView.builder(
                                controller: pageController,
                                physics: const BouncingScrollPhysics(),
                                itemCount: guest.images!.length,
                                itemBuilder: (context,index){
                                  return Padding(
                                    padding: EdgeInsets.only(right: h*0.025),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                          width: w * 0.4,
                                          child: Image.network(guest.images![index],fit: BoxFit.cover,)),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),

                      SizedBox(height: h*0.01),
                      Padding(
                        padding: EdgeInsets.only(left: h*0.01),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Interests', style: t.textTheme.headline1!.copyWith(
                                color: Colors.white, fontSize: 20),
                            ),
                            SizedBox(height: h*0.008),
                            Text("Favorites", style: t.textTheme.headline3!.copyWith(
                                color: const Color(0xffC0C0C0)),
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                Text("Movie : ", style: t.textTheme.headline3!.copyWith(
                                    color: const Color(0xffA4A4A4), fontSize: 13),
                                ),
                                buildInterestAttributeList(h, w, interests.movies, t, false)
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text("Anime : ", style: t.textTheme.headline3!.copyWith(
                                    color: const Color(0xffA4A4A4), fontSize: 13),
                                ),
                                buildInterestAttributeList(h, w, interests.anime, t, false)
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text("Sports : ", style: t.textTheme.headline3!.copyWith(
                                    color: const Color(0xffA4A4A4), fontSize: 13),),
                                buildInterestAttributeList(h, w, interests.sport, t, false)
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Text("Pet : ${interests.pet}", style: t.textTheme.headline3!.copyWith(
                                color: const Color(0xffA4A4A4), fontSize: 13),),

                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text("Series : ", style: t.textTheme.headline3!.copyWith(
                                    color: const Color(0xffA4A4A4), fontSize: 13),),
                                buildInterestAttributeList(h, w, interests.series, t, false)
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  SizedBox buildInterestAttributeList(double h, double w, var list, ThemeData t, bool hobbies) {
    if (hobbies) {
      return SizedBox(
        height: h*0.02,
        width: w,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Text("${list![index]}", style: t.textTheme.headline3!.copyWith(
                  color: const Color(0xffA4A4A4), fontSize: 13),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 10,),
            itemCount: list.length),
      );
    } else {
      return SizedBox(
        height: h*0.02,
        width: w * 0.5,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Text("${list![index]}", style: t.textTheme.headline3!.copyWith(
                  color: const Color(0xffA4A4A4), fontSize: 13),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 7,),
            itemCount: list.length),
      );
    }
  }

  Widget guestListTile(BuildContext context, int index, FirebaseController controller) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final t = Theme.of(context);
    return GestureDetector(
      onTap: () {
        ///interestIndex is needed to fetch the index of this particular guest
        ///If this is not used then guest and their interests will not be matched.
        var interestIndex = interests!.indexWhere((element) => element.userId==guests![index].userId);
        // print("Index of interest of this guest:$interestIndex");
        openDialogBox(context, guests![index], interests![interestIndex]);
      },
      child: SizedBox(
        height: h * 0.2,
        width: w,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: h*0.035),
              child: CustomPaint(
                size: Size(w, (w * 0.5833333333333334).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                painter: RPSCustomPainter(context),
                child: Padding(
                  padding: EdgeInsets.only(left: w * 0.37),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${guests![index].userName}",
                            style: t.textTheme.headline1!
                                .copyWith(color: Colors.white, fontSize: 18),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: w*0.02),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: w * 0.1,
                                height: h * 0.05,
                                child: Image.network(
                                  guests![index].images![0].toString(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(interests![index].occupation.toString(),
                          style: t.textTheme.headline1!.copyWith(
                              color: const Color(0xffABAAAA), fontSize: 15)),
                      Text(
                        "#Party#Fun#Yes#No#Host#Invited",
                        style: t.textTheme.headline1!
                            .copyWith(color: const Color(0xff696969), fontSize: 12),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.all(w*0.02),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       InkWell(
                      //         onTap: () {},
                      //         child: Icon(
                      //           CustomIcons.threeDotsHorizontal,
                      //           color: t.primaryColor,
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(w*0.025),
              child: CircleAvatar(
                radius: h*0.07,
                // backgroundColor: const Color(0xff1BC100),
                backgroundColor: Theme.of(context).primaryColor,
                child: CircleAvatar(
                  radius: h*0.068,
                  child: ClipOval(
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(controller
                                  .guests[index].userProfilePic
                                  .toString()),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  final BuildContext context;

  RPSCustomPainter(this.context);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = Theme.of(context).scaffoldBackgroundColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(size.width * 0.2491667, size.height * 0.0014286);
    path0.lineTo(size.width, 0);
    path0.quadraticBezierTo(size.width * 0.9995833, size.height * 0.7500000,
        size.width, size.height);
    path0.quadraticBezierTo(size.width * 0.9376083, size.height * 0.6453714,
        size.width * 0.2508917, size.height * 0.6398714);
    path0.lineTo(size.width * 0.2491667, size.height * 0.0014286);
    path0.close();

    canvas.drawShadow(path0, Colors.black, 3.5, false);
    canvas.drawShadow(path0, Colors.black, 3.5, false);
    canvas.drawShadow(path0, Colors.black, 3.5, false);
    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}