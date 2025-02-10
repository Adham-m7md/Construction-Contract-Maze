// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:maze/helper/widgets/constants.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maze/utils/app_directions.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});
  static const String id = 'infopage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_backspace_outlined,
            size: 28,
            color: kWhiteColor,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Details',
          style: TextStyle(color: kWhiteColor),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 19, 100, 131),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              kLogo,
              height: context.screenHeight * 0.3,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Get In Touch',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(
              height: context.screenHeight * 0.01,
            ),
            GetInTouchContacts(
                icon: FontAwesomeIcons.link, text: 'www.yourwebsite.com'),
            SizedBox(
              height: context.screenHeight * 0.01,
            ),
            GetInTouchContacts(icon: Icons.email, text: 'yourmail@mail.com'),
            SizedBox(
              height: context.screenHeight * 0.01,
            ),
            GetInTouchContacts(icon: FontAwesomeIcons.phone, text: '123456'),
            SizedBox(
              height: context.screenHeight * 0.01,
            ),
            GetInTouchContacts(
                icon: FontAwesomeIcons.whatsapp, text: '01234567890'),
            SizedBox(
              height: context.screenHeight * 0.01,
            ),
            GetInTouchContacts(
                icon: FontAwesomeIcons.facebook, text: 'www.facebook.com'),
            SizedBox(
              height: context.screenHeight * 0.01,
            ),
            GetInTouchContacts(
                icon: FontAwesomeIcons.youtube, text: 'www.youtube.com'),
            SizedBox(
              height: context.screenHeight * 0.01,
            ),
            GetInTouchContacts(
                icon: FontAwesomeIcons.linkedin, text: 'www.linkedin.com'),
            SizedBox(
              height: context.screenHeight * 0.01,
            ),
            GetInTouchContacts(icon: FontAwesomeIcons.x, text: 'www.x.com'),
            SizedBox(
              height: context.screenHeight * 0.01,
            ),
          ],
        ),
      ),
    );
  }
}

class GetInTouchContacts extends StatelessWidget {
  GetInTouchContacts(
      {Key? key, required this.icon, required this.text, this.iconsize})
      : super(key: key);
  final IconData icon;
  final String text;
  final double? iconsize;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: kBlackColor.withOpacity(0.7),
          size: iconsize,
        ),
        const SizedBox(
          width: 20,
        ),
        Text(text, style: const TextStyle(fontSize: 17, color: kPrimaryColor))
      ],
    );
  }
}
