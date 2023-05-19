import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
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
  @override
  void initState() {
    super.initState();
    // formattedDateTime = formatDateTime(DateTime.now());
    textController.addListener(_updateButtonState);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    // socket = IO.io('http://your-socket-io-server.com', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': false,
    // });
    // socket.connect();
    // socket.on('message', (data) {
    //   setState(() {
    //     mockMessages.add(data['message']);
    //   });
    // });
  }

  ScrollController scrollController = ScrollController();
  TextEditingController textController = TextEditingController();
  String inputMessage = '';
  
  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('MMM d, yyyy HH:mm a');
    return formatter.format(dateTime);
  }
  void _sendMessage(String message) {
    setState(() {
      if (_isButtonEnabled) {
        mockMessages.add(message);
        mockMessages.add("Incorrect");
      }
    });
    // socket.emit('message', {'message': message});
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
            controller: scrollController,
            itemCount: mockMessages.length,
            itemBuilder: (BuildContext context, int index) {
              final message = mockMessages[index];
              final sender = index % 2 == 0 ? 'Nahid' : 'AI BOT';
              var formattedDateTime = formatDateTime(DateTime.now());
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
                        ? Colors.blue
                        : const Color.fromARGB(255, 0, 213, 255),
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
                      const SizedBox(height: 4.0),
                      Text(
                        formattedDateTime,
                        style: TextStyle(
                          fontSize: 12.0,
                          color:
                              isCurrentUser ? Colors.white70 : Colors.white70,
                        ),
                      ),
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
                      textController.clear();
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _isButtonEnabled
                      ? () {
                          String message = textController.text;
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
