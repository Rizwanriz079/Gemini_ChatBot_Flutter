import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_ai/Constants/Constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import 'message.dart';
import 'dart:io'; // Import the 'dart:io' library

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userMessage = TextEditingController();
  final model = GenerativeModel(model: 'gemini-pro', apiKey: Apikey);
  final List<Message> _messages = [];

  Future<void> sendMessage() async {
    final message = _userMessage.text;
    _userMessage.clear();

    final currentTime = DateTime.now();

    setState(() {
      _messages.add(Message(
        isUser: true,
        message: message,
        date: currentTime,
      ));
    });

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    setState(() {
      _messages.add(Message(
        isUser: false,
        message: response.text ?? "",
        date: currentTime,
      ));
    });
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final currentTime = DateTime.now();
      final String fileName = pickedFile.path.split('/').last;
      final File imageFile = File(pickedFile.path);
      final int fileSize = await imageFile.length();

      // Ensure that the file exists before proceeding
      if (imageFile.existsSync()) {
        setState(() {
          // Add the image message to the chat messages list
          _messages.add(Message(
            isUser: true,
            message: 'image:${pickedFile.path}',
            date: currentTime,
          ));
        });
      } else {
        print('Error: File does not exist.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gemini Ai ChatBot"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Messages(
                  isUser: message.isUser,
                  message: message.message,
                  date: message.date,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 15,
                  child: TextFormField(
                    controller: _userMessage,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      label: const Text("Enter your message"),
                    ),
                  ),
                ),
                Spacer(),
                // IconButton(
                //   padding: EdgeInsets.all(15),
                //   style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all(Colors.black),
                //     foregroundColor: MaterialStateProperty.all(Colors.white),
                //     shape: MaterialStateProperty.all(CircleBorder()),
                //   ),
                //   iconSize: 25,
                //   icon: Icon(
                //       Icons.image), // Use the image icon for uploading images
                //   onPressed:
                //   _uploadImage, // Call the _uploadImage function when pressed
                // ),
                IconButton(
                  padding: EdgeInsets.all(15),
                  iconSize: 25,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(CircleBorder()),
                  ),
                  onPressed: () {
                    if (_userMessage.text.isNotEmpty) {
                      sendMessage();
                    } else {
                      _uploadImage();
                    }
                  },
                  icon: Icon(Icons.send),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
