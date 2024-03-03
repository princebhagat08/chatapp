import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({Key? key}) : super(key: key);

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final textController = TextEditingController();
  var _enteredMessage = '';

  void _sendMessages()  async {
    FocusScope.of(context).unfocus();
    final user =  FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'time': DateTime.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userimage': userData['image_url']

    });
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 10, left: 10, right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.teal)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Send a message',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send_rounded,
              size: 35,
              color: _enteredMessage.trim().isEmpty
                  ? Colors.teal.withOpacity(0.4)
                  : Colors.teal,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessages,
          )
        ],
      ),
    );
  }
}
