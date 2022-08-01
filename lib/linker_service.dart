import 'dart:convert';

import 'package:android_jarvis_interface/jarvis_request.dart';
import 'package:android_jarvis_interface/jarvis_response.dart';
import 'package:http/http.dart' as http;

class Linker {
  static Future<List<JarvisRequest>> getRequests() async {
    var requestResult = await http.get(Uri.parse(
        'https://jarvislinker.azurewebsites.net/api/JarvisRequests'));
    List<dynamic> requestList = jsonDecode(requestResult.body);
    List<JarvisRequest> newRequests = <JarvisRequest>[];
    for (var i = 0; i < requestList.length; i++) {
      newRequests.add(JarvisRequest.fromJson(requestList[i]));
    }
    return newRequests;
  }

  static Future<List<JarvisResponse>> getResponses() async {
    var responseResult = await http.get(Uri.parse(
        'https://jarvislinker.azurewebsites.net/api/JarvisResponses'));
    List<dynamic> responseList = jsonDecode(responseResult.body);
    List<JarvisResponse> newResponses = <JarvisResponse>[];
    for (var i = 0; i < responseList.length; i++) {
      newResponses.add(JarvisResponse.fromJson(responseList[i]));
    }
    return newResponses;
  }

  static Future<void> sendRequest(String request) async {
    JarvisRequestDTO dto = JarvisRequestDTO(request);
    String json = jsonEncode(dto);
    await http.post(Uri.parse(
        'https://jarvislinker.azurewebsites.net/api/JarvisRequests'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );
  }
}