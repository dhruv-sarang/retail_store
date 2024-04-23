import 'package:flutter/material.dart';
import 'package:retail_store/constant/app_constant.dart';
import 'package:retail_store/model/category.dart';
import 'package:retail_store/model/product.dart';
import 'package:retail_store/view/categorylist/category/category_view.dart';
import 'package:retail_store/view/categorylist/category/components/category_form.dart';
import 'package:retail_store/view/categorylist/category_list_view.dart';
import 'package:retail_store/view/login/login_view.dart';
import 'package:retail_store/view/onboarding/onboarding_view.dart';
import 'package:retail_store/view/productslist/product_list_view.dart';
import 'package:retail_store/view/splash/splash_view.dart';

import '../view/home/home_view.dart';
import '../view/productslist/products/product_view.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstant.splashView:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );

      case AppConstant.onBoardingView:
        return MaterialPageRoute(
          builder: (context) => OnBoardingView(),
        );

      case AppConstant.loginView:
        return MaterialPageRoute(
          builder: (context) => LoginView(),
        );

      case AppConstant.homeView:
        return MaterialPageRoute(
          builder: (context) => HomeView(),
        );

      case AppConstant.categoryListView:
        return MaterialPageRoute(
          builder: (context) => CategoryListView(),
        );

      case AppConstant.categoryView:
        Category? category =
            settings.arguments != null ? settings.arguments as Category : null;
        return MaterialPageRoute(
          builder: (context) => CategoryView(category),
        );

      case AppConstant.productListView:
        return MaterialPageRoute(
          builder: (context) => ProductListView(),
        );

      case AppConstant.productView:
        Product? product = settings.arguments != null ? settings.arguments as Product : null;
        return MaterialPageRoute(
          builder: (context) => ProductView(product),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
    }
  }
}
