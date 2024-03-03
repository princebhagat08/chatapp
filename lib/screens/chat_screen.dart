
import 'package:chatapp/widgets/chats/messages.dart';
import 'package:chatapp/widgets/chats/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5ebe0),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 25),
          child: Text(
            "Chat",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          PopupMenuButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            iconColor: Colors.white,
            itemBuilder: (BuildContext context) => [

              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Logout'),
                  ],
                ),
              ),

            ],
            onSelected: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }

            },
          ),
        ],
      ),
      body: Container(
        child: const Column(
          children: [
            Expanded(child: Messages()),
            NewMessages(),
          ],
        ),
      ),
    );
  }
}
