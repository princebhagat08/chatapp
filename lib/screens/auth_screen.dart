import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapp/widgets/auth/auth_form.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _showAlertDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text(
              'An error has Occurred!!',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'))
            ],
          );
        });
  }

  void submitForm(
    String username,
    String password,
    String email,
    bool isLogin,
    File? selectedImage,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;

    setState(() {
      _isLoading = true;
    });

    try {
      if (isLogin) {
        userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final UserId = FirebaseAuth.instance.currentUser?.uid;
        final storageRef = FirebaseStorage.instance.ref();
        final fileName = selectedImage?.path.split("/").last;
        final timeStamp = DateTime.now().microsecondsSinceEpoch;

        final uploadRef = storageRef
            .child('user_image')
            .child('${userCredential.user!.uid}.jpg');

        await uploadRef.putFile(selectedImage!);

        final url = await uploadRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': url,
        });
      }
    } on FirebaseAuthException catch (error) {
      String? message = 'An error occurred! \nPlease check your credentials';

      if (error.message != null) {
        message = error.message;
      }

      _showAlertDialog(message!);

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(submitFn: submitForm, loading: _isLoading),
    );
  }
}
