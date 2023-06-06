import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

class fileUpload extends StatefulWidget {
  const fileUpload({Key? key}) : super(key: key);

  @override
  State<fileUpload> createState() => _bulkUploadState();
}

class _bulkUploadState extends State<fileUpload> {
  List<List<dynamic>> data = [];
  String? filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("CSV File Uploader",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              )),
        ),
        body: Column(
          children: [
            const SizedBox(height: 5.0),
            ElevatedButton(
              child: const Text("Upload File"),
              onPressed: () {
                _pickFile();
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return Card(
                    margin: const EdgeInsets.all(3),
                    color: index == 0 ? Colors.amber : Colors.white,
                    child: ListTile(
                      leading: Text(
                        data[index][0].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: index == 0 ? 18 : 15,
                            fontWeight: index == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: index == 0 ? Colors.red : Colors.black),
                      ),
                      title: Text(
                        data[index][1],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: index == 0 ? 18 : 15,
                            fontWeight: index == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: index == 0 ? Colors.red : Colors.black),
                      ),
                      trailing: Text(
                        data[index][2],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: index == 0 ? 18 : 15,
                            fontWeight: index == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: index == 0 ? Colors.red : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;

    filePath = result.files.first.path!;

    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter(eol: '\n'))
        .toList();

    setState(() {
      data = fields;
    });
  }
}
