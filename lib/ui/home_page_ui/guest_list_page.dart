

import 'package:communtiy/models/user_details/user_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GuestListPage extends StatelessWidget {
  final List<UserDetailsModel> guests;
  const GuestListPage({Key? key,required this.guests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:Text("${guests[0].userName}")),
    );
  }
}
