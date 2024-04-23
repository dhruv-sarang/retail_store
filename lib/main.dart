import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:retail_store/constant/app_constant.dart';
import 'package:retail_store/routing/app_route.dart';
import 'package:retail_store/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCzpblY5kdqY0z56cythDhBt5wIHwGpFWw",
          appId: "1:424545809822:android:e0b3c6b94600472a81528f",
          messagingSenderId: "424545809822",
          projectId: "retail-store-58bc2",
      storageBucket: "retail-store-58bc2.appspot.com"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppConstant.splashView,
      theme: AppTheme(context),
      onGenerateRoute: AppRoute.generateRoute,
    );
  }
}
