

import 'package:communtiy/getx_ui/party_upload.dart';
import 'package:communtiy/getx_ui/user_upload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/icons.dart';
import '../utils/theme.dart';

class UploadTab extends StatefulWidget{
   UploadTab({Key? key}) : super(key: key);

  @override
  State<UploadTab> createState() => _UploadTabState();
}

class _UploadTabState extends State<UploadTab> with TickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: TabBarView(
          controller: _tabController,
          children: [
            PartyUpload(),
            UserUpload(),
          ]),
    );
  }

  AppBar buildAppBar(BuildContext context) {
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
                          ..color = Colors.black),
                  ),
                  Text(
                    "Community",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Theme.of(context).primaryColor),
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
            padding: const EdgeInsets.only(bottom: 20.0, top: 10),
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
      ],
      bottom: PreferredSize(
        preferredSize: Size(double.infinity, h*0.05),
        child: TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
          indicatorWeight: 0,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
            tabs: const [
              Tab(text: "Party",),
              Tab(text: "User",)
            ]
        ),

      ),
    );
  }
}
