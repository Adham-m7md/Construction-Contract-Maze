import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionUserMessage extends StatefulWidget {
  final String? text;
  final String? answer;
  final String? country;
  final String? uid; // User ID to fetch the name
  final bool isAdmin;
  final String messageId;
  final VoidCallback? onDelete;

  const QuestionUserMessage({
    super.key,
    this.country,
    this.uid,
    this.text,
    this.answer,
    this.isAdmin = false,
    required this.messageId,
    this.onDelete,
  });

  @override
  _QuestionUserMessageState createState() => _QuestionUserMessageState();
}

class _QuestionUserMessageState extends State<QuestionUserMessage> {
  // late String username; // Default username

  @override
  void initState() {
    // username = '';
    super.initState();
    // _fetchUsername(); // Fetch the username when the widget initializes
  }
/* 
  Future<void> _fetchUsername() async {
    if (widget.uid != null) {
      try {
        // Fetch the user document from Firestore
        var collection = FirebaseFirestore.instance.collection('users');
        var docSnapshot = await collection.doc(widget.uid).get();

        if (docSnapshot.exists) {
          Map<String, dynamic> data = docSnapshot.data()!;
          print(data);
        }
      } catch (e) {
        print('Error fetching username: $e');
      }
    }
  } */

//FOR ADMIN
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
                  'answeredTimestamp': FieldValue.serverTimestamp(),
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

  void _showEditAnswerDialog() {
    final TextEditingController editAnswerController =
        TextEditingController(text: widget.answer);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Answer'),
        content: TextField(
          controller: editAnswerController,
          decoration: const InputDecoration(
            hintText: 'Edit your answer',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (editAnswerController.text.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('messages')
                    .doc(widget.messageId)
                    .update({
                  'answer': editAnswerController.text.trim(),
                });

                Navigator.of(context).pop(); // Close the dialog
              }
            },
            child: const Text('Save'),
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
          return Container();
        }

        final messageData = snapshot.data!.data() as Map<String, dynamic>?;
        print('messageData: $messageData');
        final answer = messageData?['answer'] ?? '';
        final country = messageData?['country'] ?? ''; // Country
        final username = messageData?['name'] ?? '';

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
                  Row(
                    children: [
                      const Icon(Icons.format_quote),
                      if (username.isNotEmpty || country.isNotEmpty)
                        Expanded(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (username.isNotEmpty)
                                  Text(
                                    username, // Use the fetched username
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                if (country.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      '($country)',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      if (widget.isAdmin)
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outlined,
                            color: Colors.deepOrangeAccent,
                          ),
                          onPressed: widget.onDelete,
                        ),
                    ],
                  ),
                  // Display the message text
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
                                if (widget.isAdmin)
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.lightGreen),
                                    onPressed: _showEditAnswerDialog,
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
