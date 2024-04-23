import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:retail_store/constant/app_constant.dart';

import '../../firebase/firebase_service.dart';
import '../../model/category.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  final FirebaseService _service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appBarColor,
        iconTheme: IconThemeData(color: AppConstant.cardTextColor),
        title: Text('Categories',
            style: TextStyle(
                color: AppConstant.cardTextColor, fontWeight: FontWeight.w500)),
      ),
      body: StreamBuilder(
        stream: _service.getCategoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error : ${snapshot.error.toString()}'),
            );
          } else {
            // success
            List<Category> categories = snapshot.data ?? [];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  Category category = categories[index];
                  return Card(
                    color: AppConstant.cardColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: [
                                  // Text(
                                  //   '${category.name}',
                                  //   style: TextStyle(
                                  //       fontSize: AppConstant.titleFontSize,
                                  //       fontWeight: FontWeight.bold),
                                  // ),
                                  Card(
                                    color: AppConstant.imageBgColour,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.25,
                                      // decoration: BoxDecoration(border: Border.all(width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: category.imageUrl,
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            '${category.name}',
                                            style: TextStyle(
                                                fontSize:
                                                    AppConstant.titleFontSize,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDeleteDialog(
                                                  category.id, context);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text.rich(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Description : ',
                                              style: TextStyle(
                                                  fontSize:
                                                      AppConstant.subDetailSize,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            TextSpan(
                                              text: '${category.description}',
                                              style: TextStyle(
                                                fontSize:
                                                    AppConstant.subDetailSize,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
/*
                  return Card(
                    color: AppConstant.cardColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, AppConstant.categoryView,
                              arguments: category);
                        },
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.imageBgColour,
                          radius: 30,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                              imageUrl: category.imageUrl,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                        title: Text(
                          category.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppConstant.cardTextColor),
                        ),
                        subtitle: Text(
                          category.description,
                          style: TextStyle(color: AppConstant.cardTextColor),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            print(
                                'id : ${category.id}  name : ${category.name}');
                            showDeleteDialog(category.id, context);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    ),
                  );
*/
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstant.imageBgColour,
        onPressed: () {
          Navigator.pushNamed(context, AppConstant.categoryView);
        },
        child: Icon(
          Icons.add,
          color: AppConstant.cardTextColor,
          size: 30,
        ),
      ),
    );
  }

  Future<void> showDeleteDialog(String? catId, BuildContext context) async {
    var res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Are you sure you want to delete this category?',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (res) {
      await _service.deleteCategory(catId!);
    }
  }
}
