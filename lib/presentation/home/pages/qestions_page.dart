import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maze/core/widgets/constants.dart';
import 'package:maze/core/widgets/message_streem_builder.dart';

class QuestionsPages extends StatelessWidget {
  const QuestionsPages({super.key});
  static const String id = 'QuestionsPages';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: const SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MessageStreamBuilder(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddMessageDialog(),
          );
        },
        child: const Icon(
          Icons.add,
          color: kWhiteColor,
        ),
      ),
    );
  }
}

class AddMessageDialog extends StatefulWidget {
  const AddMessageDialog({super.key});

  @override
  State<AddMessageDialog> createState() => _AddMessageDialogState();
}

class _AddMessageDialogState extends State<AddMessageDialog> {
  final _messageController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    _countryController.dispose();

    super.dispose();
  }

  String? messageText, country;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return AlertDialog(
      title: const Text('Add New Question'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _messageController,
            onChanged: (value) {
              messageText = value;
            },
            minLines: 1,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Ask new question...',
              hintStyle: TextStyle(
                  color: Colors.black45,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _countryController,
            onChanged: (value) {
              country = value;
            },
            minLines: 1,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Add your country name',
              hintStyle: TextStyle(
                  color: Colors.black45,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (messageText != null &&
                messageText!.isNotEmpty &&
                country != null) {
              DocumentSnapshot userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser?.uid)
                  .get();
              FirebaseFirestore.instance.collection('messages').add({
                'text': messageText,
                'country': country,
                'name': userDoc.get('name') as String,
                'timestamp': FieldValue.serverTimestamp(),
                'uid': currentUser?.uid,
              });
              _messageController.clear();
              Navigator.of(context).pop();
            }
          },
          child: const Text('Send'),
        ),
      ],
    );
  }
}
