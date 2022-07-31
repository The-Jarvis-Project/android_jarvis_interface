import 'dart:ui';

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
  List<String> responses = <String>["a", "b", "c", "c", "c", "c", "c", "c", "c",
    "c", "c", "c", "c", "c", "a", "b", "c", "a", "b", "c"];

  @override
  void initState() {
    textFieldControl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textFieldControl.dispose();
    super.dispose();
  }

  Future getProjectDetails() async {
    var result = await http.get(Uri.parse('https://getProjectList'));
    return result;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jarvis")
      ),
      body: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
            itemCount: responses.length,
            itemBuilder: (context, index) => buildListItem(context, index),
            separatorBuilder: (context, index) {
              return Container(
                height: 20,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 50,
              width: double.infinity,
              color: ThemeData.dark().cardColor,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textFieldControl,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12
                        ),
                        border: InputBorder.none
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

