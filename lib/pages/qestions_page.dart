import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maze/helper/widgets/constants.dart';
import 'package:maze/helper/widgets/message_streem_builder.dart';

class QuestionsPages extends StatelessWidget {
  const QuestionsPages({super.key});
  static const String id = 'QuestionsPages';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
  String? selectedCountry;
  final List<String> countries = ['Egypt', 'USA', 'UK', 'Germany', 'France'];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  String? messageText;

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
          DropdownButtonFormField<String>(
            value: selectedCountry,
            hint: const Text('Select Country'),
            onChanged: (value) {
              setState(() {
                selectedCountry = value;
              });
            },
            items: countries.map((String country) {
              return DropdownMenuItem<String>(
                value: country,
                child: Text(country),
              );
            }).toList(),
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
          onPressed: () {
            if (messageText != null &&
                messageText!.isNotEmpty &&
                selectedCountry != null) {
              FirebaseFirestore.instance.collection('messages').add({
                'text': messageText,
                'country': selectedCountry,
                'uid': currentUser?.uid, // اسم المستخدم
                'timestamp': FieldValue.serverTimestamp(),
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
