import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maze/helper/widgets/constants.dart';
import 'package:maze/pages/info_page.dart';
import 'package:maze/pages/qestions_page.dart';
import 'package:maze/pages/videos_page.dart';

final fireStore = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = 'Questionspage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const QuestionsPages(),
    const VideosPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void getMessagesStream() async {
    await for (var snapShotMessages
        in FirebaseFirestore.instance.collection('messages').snapshots()) {
      for (var message in snapShotMessages.docs) {
        message.data();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 100, 131),
        leading: IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.logout,
              color: kWhiteColor,
            )),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Welcome to Maze',
          style: TextStyle(color: kWhiteColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, InfoPage.id);
              },
              icon: const Icon(
                Icons.info_outline,
                color: kWhiteColor,
              ))
        ],
      ),
      backgroundColor: kWhiteColor,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kWhiteColor,
        // Display the selected page
        currentIndex: _selectedIndex, // Set the current index
        onTap: _onItemTapped, // Handle item tap
        landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
        selectedFontSize: 17,
        selectedItemColor: kPrimaryColor,
        showUnselectedLabels: false,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow_outlined), label: 'Videos')
        ],
      ),
    );
  }
}
