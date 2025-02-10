import 'package:flutter/material.dart';
import 'package:maze/helper/widgets/add_message.dart';
import 'package:maze/helper/widgets/message_streem_builder.dart';

class QuestionsPages extends StatelessWidget {
  const QuestionsPages({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          AddMessage(),
          Expanded(
            child: MessageStreamBuilder(),
          ),
        ],
      ),
    );
  }
}
