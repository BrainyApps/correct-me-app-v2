import 'package:correct_me/chat_page.dart';
import 'package:correct_me/file_uploader.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Center(child: Text('Correct Me Application'))),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 50.0),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    fixedSize: const Size(190.0, 60.0),
                    enabledMouseCursor: SystemMouseCursors.basic,
                  ),
                  child: const Text(
                    'Correct Me App',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatScreen()),
                    );
                  }),
              const SizedBox(height: 10.0),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                      fixedSize: const Size(190.0, 60.0)),
                  child: const Text(
                    'File Uploader App',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const fileUpload()),
                    );
                  }),
            ],
          ),
        ));
  }
}
