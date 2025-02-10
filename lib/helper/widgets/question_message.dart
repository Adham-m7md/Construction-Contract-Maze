// question_user_message.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class QuestionUserMessage extends StatefulWidget {
  final String? text;
  final String? answer;
  final bool isAdmin;
  final String messageId;

  const QuestionUserMessage({
    super.key,
    this.text,
    this.answer,
    this.isAdmin = false,
    required this.messageId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _QuestionUserMessageState createState() => _QuestionUserMessageState();
}

class _QuestionUserMessageState extends State<QuestionUserMessage> {
  void _showAnswerDialog() {
    final TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Answer'),
        content: TextField(
          controller: answerController,
          decoration: const InputDecoration(
            hintText: 'Enter your answer',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (answerController.text.isNotEmpty) {
                FirebaseFirestore.instance
                    .collection('messages')
                    .doc(widget.messageId)
                    .update({
                  'answer': answerController.text,
                  'answeredTimestamp': FieldValue.serverTimestamp()
                });

                Navigator.of(context).pop();
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(widget.messageId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(); // يمكنك استبدال هذا بعنصر تحميل إذا لزم الأمر
        }

        final messageData = snapshot.data!.data() as Map<String, dynamic>?;
        final answer = messageData?['answer'] ?? '';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0.5, 0.5),
                )
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.format_quote),
                  Center(
                    child: Text(
                      widget.text ?? '',
                      style: const TextStyle(fontSize: 17, color: Colors.blue),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.format_quote),
                  ),
                  if (answer.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.reply, color: Colors.blue.shade700),
                                const SizedBox(width: 8),
                                Text(
                                  'Admin Answer',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              answer,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.isAdmin && answer.isEmpty)
                    Center(
                      child: ElevatedButton(
                        onPressed: _showAnswerDialog,
                        child: const Text('Add Answer'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
