import 'dart:convert';

import 'package:android_jarvis_interface/jarvis_request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    darkTheme: ThemeData.dark(),
    themeMode: ThemeMode.dark,
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController textFieldControl;
  List<String> responses = <String>['a', 'b', 'c', 'd', 'e'];

  @override
  void initState() {
    textFieldControl = TextEditingController();
    getRequests();
    super.initState();
  }

  @override
  void dispose() {
    textFieldControl.dispose();
    super.dispose();
  }

  Future<String> getRequests() async {
    var result = await http.get(Uri.parse(
        'https://jarvislinker.azurewebsites.net/api/JarvisRequests/'));
    List<dynamic> list = jsonDecode(result.body);
    JarvisRequest request = JarvisRequest.fromJson(list[0]);
    print(request.request);
    return result.body;
  }

  Widget buildListItem (BuildContext context, int index) {
    return Container(
      height: 30,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            width: 1,
            color: Colors.transparent,
          ),
        ),
        gradient: const LinearGradient(
            colors: [Colors.indigo, Colors.indigoAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(responses[index], style: const TextStyle(
          fontSize: 16,
        )),
      ),
    );
  }

  List<Widget> buildTextField() {
    return [
      const SizedBox(width: 5),
      Expanded(
        child: SizedBox(
          height: 20,
          child: TextField(
            controller: textFieldControl,
            cursorColor: Colors.white,
            style: const TextStyle(
              fontSize: 12,
            ),
            decoration: const InputDecoration(
                hintText: "Write message...",
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12
                ),
                border: InputBorder.none
            ),
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jarvis")
      ),
      body: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
            itemCount: responses.length,
            itemBuilder: (context, index) => buildListItem(context, index),
            reverse: true,
            separatorBuilder: (context, index) {
              return Container(
                height: 20,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 40,
              width: double.infinity,
              color: ThemeData.dark().cardColor,
              child: Row(
                children: buildTextField(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

