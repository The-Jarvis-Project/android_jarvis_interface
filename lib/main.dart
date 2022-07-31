import 'dart:convert';

import 'package:android_jarvis_interface/jarvis_request.dart';
import 'package:android_jarvis_interface/jarvis_response.dart';
import 'package:android_jarvis_interface/text_bubble.dart';
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
  late final TextEditingController textFieldControl;
  List<TextBubble> bubbles = <TextBubble>[];

  @override
  void initState() {
    textFieldControl = TextEditingController();
    linkerPingLoop();
    super.initState();
  }

  @override
  void dispose() {
    textFieldControl.dispose();
    super.dispose();
  }

  void linkerPingLoop() async {
    while (true) {
      var requestResult = await http.get(Uri.parse(
          'https://jarvislinker.azurewebsites.net/api/JarvisRequests/'));
      var responseResult = await http.get(Uri.parse(
          'https://jarvislinker.azurewebsites.net/api/JarvisResponses/'));
      List<dynamic> requestList = jsonDecode(requestResult.body),
          responseList = jsonDecode(responseResult.body);

      List<JarvisRequest> newRequests = <JarvisRequest>[];
      List<JarvisResponse> newResponses = <JarvisResponse>[];
      for (var i = 0; i < requestList.length; i++) {
        newRequests.add(JarvisRequest.fromJson(requestList[i]));
      }
      for (var i = 0; i < responseList.length; i++) {
        newResponses.add(JarvisResponse.fromJson(responseList[i]));
      }

      List<TextBubble> textBubbles = <TextBubble>[];
      for (var i = 0; i < newRequests.length; i++) {
        textBubbles.add(TextBubble(newRequests[i].id ?? -1,
            false, newRequests[i].request ?? "<Null>"));
      }
      for (var i = 0; i < textBubbles.length; i++) {
        for (var r = 0; r < newResponses.length; r++) {
          if (newResponses[r].requestId == textBubbles[i].requestId) {
            textBubbles.insert(i + 1, TextBubble(-1,
                true, newResponses[r].data ?? "<Null>"));
            i++;
            break;
          }
        }
      }

      setState(() {
        bubbles = textBubbles;
      });
      await Future.delayed(const Duration(seconds: 2));
    }
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
        child: Text(bubbles[index].message, style: const TextStyle(
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
            itemCount: bubbles.length,
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

