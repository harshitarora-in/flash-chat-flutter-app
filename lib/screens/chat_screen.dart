import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _fireStone = FirebaseFirestore.instance;
var _loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;
  void getCurrentUser() {
    try {
      _loggedInUser = _auth.currentUser;
      print(_loggedInUser);
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var messages in _fireStone.collection('messages').snapshots()) {
      for (var message in messages.docs) {
        print(message.data());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: null,
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      messageTextController.clear();
                      _fireStone.collection('messages').add({
                        'text': messageText,
                        'sender': _loggedInUser?.email,
                        'time': DateTime.now() //add this
                      });
                    },
                    child: Text('Send', style: kSendButtonTextStyle),
                  ),
                  SizedBox(width: 20.0)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStone
          .collection('messages')
          .orderBy('time', descending: false)
          .snapshots(), //orderBy added
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ));
        } else {
          final messages = snapshot.data?.docs.reversed;
          List<MessagesBubble> messageWidgets = [];
          for (var message in messages!) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final messageTime = message.get('time') as Timestamp; //add this
            final currentUserEmail = _loggedInUser.email;
            final messageWidget = MessagesBubble(
              messageSender: messageSender,
              messageText: messageText,
              isMe: messageSender == currentUserEmail,
              time: messageTime, //add this
            );
            messageWidgets.add(messageWidget);
          }
          return Expanded(
              child: ListView(
            reverse: true,
            children: messageWidgets,
          ));
        }
      },
    );
  }
}

class MessagesBubble extends StatelessWidget {
  MessagesBubble(
      {this.messageText,
      this.messageSender,
      required this.isMe,
      required this.time});
  final messageText;
  final messageSender;
  final bool isMe;
  final Timestamp time; // add this

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: isMe
                ? EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 2.0)
                : EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 2.0),
            child: Text(
                messageSender, // add this only if you want to show the time along with the email. If you dont want this then don't add this DateTime thin
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey,
                )),
          ),
          Padding(
            padding: isMe
                ? EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 6.0)
                : EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 6.0),
            child: Text(
                '${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}', // add this only if you want to show the time along with the email. If you dont want this then don't add this DateTime thin
                style: TextStyle(
                  fontSize: 6.0,
                  color: Colors.grey,
                )),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.only(
                  topLeft: isMe ? Radius.circular(30.0) : Radius.circular(0.0),
                  topRight: isMe ? Radius.circular(0.0) : Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                color: isMe ? Colors.lightBlueAccent : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    messageText,
                    style: TextStyle(
                        color: isMe ? Colors.white : Colors.black54,
                        fontSize: 16.0),
                  ),
                )),
          ),
        ]);
  }
}

//TODO chat order is not sorted
