import 'dart:convert';

import 'package:poliquiz_app/utils/httpService.dart';

class Apis {
  static const String baseURI = "https://api.poliquiz.it";
  HttpService httpService = HttpService(baseURI);


  Future<List<dynamic>> getCategories() async {
    Map<String, dynamic> response = await this.httpService.get("/courses");
    if(response['ok'] == true) {
      return response['data']['data'];
    }
    return [];
  }

  Future<List<dynamic>> getTest(int categoryID) async {
    Map<String, dynamic> response = await this.httpService.get("/course/$categoryID/quizzes");
    if(response['ok'] == true) {
      return response['data']['data'];
    }
    return [];
  }



  // --- Singleton
  static final Apis _instance = Apis._internal();
  factory Apis() => _instance;
  Apis._internal();
}