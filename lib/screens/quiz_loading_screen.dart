import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:triviagame/screens/quiz_main_screen.dart';
import 'package:triviagame/services/categories.dart';
import 'package:triviagame/services/quiz.dart';
import '../components/internet_connection.dart';
import '../services/networking.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<Categories> categories = [];
  String APIURL = 'https://opentdb.com/api_category.php';
  List<String> categoriesNames = [];
  List<int> categoriesIDs = [];

  void getCategories() async {
    categories = await NetworkHelper(APIURL).getData('categories');

    checkInternet(context, categories);

    if (categories.isNotEmpty) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return MainScreen(
          categories: categories,
        );
      }), (_) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitSquareCircle(
          color: Colors.blue,
          size: 80,
        ),
      ),
    );
  }
}
