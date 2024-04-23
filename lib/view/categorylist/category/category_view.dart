import 'package:flutter/material.dart';
import 'package:retail_store/constant/app_constant.dart';

import '../../../model/category.dart';
import 'components/category_form.dart';

class CategoryView extends StatefulWidget {

  Category? category;
  CategoryView(this.category);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appBarColor,
        iconTheme: IconThemeData(color: AppConstant.cardTextColor),
        title: Text('Manage Category',
            style: TextStyle(
                color: AppConstant.cardTextColor, fontWeight: FontWeight.w500)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: CategoryForm(widget.category),
          ),
        ),
      ),
    );
  }
}
