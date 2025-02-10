import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maze/helper/widgets/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});
  static const String id = 'VideosPage';

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  // Controllers for the text fields
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if the current user is admin
  bool get isAdmin {
    final user = _auth.currentUser;
    return user != null && user.email == "admin@gmail.com";
  }

  // Function to show the AlertDialog
  void _showAddVideoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Video'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // To make the dialog compact
            children: [
              // Description TextField
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter video description',
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16), // Spacing between fields
              // Link TextField
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'HTTP Link',
                  hintText: 'Enter video URL',
                ),
                keyboardType: TextInputType.url, // For URL input
              ),
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            // Add Button
            TextButton(
              onPressed: () async {
                // Handle the "Add" action
                final String description = _descriptionController.text;
                final String link = _linkController.text;

                // Validate inputs
                if (description.isNotEmpty && link.isNotEmpty) {
                  // Add the video to Firestore
                  await _firestore.collection('videos').add({
                    'description': description,
                    'link': link,
                    'timestamp': FieldValue
                        .serverTimestamp(), // Optional: Add a timestamp
                  });

                  // Clear the text fields
                  _descriptionController.clear();
                  _linkController.clear();

                  // Close the dialog
                  Navigator.of(context).pop();

                  // Show a toast message using fluttertoast
                  Fluttertoast.showToast(
                    msg: "تمت إضافة الفيديو: $description", // Arabic message
                    toastLength: Toast.LENGTH_SHORT, // Duration
                    gravity: ToastGravity.BOTTOM, // Position
                    backgroundColor: Colors.green, // Background color
                    textColor: Colors.white, // Text color
                    fontSize: 16.0, // Font size
                  );
                } else {
                  // Show an error toast if fields are empty
                  Fluttertoast.showToast(
                    msg: "Please fill all fields.", // Error message
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red, // Red for error
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Function to launch the URL
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Column(
        children: [
          // Display the list of videos from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('videos')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No videos found.'));
                }

                final videos = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    final data = video.data() as Map<String, dynamic>;

                    return Card(
                      color: const Color.fromARGB(255, 153, 183, 246),
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(data['description']),
                        subtitle: Text(data['link']),
                        trailing: isAdmin
                            ? IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  // Delete the video from Firestore
                                  await _firestore
                                      .collection('videos')
                                      .doc(video.id)
                                      .delete();
                                },
                              )
                            : null,
                        onTap: () {
                          // Open the link when the ListTile is tapped
                          _launchUrl(data['link']);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: kPrimaryColor,
              onPressed: _showAddVideoDialog, // Show the dialog on button press
              child: const Icon(
                Icons.add,
                color: kWhiteColor,
              ),
            )
          : null,
    );
  }
}
