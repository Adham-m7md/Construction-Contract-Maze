import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maze/helper/widgets/question_message.dart';

class MessageStreamBuilder extends StatefulWidget {
  const MessageStreamBuilder({super.key});

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
            onDelete: () => _deleteMessage(message.id),
          ));
        }

        return ListView.builder(
          itemCount: messageWidgets.length,
          itemBuilder: (context, index) => messageWidgets[index],
        );
      },
    );
  }

  // دالة للتحقق من أن المستخدم هو الأدمن
  bool checkIfUserIsAdmin(User? user) {
    return user != null && user.email == '4@test.com';
  }

  // دالة لحذف الرسالة
  Future<void> _deleteMessage(String messageId) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .delete();
  }
}
