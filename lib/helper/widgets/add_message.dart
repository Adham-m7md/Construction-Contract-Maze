import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maze/pages/home_page.dart';

// ignore: must_be_immutable
class AddMessage extends StatefulWidget {
  const AddMessage({
    super.key,
  });

  @override
  State<AddMessage> createState() => _AddMessageState();
}

class _AddMessageState extends State<AddMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  String? messageText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, right: 16, left: 16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _messageController,
              onChanged: (value) {
                messageText = value;
              },
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    if (messageText != null && messageText!.isNotEmpty) {
                      fireStore.collection('messages').add({
                        'text': messageText,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      _messageController.clear();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ),
                hintText: 'Ask new question...',
                hintStyle: const TextStyle(
                    color: Colors.black45,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
