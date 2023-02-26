import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:strats360/Screens/user_listing.dart';

class SPLASH_SCREEN extends StatefulWidget {
  const SPLASH_SCREEN({Key? key}) : super(key: key);
  @override
  State<SPLASH_SCREEN> createState() => _SPLASH_SCREENState();
}

class _SPLASH_SCREENState extends State<SPLASH_SCREEN> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: USER_LISTING(),
      //title: new Text('Welcome In SplashScreen'),
      image: Image.asset('assets/Flutter_logo.png'),
      backgroundColor: Colors.white,
      photoSize: 100.0,
      // loaderColor: Colors.blue
    );
  }
}
