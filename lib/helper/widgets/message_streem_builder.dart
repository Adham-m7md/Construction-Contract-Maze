// message_stream_builder.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maze/helper/widgets/question_message.dart';

class MessageStreamBuilder extends StatefulWidget {
  const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  State<MessageStreamBuilder> createState() => _MessageStreamBuilderState();
}

class _MessageStreamBuilderState extends State<MessageStreamBuilder> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // Show empty container instead of loading indicator
        if (!snapshot.hasData) {
          return Container();
        }

        final messages = snapshot.data?.docs ?? [];
        List<Widget> messageWidgets = [];

        for (var message in messages) {
          final messageData = message.data() as Map<String, dynamic>?;
          if (messageData == null) continue;

          final messageText = messageData['text'] ?? '';
          final isAdmin = checkIfUserIsAdmin(currentUser);
          final answer = messageData['answer'];

          messageWidgets.add(QuestionUserMessage(
            text: messageText,
            answer: answer,
            isAdmin: isAdmin,
            messageId: message.id,
          ));
        }

        return ListView.builder(
          itemCount: messageWidgets.length,
          itemBuilder: (context, index) => messageWidgets[index],
        );
      },
    );
  }

  bool checkIfUserIsAdmin(User? user) {
    return user != null && user.email == 'admin@gmail.com';
  }
}
