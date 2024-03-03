import 'package:chatapp/widgets/chats/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.value( FirebaseAuth.instance.currentUser),
        builder: (ctx, futureSnapshot){
          if(futureSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          return   StreamBuilder(
              stream: FirebaseFirestore.instance.collection('chat').orderBy('time',descending: true).snapshots(),
              builder: (context, chatSnapshots) {
                if (chatSnapshots.connectionState == ConnectionState.waiting) {
                  return  Center(child: CircularProgressIndicator());
                }
                final chatDocs = chatSnapshots.data?.docs;
                return ListView.builder(
                  reverse: true,
                  itemBuilder: (ctx, index) {
                    return MessageBubble(
                        chatDocs?[index]['text'],
                        chatDocs?[index]['username'],
                        chatDocs?[index]['userimage'],
                        chatDocs![index]['userId'] == futureSnapshot.data?.uid,
                       key2: ValueKey(chatDocs[index].id),
                    );
                  },
                  itemCount: chatDocs?.length,
                );
              });
        });


  }
}
