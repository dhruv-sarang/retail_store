import 'dart:ffi';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retail_store/model/category.dart';
import 'package:retail_store/model/product.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final Reference _storagereference = FirebaseStorage.instance.ref();

  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
    required Function(UserCredential) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      onSuccess(credential);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      onError(errorMessage);
    }
  }

  Future<bool> addCategory(
      {required String name,
      required String desc,
      XFile? newImage,
      String? categoryId,
      String? existingImageUrl,
      int? createdAt,
      required BuildContext context}) async {
    String imageUrl = existingImageUrl ?? '';

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      );

      if (newImage != null) {
        // String filePath = 'categories/${DateTime.now().millisecondsSinceEpoch}.png';
        TaskSnapshot snapshot = await _storagereference
            .child('categories')
            .child('${DateTime.now().millisecondsSinceEpoch}.png')
            .putFile(File(newImage!.path));

        imageUrl = await snapshot.ref.getDownloadURL();
      }

      int timestamp = createdAt ?? DateTime.now().millisecondsSinceEpoch;

      Category category = Category(
          id: categoryId,
          name: name,
          description: desc,
          createdAt: timestamp,
          imageUrl: imageUrl);

      if (categoryId == null) {
        // create
        var id = _databaseReference.child('categories').push().key;
        category.id = id;

        _databaseReference
            .child('categories')
            .child(category.id!)
            .set(category.toMap());
      } else {
        // update
        _databaseReference
            .child('categories')
            .child(category.id!)
            .update(category.toMap());
      }

      Navigator.pop(context);
      return true;
    } catch (e) {
      Navigator.pop(context);
      return false;
    }
  }

  Stream<List<Category>> getCategoryStream() {
    return _databaseReference.child("categories").onValue.map((event) {
      List<Category> categoryList = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          final category = Category.fromMap(value);
          categoryList.add(category);
        });
      }
      return categoryList;
    });
  }

  Future<List<Category>> loadCategories() async {
    DataSnapshot snapshot = await _databaseReference.child('categories').get();
    List<Category> categories = [];
    if (snapshot.exists) {
      Map<dynamic, dynamic> categoriesMap =
          snapshot.value as Map<dynamic, dynamic>;
      categoriesMap.forEach((key, value) {
        final category = Category.fromMap(value);
        categories.add(category);
      });
    }
    return categories;
  }

  Future<bool> deleteCategory(String catId) async {
    try {
      await _databaseReference.child('categories').child(catId).remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addProduct(
      {required String name,
      required String desc,
      XFile? newImage,
      required double price,
      required int stockQuantity,
      required String selectedCategory,
      required String selectedUnit,
      required double discount,
      String? productId,
      String? existingImageUrl,
      int? createdAt,
      required BuildContext context}) async {
    String imageUrl = existingImageUrl ?? '';
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      );

      if (newImage != null) {
        // String filePath = 'categories/${DateTime.now().millisecondsSinceEpoch}.png';
        TaskSnapshot snapshot = await _storagereference
            .child('product')
            .child('${DateTime.now().millisecondsSinceEpoch}.png')
            .putFile(File(newImage!.path));

        imageUrl = await snapshot.ref.getDownloadURL();
      }

      int timestampProduct = createdAt ?? DateTime.now().millisecondsSinceEpoch;

      Product product = Product(
          id: productId,
          name: name,
          description: desc,
          price: price,
          stockQuantity: stockQuantity,
          selectedCategory: selectedCategory,
          selectedUnit: selectedUnit,
          discount: discount,
          imageUrl: imageUrl,
          createdAt: timestampProduct);

      if (productId == null) {
        // create
        var id = _databaseReference.child('product').push().key;
        product.id = id;

        _databaseReference
            .child('product')
            .child(product.id!)
            .set(product.toMap());
      } else {
        // update
        _databaseReference
            .child('product')
            .child(product.id!)
            .update(product.toMap());
      }

      Navigator.pop(context);
      return true;
    } catch (e) {
      Navigator.pop(context);
      return false;
    }
  }

  Stream<List<Product>> getProductStream() {
    return _databaseReference.child("product").onValue.map((event) {
      List<Product> productList = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          final product = Product.fromMap(value);
          productList.add(product);
        });
      }
      return productList;
    });
  }

  Future<bool> deleteProduct(String proId) async {
    try {
      await _databaseReference.child('product').child(proId).remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
