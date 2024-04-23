import 'package:flutter/material.dart';

import '../../constant/app_constant.dart';
import '../../firebase/firebase_service.dart';
import '../../model/dashboard_item.dart';


class HomeView extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  List<DashboardItem> itemList = [
    DashboardItem(
        title: 'Categories',
        imagePath: 'assets/images/categories.png',
        color: AppConstant.cardColor),
    DashboardItem(
        title: 'Products',
        imagePath: 'assets/images/product.png',
        color: AppConstant.cardColor),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appBarColor,
        title: Text('Dashboard',
            style: TextStyle(color: AppConstant.cardTextColor, fontWeight: FontWeight.w500)),
        actions: [
          PopupMenuButton(
            iconColor: AppConstant.cardTextColor,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Logout'),
                  onTap: () {
                    showAlertDialog(context);
                  },
                )
              ];
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: itemList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            DashboardItem item = itemList[index];

            return InkWell(
              onTap: () {
                if (index == 0) {
                  // categories
                  Navigator.pushNamed(context, AppConstant.categoryListView);
                } else if (index == 1) {
                  // products
                  Navigator.pushNamed(context, AppConstant.productListView);
                }
              },
              child: _buildGridItem(item),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridItem(DashboardItem item) {
    return Card(
      color: item.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white.withOpacity(.5),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    item.imagePath,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                item.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppConstant.cardTextColor,
                    fontSize: AppConstant.titleFontSize),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showAlertDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alert'),
        content: Text('Are you sure you want to Logout'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              _firebaseService.logout().then((result) {
                if (result) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppConstant.loginView, (route) => false);
                }
              });
            },
            child: Text('Yes'),
          )
        ],
      ),
    );
  }
}
