import 'dart:io';

import 'package:flutter/material.dart';

import '../designs/my_button.dart';
import 'user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final bool isLoading;
  final void Function({
    required String email,
    required String userName,
    required String password,
    File? image,
    required bool isLogin,
  }) submitFn;
  AuthForm(
      {required this.isLogin, required this.isLoading, required this.submitFn});
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  bool _showPassword = false;
  bool _needImage = true;
  bool _isLogin = false;

  @override
  void initState() {
    _isLogin = widget.isLogin;
    super.initState();
  }

  bool _emailValidation(String email) {
    var result = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return result;
  }

  bool _passwordValidation(String email) {
    var result =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(email);
    return result;
  }

  String _userEmail = '';
  String _userName = '';
  String _password = '';
  File? _userImage;

  void _pickedImage(File? image) {
    _userImage = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_needImage && _userImage == null && !_isLogin) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Upload Profile Picture',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue),
          ),
          content: Text(
              'You didn\'t upload a Profile Picture.\nDo you want to upload picture now?'),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          actionsAlignment: MainAxisAlignment.end,
          actionsPadding: EdgeInsets.zero,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _needImage = true;
                });
                return;
              },
              child: Text(
                'Yes',
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (isValid) {
                  _formKey.currentState!.save();
                  widget.submitFn(
                    email: _userEmail.trim(),
                    password: _password.trim(),
                    userName: _userName.trim(),
                    image: _userImage,
                    isLogin: _isLogin,
                  );
                }
              },
              child: Text(
                'No',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }

    if (isValid && (_userImage != null || !_needImage)) {
      _formKey.currentState!.save();
      widget.submitFn(
        email: _userEmail.trim(),
        password: _password.trim(),
        userName: _userName.trim(),
        image: _userImage,
        isLogin: _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_isLogin)
              Container(
                height: 180,
                child: Image.asset('images/logo.png'),
              ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: AnimatedSize(
                clipBehavior: Clip.antiAlias,
                curve: Curves.easeInOut,
                duration: Duration(
                  milliseconds: 500,
                ),
                child: Form(
                  key: _formKey,
                  //autovalidateMode: AutovalidateMode.,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!_isLogin) UserImagePicker(imagePickFn: _pickedImage),
                      if (!_isLogin)
                        TextFormField(
                          key: Key('username'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your username';
                            } else if (value.length < 4) {
                              return 'Username should be at least 4 Characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userName = value!;
                          },
                          //textAlign: TextAlign.center,
                          maxLines: 1,
                          controller: _userController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            prefixIcon: Icon(Icons.supervisor_account_outlined),
                            hintText: 'Enter your Username',
                            hintStyle: TextStyle(fontStyle: FontStyle.italic),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 15),
                      TextFormField(
                        key: Key('email'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your E-Mail';
                          } else if (!_emailValidation(value)) {
                            return 'Please enter a valid E-Mail address';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _userEmail = value!;
                        },
                        //textAlign: TextAlign.center,
                        maxLines: 1,
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: 'Enter your E-Mail',
                          hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        key: Key('password'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          } else if (!_passwordValidation(value)) {
                            return 'Password should be at least 8 Characters and should contain Capital, small letter & Number & Special ';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                        obscureText: _showPassword ? false : true,
                        keyboardType: TextInputType.visiblePassword,
                        //textAlign: TextAlign.center,
                        maxLines: 1,
                        controller: _pass,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          //prefixIcon: Icon(Icons.lock_outline_rounded),
                          prefixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              icon: _showPassword
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility)),
                          hintText: 'Enter your Password',
                          hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      if (!_isLogin)
                        TextFormField(
                          key: Key('conf-password'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please re-enter your password';
                            } else if (value != _pass.text) {
                              return 'Password does not match';
                            }
                            return null;
                          },
                          obscureText: _showPassword ? false : true,
                          keyboardType: TextInputType.visiblePassword,
                          // textAlign: TextAlign.center,
                          maxLines: 1,
                          controller: _confirmPass,
                          textInputAction: TextInputAction.done,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            prefixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              icon: _showPassword
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                            ),
                            hintText: 'Re-Enter your Password',
                            hintStyle: TextStyle(fontStyle: FontStyle.italic),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 15),
                      if (widget.isLoading)
                        Center(child: CircularProgressIndicator()),
                      if (!widget.isLoading)
                        MyButtun(
                          color:
                              _isLogin ? Color(0xffFEAA2E) : Color(0xff0B6EF1),
                          title: _isLogin ? 'Sign in' : 'Register',
                          onpressed: _trySubmit,
                        ),
                      SizedBox(height: 5),
                      if (!widget.isLoading)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                              _pass.clear();
                              _confirmPass.clear();
                              _userController.clear();
                              _emailController.clear();
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create New Account'
                              : 'Already have an Account? Login Now'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
