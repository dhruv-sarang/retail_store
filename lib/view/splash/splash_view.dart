import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retail_store/constant/app_constant.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      var user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Navigate to home
        Navigator.pushReplacementNamed(context, AppConstant.homeView);
      } else {
        // Navigate to OnBoarding
        Navigator.pushReplacementNamed(context, AppConstant.onBoardingView);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.colorSplash,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              width: 120,
              child: Image(
                  image: AssetImage('assets/images/splash_logo.png'),
                  color: AppConstant.cardTextColor),
            ),
            SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Retail',
                    style: TextStyle(
                        fontSize: 62,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: AppConstant.cardTextColor)),
                Text('Store',
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: AppConstant.cardTextColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
