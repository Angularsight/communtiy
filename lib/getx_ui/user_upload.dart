
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserUpload extends StatefulWidget {
  const UserUpload({Key? key}) : super(key: key);

  @override
  _UserUploadState createState() => _UserUploadState();
}

class _UserUploadState extends State<UserUpload> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("User Upload"),),
    );
  }
}
