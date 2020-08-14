import 'package:dio/dio.dart';
import 'package:triviagame/services/categories.dart';
import 'dart:async';
import 'package:triviagame/services/quiz.dart';
import '../components/internet_connection.dart';

class NetworkHelper {
  final String url;
  Response response;
  Dio dio = new Dio();
  List<Quiz> quizList = [];
  List<Categories> categoriesList = [];

  NetworkHelper(this.url);

  Future getData(String requestType) async {
    try {
      response = await dio.get(url);

      if (response.statusCode == 200) {
        if (requestType == 'categories') {
          var data = response.data;
          var rest = data['trivia_categories'] as List;
          categoriesList = rest
              .map<Categories>((json) => Categories.fromJson(json))
              .toList();
          return categoriesList;
        } else {
          var data = response.data;
          var rest = data['results'] as List;
          quizList = rest.map<Quiz>((json) => Quiz.fromJson(json)).toList();
          return quizList;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
