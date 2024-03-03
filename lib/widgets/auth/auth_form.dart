import 'dart:io';

import 'package:chatapp/widgets/picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool loading;

  final void Function(
    String username,
    String password,
    String email,
    bool isLogin,
    File? image,
    BuildContext context,
  ) submitFn;

  const AuthForm({super.key, required this.submitFn, required this.loading});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  bool _isLogin = true;

  var _userEmail = '';
  var _userUsername = '';
  var _userPassword = '';
  File? _userimage;

  void _pickeImage(File image) {
    _userimage = image;
  }

  void _onSubmit() {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userimage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text('Please pick profile photo'),
          ),
        ),
      );
      return;
    }

    if (isValid) {
      _formkey.currentState?.save();
      widget.submitFn(
          _userUsername.trim(),
          _userPassword.trim(),
          _userEmail.trim(),
          _isLogin,
          _userimage,
          context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) Imagepicker(_pickeImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Enter the valid Email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Enter atleast 4 characters username';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        _userUsername = value!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.length < 8) {
                        return 'Enter a strong password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  widget.loading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _onSubmit,
                          child: Text(_isLogin ? 'Login' : 'SignUp')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create a new account'
                          : 'I already have an account')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
