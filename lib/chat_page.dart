import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  List<String> mockMessages = [
    "Hello, how are you?",
    "Correct",
    "I rice eat.",
    "Incorrect",
    "That's wonderful to hear!",
    "Correct",
    "Thank you.",
    "Correct",
  ];
  // late String formattedDateTime;
  var _channel;
  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8000/check'),
    );

    textController.addListener(_updateButtonState);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  ScrollController scrollController = ScrollController();
  TextEditingController textController = TextEditingController();
  String inputMessage = '';

  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('MMM d, yyyy HH:mm a');
    return formatter.format(dateTime);
  }

  void bottomPosition() async {
    await Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage(String message) {
    String sentence = jsonEncode({"sentence": message});
    setState(() {
      if (_isButtonEnabled) {
        mockMessages.add(message);
      }
    });
    textController.clear();
    bottomPosition();
    _channel.sink.add(sentence);
    _channel.stream.listen((message) {
      Map<String, dynamic> correctedSentence = jsonDecode(message);
      setState(() {
        if (correctedSentence['corrections'].length == 0) {
          mockMessages.add("Correct Sentence");
        } else {
          mockMessages.add(correctedSentence['result']);
        }
      });
      bottomPosition();
    });
  }

  bool _isButtonEnabled = false;

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = textController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    textController.removeListener(_updateButtonState);
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Center(child: Text('Correct Me Application'))),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
            controller: scrollController,
            itemCount: mockMessages.length,
            itemBuilder: (BuildContext context, int index) {
              final message = mockMessages[index];
              final sender = index % 2 == 0 ? 'Nahid' : 'AI BOT';
              // var formattedDateTime = formatDateTime(DateTime.now());
              final isCurrentUser = sender == 'Nahid';
              return Align(
                alignment:
                    isCurrentUser ? Alignment.topRight : Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? const Color.fromARGB(255, 128, 64, 248)
                        : const Color.fromARGB(255, 53, 53, 53),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sender,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: isCurrentUser ? Colors.white : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: isCurrentUser ? Colors.white : Colors.white,
                        ),
                      ),
                      // const SizedBox(height: 4.0),
                      // Text(
                      //   formattedDateTime,
                      //   style: TextStyle(
                      //     fontSize: 12.0,
                      //     color:
                      //         isCurrentUser ? Colors.white70 : Colors.white70,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText:
                          'Please enter a sentence to determine its validity.',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        inputMessage = value;
                      });
                    },
                    onSubmitted: (value) {
                      _sendMessage(value);
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _isButtonEnabled
                      ? () {
                          String message = textController.text.trim();
                          _sendMessage(message);
                          textController.clear();
                        }
                      : null,
                  backgroundColor: _isButtonEnabled ? Colors.blue : Colors.grey,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
