import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_ai/Constants/Constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

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
      _messages
          .add(Message(isUser: true, message: message, date: currentTime));
    });

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    setState(() {
      _messages.add(Message(
          isUser: false, message: response.text ?? "", date: currentTime));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gemini Ai ChatBot"),),
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
                    date: message.date);
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
                          borderRadius: BorderRadius.circular(50)),
                      label: const Text("Enter your message"),
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                    padding: EdgeInsets.all(15),
                    iconSize: 25,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(CircleBorder()),
                    ),
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}


class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final DateTime date;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isUser ? 100 : 10,
        right: isUser ? 10 : 100,
      ),
      decoration: BoxDecoration(
          color: isUser ? Color.fromARGB(255, 9, 48, 79) : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
            topRight: Radius.circular(10),
            bottomRight: isUser ? Radius.zero : Radius.circular(10),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(color: isUser ? Colors.white : Colors.black),
          ),
          Text(
            DateFormat('HH:mm').format(date),
            style: TextStyle(color: isUser ? Colors.white : Colors.black),
          ),
        ],
      ), // Display the message text
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  const Message({
    required this.isUser,
    required this.message,
    required this.date,
  });
}