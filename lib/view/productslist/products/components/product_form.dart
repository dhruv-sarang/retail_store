import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retail_store/constant/app_constant.dart';
import 'package:retail_store/model/product.dart';

import '../../../../firebase/firebase_service.dart';
import '../../../../model/category.dart';
import '../../../../utils/app_utils.dart';
import '../../../../widgets/custom_button.dart';

class ProductForm extends StatefulWidget {
  Product? product;

  ProductForm(this.product);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  String _name = '';
  String _desc = '';
  XFile? _newImage;
  double _price = 0;
  int _stockQuantity = 0;
  String? _selectedCategoryId;
  String _selectedCategory = '';
  String? _selectedUnitId;
  String _selectedUnit = '';
  double _discount = 0;
  String? existingImageUrl;

  final _formKey = GlobalKey<FormState>();
  FirebaseService _service = FirebaseService();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockQuantityController = TextEditingController();
  final _discountController = TextEditingController();

  List<Category> _categories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCategories();
    if (widget.product != null) {
      existingImageUrl = widget.product!.imageUrl;
      _nameController.text = widget.product!.name;
      _descController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _stockQuantityController.text = widget.product!.stockQuantity.toString();
      _discountController.text = widget.product!.discount.toString();
      _selectedUnitId = widget.product!.selectedUnit;
      _selectedCategoryId = widget.product!.selectedCategory;
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (existingImageUrl != null || _newImage != null) {
        _formKey.currentState!.save();

        _service
            .addProduct(
                productId: widget.product?.id,
                name: _name,
                desc: _desc,
                price: _price,
                newImage: _newImage,
                stockQuantity: _stockQuantity,
                selectedCategory: _selectedCategory,
                selectedUnit: _selectedUnit,
                discount: _discount,
                createdAt: widget.product?.createdAt,
                existingImageUrl: existingImageUrl,
                context: context)
            .then(
          (value) {
            if (value) {
              print('Product added successfully');
              Navigator.pop(context);
            } else {}
          },
        );
      } else {}
    }
  }

  Future<void> _pickImage() async {
    var image = await AppUtil.pickImageFromGallery();

    if (image != null) {
      setState(() {
        _newImage = image;
        print('image path : ${_newImage!.path}');
      });
    }
  }

  Future<void> _loadCategories() async {
    List<Category> categories = await _service.loadCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white.withOpacity(.7),
                    child: _newImage == null && existingImageUrl != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey.shade200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                existingImageUrl!,
                              ),
                            ),
                          )
                        : _newImage != null
                            ? CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey.shade200,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Image.file(
                                    File(_newImage!.path),
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.grey,
                              ),
                  ),
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    return AppUtil.validateName(value);
                  },
                  onSaved: (value) {
                    _name = value ?? '';
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(labelText: 'Product Description'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: (value) {
                    return AppUtil.validateDescription(value);
                  },
                  onSaved: (value) {
                    _desc = value ?? '';
                  },
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          return AppUtil.validateValue(value);
                        },
                        onSaved: (value) {
                          _price = double.parse(value ?? '0');
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _stockQuantityController,
                        decoration:
                            InputDecoration(labelText: 'Stock Quantity'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          return AppUtil.validateValue(value);
                        },
                        onSaved: (value) {
                          _stockQuantity = int.parse(value ?? '0');
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: InputDecoration(labelText: 'Select Category'),
                  items: _categories
                      .map<DropdownMenuItem<String>>((Category category) {
                    return DropdownMenuItem<String>(
                      value: category.name,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategoryId = value!;
                    });
                  },
                  onSaved: (newValue) {
                    _selectedCategory = newValue!;
                    _selectedCategory = _categories
                        .firstWhere((element) => element.name == newValue)
                        .name;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedUnitId,
                  decoration: InputDecoration(labelText: 'Select Unit'),
                  items: <String>['Kg', 'Litre', 'Piece', 'Dozen']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedUnitId = value!;
                    });
                  },
                  onSaved: (newValue) {
                    _selectedUnit = newValue!;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a unit';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _discountController,
                  decoration: InputDecoration(
                      labelText: 'Discount', suffixIcon: Icon(Icons.percent)),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    return AppUtil.validateValue(value);
                  },
                  onSaved: (value) {
                    _discount = double.parse(value ?? '0');
                  },
                ),
                SizedBox(height: 24),
                CustomButton(
                  backgroundColor: AppConstant.cardColor,
                  text:
                      widget.product != null ? 'Update Product' : 'Add Product',
                  textColor: AppConstant.cardTextColor,
                  onClick: () {
                    setState(() {
                      if (_newImage == null && existingImageUrl == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select an Image'),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }
                    });
                    _submitForm(context);
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
