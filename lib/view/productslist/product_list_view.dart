import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constant/app_constant.dart';
import '../../firebase/firebase_service.dart';
import '../../model/product.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  var abc = true;

  final FirebaseService _service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appBarColor,
        iconTheme: IconThemeData(color: AppConstant.cardTextColor),
        title: Text('Products',
            style: TextStyle(
                color: AppConstant.cardTextColor, fontWeight: FontWeight.w500)),
      ),
      body: StreamBuilder(
        stream: _service.getProductStream(),
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
            List<Product> products = snapshot.data ?? [];
            return Container(
              height: double.infinity,
              width: double.infinity,
              // height: MediaQuery.of(context).size.height,
              // width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    Product product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppConstant.productView,
                            arguments: product);
                      },
                      child: Card(
                        color: AppConstant.cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                          imageUrl: product.imageUrl,
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
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${product.name}',
                                                style: TextStyle(
                                                    fontSize: AppConstant.titleFontSize,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showDeleteDialog(
                                                      product.id, context);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Category : ',
                                                  style: TextStyle(
                                                      fontSize: AppConstant.subDetailSize,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${product.selectedCategory}',
                                                  style:
                                                      TextStyle(fontSize: AppConstant.subDetailSize),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Price : ',
                                                  style: TextStyle(
                                                      fontSize: AppConstant.subDetailSize,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                TextSpan(
                                                  text: '${product.price}',
                                                  style:
                                                      TextStyle(fontSize: AppConstant.subDetailSize),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Unit : ',
                                      style: TextStyle(
                                          fontSize: AppConstant.subDetailSize,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: '${product.selectedUnit}',
                                      style: TextStyle(fontSize: AppConstant.subDetailSize),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Stock Quantity : ',
                                      style: TextStyle(
                                          fontSize: AppConstant.subDetailSize,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: '${product.stockQuantity}',
                                      style: TextStyle(fontSize: AppConstant.subDetailSize),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Discount : ',
                                      style: TextStyle(
                                          fontSize: AppConstant.subDetailSize,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: '${product.discount}',
                                      style: TextStyle(fontSize: AppConstant.subDetailSize),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
/*
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    abc = !abc;
                                  });
                                  print('Ellipsis clicked!');
                                  // You can perform any action here when the ellipsis is clicked
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Description : ',
                                                style: TextStyle(
                                                  fontSize: AppConstant.subDetailSize,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '${product.description}',
                                                style: TextStyle(
                                                  fontSize: AppConstant.subDetailSize,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          overflow: abc == true
                                              ? TextOverflow.ellipsis
                                              : TextOverflow.visible,
                                        ),
                                      ),
                                      abc == true
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  abc = false;
                                                });
                                              },
                                              child: Text(
                                                'more',
                                                style: TextStyle(
                                                  fontSize: AppConstant.subDetailSize,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              )
*/
                              Text.rich(
                                overflow: TextOverflow.ellipsis,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Description : ',
                                      style: TextStyle(
                                          fontSize: AppConstant.subDetailSize,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: '${product.description}',
                                      style: TextStyle(
                                        fontSize: AppConstant.subDetailSize,
                                        fontStyle: FontStyle.italic,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstant.imageBgColour,
        onPressed: () {
          Navigator.pushNamed(context, AppConstant.productView);
        },
        child: Icon(
          Icons.add,
          color: AppConstant.cardTextColor,
          size: 30,
        ),
      ),
    );
  }

  Future<void> showDeleteDialog(String? proId, BuildContext context) async {
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
      await _service.deleteProduct(proId!);
    }
  }
}
