import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController emailControl, passwordControl;

  @override
  void initState() {
    emailControl = TextEditingController();
    passwordControl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailControl.dispose();
    passwordControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Column(
        children: [
          TextField(
            controller: emailControl,
            decoration: const InputDecoration(
              hintText: "Input email here",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10)
                ),
                borderSide: BorderSide(
                  color: Colors.green
                )
              )
            ),
          ),
          TextField(
            controller: passwordControl
          ),
          TextButton(
            onPressed: () async {
              final email = emailControl.text;
              final password = passwordControl.text;
            },
            child: const Text("Register")),
        ],
      ),
    );
  }
}

