import 'package:communtiy/controllers/firebase_controller.dart';
import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:communtiy/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestList2 extends StatelessWidget {
<<<<<<< HEAD
<<<<<<< HEAD
  /// Guests and their interests who have entered the party
  final List<UserDetailsModel>? guests;
  final List<Interests>? interests;
  GuestList2({Key? key, this.guests, this.interests}) : super(key: key);

  final PageController pageController = PageController(initialPage: 0,viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final t = Theme.of(context);
    return Scaffold(body: GetX<FirebaseController>(builder: (controller) {
      return Column(
        children: [
          SizedBox(
            width: w,
            height: h,
            child: ListView.builder(
                itemCount: controller.guests.length,
                itemBuilder: (context, index) {
                  return GuestListTile(context, index, controller);
                }),
          )
        ],
      );
    }));
  }

  void openDialogBox(
      BuildContext context, UserDetailsModel guest, Interests interests) {
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
            backgroundColor: Color(0xff292929),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: w * 0.75,
                height: h * 0.7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Get.width * 0.7 ,
                            height: Get.width * 0.6,
                            child: PageView.builder(
                                controller: pageController,
                                physics: const BouncingScrollPhysics(),
                                itemCount: guest.images!.length,
                                itemBuilder: (context,index){
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 25),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                          width: Get.width * 0.4,
                                          child: Image.network(guest.images![index],fit: BoxFit.cover,)),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(10),
                      //   child: SizedBox(
                      //       width: 200,
                      //       child: Image.network(guest.images![index],fit: BoxFit.cover,)),
                      // )
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Does\'nt matter if you win by an inch or a mile winning is winning', style: t.textTheme.headline1!.copyWith(
                                color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text("Bio", style: t.textTheme.headline3!.copyWith(color: Color(0xffC0C0C0)),
                            ),
                            Row(
                              children: [
                                Text("Height : ${interests.height}", style: t.textTheme.headline3!.copyWith(
                                      color: Color(0xffA4A4A4), fontSize: 13),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text("Weight : 60kgs", style: t.textTheme.headline3!.copyWith(
                                      color: Color(0xffA4A4A4), fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text("Favorites", style: t.textTheme.headline3!.copyWith(
                                color: Color(0xffC0C0C0)),
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                Text("Movie : ", style: t.textTheme.headline3!.copyWith(
                                      color: Color(0xffA4A4A4), fontSize: 13),
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
                                      color: Color(0xffA4A4A4), fontSize: 13),
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
                                      color: Color(0xffA4A4A4), fontSize: 13),),
                                buildInterestAttributeList(h, w, interests.sport, t, false)
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Text("Pet : ${interests.pet}", style: t.textTheme.headline3!.copyWith(
                                  color: Color(0xffA4A4A4), fontSize: 13),),

                            const SizedBox(height: 20,),
                            Text("Hobbies and Likes", style: t.textTheme.headline3!.copyWith(
                                color: Color(0xffC0C0C0)),
                            ),
                            const SizedBox(height: 5,),
                            buildInterestAttributeList(h, w, interests.series, t, true)
                          ],
                        ),
                      )
                    ],
                  ),
=======
  final List<UserDetailsModel>? guests;
  GuestList2({Key? key, this.guests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
=======
  final List<UserDetailsModel>? guests;
  GuestList2({Key? key, this.guests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
>>>>>>> parent of 6823e27 (Main Screen and Matching Screen)
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Guests of this particular party fetched below"),
        Text(guests![0].age.toString()),
        Flexible(
          flex: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                          colors: [Colors.red, Colors.yellow],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight)),
                  child: const Center(
                      child: Text(
                    "Go Back",
                    style: TextStyle(color: Colors.black),
                  )),
<<<<<<< HEAD
>>>>>>> parent of 6823e27 (Main Screen and Matching Screen)
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  SizedBox buildInterestAttributeList(double h, double w, var list, ThemeData t, bool hobbies) {
    if (hobbies) {
      return SizedBox(
            height: 20,
            width: w,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Text("${list![index]}", style: t.textTheme.headline3!.copyWith(
                      color: Color(0xffA4A4A4), fontSize: 13),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10,),
                itemCount: list.length),
          );
    } else {
      return SizedBox(
            height: 20,
            width: w * 0.5,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Text("${list![index]}", style: t.textTheme.headline3!.copyWith(
                      color: Color(0xffA4A4A4), fontSize: 13),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10,),
                itemCount: list.length),
          );
    }
  }

  Widget GuestListTile(
      BuildContext context, int index, FirebaseController controller) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final t = Theme.of(context);
    final W = h * 1.2;
    return GestureDetector(
      onTap: () {
        openDialogBox(context, guests![index], interests![index]);
      },
      child: SizedBox(
        height: h * 0.2,
        width: w,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: CustomPaint(
                size: Size(
                    w,
                    (w * 0.5833333333333334)
                        .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                painter: RPSCustomPainter(),
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
                            padding: const EdgeInsets.only(right: 8.0),
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
                            .copyWith(color: Color(0xff696969), fontSize: 12),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Icon(
                                CustomIcons.threeDotsHorizontal,
                                color: t.primaryColor,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xff1BC100),
                child: CircleAvatar(
                  radius: 58,
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
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color(0xff292929)
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

    canvas.drawShadow(path0, Colors.black, 10.0, true);
    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
=======
                ),
              ),
            ],
          ),
        ),
      ],
    ));
>>>>>>> parent of 6823e27 (Main Screen and Matching Screen)
  }
}
