import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retail_store/constant/app_constant.dart';
import 'package:retail_store/model/category.dart';
import '../../../../firebase/firebase_service.dart';
import '../../../../utils/app_utils.dart';
import '../../../../widgets/custom_button.dart';

class CategoryForm extends StatefulWidget {
  Category? category;

  CategoryForm(this.category);

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _desc = '';
  XFile? _newImage;
  String? existingImageUrl;

  final FirebaseService _service = FirebaseService();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      existingImageUrl = widget.category!.imageUrl;
      _nameController.text = widget.category!.name;
      _descController.text = widget.category!.description;
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (existingImageUrl != null || _newImage != null ) {
        _formKey.currentState!.save();

        _service
            .addCategory(
                name: _name,
                desc: _desc,
                newImage: _newImage,
                context: context,
                categoryId: widget.category?.id,
                createdAt: widget.category?.createdAt,
                existingImageUrl: existingImageUrl)
            .then(
          (value) {
            if (value) {
              print('Category added successfully');
              Navigator.pop(context);
            } else {}
          },
        );
      }
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              print('Select Image');
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
                        padding: const EdgeInsets.all(10.0),
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
          SizedBox(
            height: 24,
          ),
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(labelText: 'Category Name'),
            onSaved: (value) {
              _name = value ?? '';
            },
            validator: (value) {
              return AppUtil.validateName(value);
            },
          ),
          SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _descController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(labelText: 'Category Description'),
            maxLines: 3,
            onSaved: (value) {
              _desc = value ?? '';
            },
            validator: (value) {
              return AppUtil.validateDescription(value);
            },
          ),
          SizedBox(
            height: 32,
          ),
          CustomButton(
            backgroundColor: AppConstant.cardColor,
            text: widget.category != null ? 'Update Category' : 'Add Category',
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
    );
  }
}
