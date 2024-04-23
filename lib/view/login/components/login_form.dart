import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constant/app_constant.dart';
import '../../../firebase/firebase_service.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/custom_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isHidden = true, _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  String? _email, _password;
  bool isChecked = false;

  final FirebaseService _firebaseService = FirebaseService();

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _login(String _email, String _password) {
    // show progress

    setState(() => _isLoading = true);

    _firebaseService.signInWithEmailPassword(
      email: _email,
      password: _password,
      onSuccess: (UserCredential credential) {
        // hide progress
        setState(() => _isLoading = false);
        print('uid : ${credential.user!.uid}');
        // navigate to home
        Navigator.pushNamedAndRemoveUntil(
            context, AppConstant.homeView, (route) => false);
      },
      onError: (String message) {
        // hide progress
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email or password is incorrect'),
            duration: Duration(seconds: 5),
          ),
        );
        print('abcd : ${message}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            alignment: Alignment.center,
            child: Image.asset('assets/images/splash_logo.png',
                width: 100, height: 100, color: Colors.white, fit: BoxFit.fill),
          ),
          Text(
            'Admin Login',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            'Enter your email and password',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
          ),
          SizedBox(
            height: 40,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email address',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              labelStyle:
                  TextStyle(color: AppConstant.cardTextColor, fontSize: 18),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              return AppUtil.isValidEmail(value.toString());
            },
            onSaved: (email) {
              _email = email;
            },
          ),
          SizedBox(
            height: 16,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              labelStyle:
                  TextStyle(color: AppConstant.cardTextColor, fontSize: 18),
              suffixIcon: IconButton(
                onPressed: () {
                  _toggleVisibility();
                },
                icon: _isHidden
                    ? Icon(Icons.visibility_off_outlined)
                    : Icon(Icons.visibility_outlined),
              ),
              prefixIcon: Icon(Icons.lock_outline_rounded),
            ),
            validator: (value) {
              return AppUtil.checkPasswordEpmty(value.toString());
            },
            onSaved: (password) {
              _password = password;
            },
            keyboardType: TextInputType.text,
            obscureText: _isHidden,
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 40,
          ),
          _isLoading
              ? Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                )
              : CustomButton(
                  textColor: AppConstant.cardTextColor,
                  backgroundColor: Colors.green,
                  text: 'Login',
                  onClick: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _login(_email!, _password!);
                      print(_email);

                      /* if (isChecked) {
                        _formKey.currentState!.save();

                        print('email : $_email');
                        print('password : $_password');
                      } else {
                        print('allow terms and conditions.');
                      }*/
                    }
                  },
                ),
        ],
      ),
    );
  }
}
