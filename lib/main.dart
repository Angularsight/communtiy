import 'package:communtiy/models/party_details.dart';
import 'package:communtiy/providers/firebase_provider.dart';
import 'package:communtiy/ui/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>FirebaseProvider()),
        ChangeNotifierProvider(create: (_)=>PartyDetails())
      ],

      builder: (context,child){
        return MaterialApp(
          title: 'Project Community',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
