import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final DateTime date;

  const Messages({
    Key? key,
    required this.isUser,
    required this.message,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.startsWith('image:')) {
      final imagePath = message.replaceFirst('image:', ''); // Place it here

      // Check if the file exists before trying to load it
      if (File(imagePath).existsSync()) {
        final fileName = imagePath
            .split('/')
            .last;
        final fileSize = File(imagePath).lengthSync();

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.symmetric(vertical: 15).copyWith(
            left: isUser ? 100 : 10,
            right: isUser ? 10 : 100,
          ),
          decoration: BoxDecoration(
            color: isUser ? Color.fromARGB(255, 9, 48, 79) : Colors.grey
                .shade300,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
              topRight: Radius.circular(10),
              bottomRight: isUser ? Radius.zero : Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: isUser
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Image.file(
                File(imagePath),
                width: MediaQuery.sizeOf(context).width,
                height: 300,
                fit: BoxFit.cover,
              ),
            ],
          ),
        );
      } else {
        // Display an error message if the file doesn't exist
        return Container(
          child: Text('Error: Image not found.'),
        );
      }
    } else {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10), // Add padding for text messages
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Text(message),
            Text(
              DateFormat('HH:mm').format(date),
            ),
          ],
        ),
      );
    }
  }
}