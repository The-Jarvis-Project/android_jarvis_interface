import 'dart:convert';

import 'package:android_jarvis_interface/jarvis_request.dart';
import 'package:android_jarvis_interface/jarvis_response.dart';
import 'package:android_jarvis_interface/text_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: 'Jarvis Interface',
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
  bool canSend = true;

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
          'https://jarvislinker.azurewebsites.net/api/JarvisRequests'));
      var responseResult = await http.get(Uri.parse(
          'https://jarvislinker.azurewebsites.net/api/JarvisResponses'));
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
        textBubbles.insert(0, TextBubble(newRequests[i].id ?? -1,
            false, newRequests[i].request ?? '<Null>'));
      }
      for (var i = 0; i < textBubbles.length; i++) {
        for (var r = 0; r < newResponses.length; r++) {
          if (newResponses[r].requestId == textBubbles[i].requestId) {
            textBubbles.insert(i + 1, TextBubble(-1,
                true, newResponses[r].data ?? '<Null>'));
            i++;
            break;
          }
        }
      }

      setState(() {
        bubbles = textBubbles;
      });
      await Future.delayed(const Duration(milliseconds: 1250));
    }
  }
  
  void onPressSendButton(String text) async {
    if (canSend) {
      canSend = false;
      JarvisRequestDTO dto = JarvisRequestDTO(text);
      String json = jsonEncode(dto);
      await http.post(Uri.parse(
          'https://jarvislinker.azurewebsites.net/api/JarvisRequests'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json,
      );
      linkerPingLoop();
      canSend = true;
    }
  }

  Widget buildChatBubble(int index) {
    bool isResponse = bubbles[index].isResponse;
    return Align(
      alignment: isResponse ? Alignment.centerLeft : Alignment.centerRight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isResponse ? Colors.grey : Colors.indigo,
          gradient: isResponse ? const LinearGradient(
            colors: [Colors.white24, Colors.white24],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ) : const LinearGradient(
            colors: [Colors.indigo, Colors.indigoAccent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
            topLeft: isResponse ? Radius.zero : const Radius.circular(16),
            topRight: isResponse ? const Radius.circular(16) : Radius.zero,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            bubbles[index].message,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: isResponse ? Colors.white : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildTextField() {
    return [
      const SizedBox(width: 5),
      Expanded(
        child: SizedBox(
          height: 40,
          child: TextField(
            controller: textFieldControl,
            cursorColor: Colors.white,
            keyboardAppearance: Brightness.dark,
            onSubmitted: (value) => onPressSendButton(value),
            style: const TextStyle(
              fontSize: 16,
            ),
            decoration: const InputDecoration(
                hintText: 'Write message...',
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16
                ),
                border: InputBorder.none
            ),
          ),
        ),
      ),
      const SizedBox(width: 5),
      SizedBox(
        height: 35,
        width: 35,
        child: FloatingActionButton(
          onPressed: () => onPressSendButton(textFieldControl.text),
          backgroundColor: Colors.indigo,
          child: const Icon(Icons.send, color: Colors.white, size: 20),
        ),
      ),
      const SizedBox(width: 5),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jarvis')
      ),
      body: Stack(
        children: [
          ListView.separated(
            itemCount: bubbles.length,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) => buildChatBubble(index),
            separatorBuilder: (_, i) => Container(
              height: 10,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 50,
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

