import 'dart:math';

import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final String userimage;
  final bool itsMe;
  final Key key2;


   const MessageBubble(this.message,this.username,this.userimage, this.itsMe,  {Key? key, required this.key2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: itsMe? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if(!itsMe)CircleAvatar(backgroundImage: NetworkImage(userimage),),
        Container(
          constraints: BoxConstraints(
            maxWidth: 200
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: itsMe? Colors.teal.withOpacity(0.7):Colors.blueGrey,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
              bottomLeft: itsMe? Radius.circular(15): Radius.circular(0),
              bottomRight: itsMe? Radius.circular(0) : Radius.circular(15),
            ),
          ),
          child: Column(
           crossAxisAlignment: !itsMe? CrossAxisAlignment.start: CrossAxisAlignment.end,
            children: [
              Text(username,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, ),
                ),
              Text(
                message,
                textAlign: itsMe? TextAlign.end: TextAlign.start,
                style:  TextStyle(
                    fontWeight: FontWeight.w400,
                    color:  Colors.white ),),
            ],
          ),
        ),
        if(itsMe) CircleAvatar(backgroundImage: NetworkImage(userimage),),
      ],
    );
  }
}
