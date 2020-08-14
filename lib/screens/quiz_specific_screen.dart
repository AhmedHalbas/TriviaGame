import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:triviagame/components/rounded_button.dart';
import 'package:triviagame/services/quiz.dart';
import '../services/networking.dart';
import '../components/alert_dialog.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:triviagame/components/reusable_card.dart';
import '../utilities/constants.dart';
import '../components/internet_connection.dart';

class SpecificScreen extends StatefulWidget {
  String selectedDifficulty, selectedType;
  int selectedCategory, selectedAmount;
  SpecificScreen(
      {this.selectedAmount,
      this.selectedCategory,
      this.selectedDifficulty,
      this.selectedType});
  @override
  _SpecificScreenState createState() => _SpecificScreenState();
}

class _SpecificScreenState extends State<SpecificScreen> {
  bool showSpinner = false;
  List<Quiz> questions = [];
  int questionsCounter = 0;
  Future<List<Quiz>> _future;
  final List<String> allAnswers = [];
  String selectedAnswer;
  int userCounter = 0;

  void mergeAnswers(int index) {
    allAnswers.add(questions[index]
        .correctAnswer
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', '\'')
        .replaceAll('&lrm;', '')
        .replaceAll('&shy;', '')
        .replaceAll('&oacute;', 'ó'));
    for (int i = 0; i < questions[index].wrongAnswers.length; i++) {
      allAnswers.add(questions[index]
          .wrongAnswers[i]
          .replaceAll('&quot;', '"')
          .replaceAll('&#039;', '\'')
          .replaceAll('&lrm;', '')
          .replaceAll('&shy;', '')
          .replaceAll('&oacute;', 'ó'));
    }

    allAnswers..shuffle();
  }

  void getResult(String selectedAnswer, int index) {
    if (selectedAnswer == questions[index].correctAnswer) {
      userCounter++;
    }
  }

  Future<List<Quiz>> getData() async {
    setState(() {
      showSpinner = true;
    });

    questions = await NetworkHelper(
            'https://opentdb.com/api.php?amount=${widget.selectedAmount}&category=${widget.selectedCategory}&difficulty=${widget.selectedDifficulty}&type=${widget.selectedType}')
        .getData('trivia');

    //checkInternet(context, questions);
    checkJSON(context, questions);

    setState(() {
      showSpinner = false;
    });

    if (questions.isNotEmpty) {
      return questions;
    }
  }

  @override
  void initState() {
    super.initState();
    _future = getData();
  }

  @override
  Widget build(BuildContext context) {
    allAnswers.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text('Trivia Quiz'),
      ),
      body: quizBuilder(),
    );
  }

  FutureBuilder<List<Quiz>> quizBuilder() {
    return FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data != null && questions != null) {
            mergeAnswers(questionsCounter);
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: ReusableCard(
                      colour: Colors.blue,
                      cardChild: Text(
                        questions[questionsCounter]
                            .question
                            .replaceAll('&quot;', '"')
                            .replaceAll('&#039;', '\'')
                            .replaceAll('&lrm;', '')
                            .replaceAll('&shy;', '')
                            .replaceAll('&oacute;', 'ó'),
                        style: kLabelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allAnswers.length,
                      itemBuilder: (context, i) {
                        return RadioListTile<String>(
                          title: Text(
                            allAnswers[i],
                            style: kLabelTextStyle,
                          ),
                          value: allAnswers[i],
                          groupValue: selectedAnswer,
                          onChanged: (value) {
                            setState(() {
                              selectedAnswer = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Flexible(
                    child: RoundedButton(
                      color: Colors.blue,
                      title: 'Next',
                      onPressed: () {
                        if (selectedAnswer == null) {
                          return showAlertDialog(
                            context,
                            isDismissible: false,
                            title: 'Something is Missing',
                            content: 'Please Answer The Question',
                            buttonText: 'Ok',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          );
                        }
                        getResult(selectedAnswer, questionsCounter);
                        if (questionsCounter < questions.length - 1) {
                          setState(() {
                            questionsCounter++;
                            selectedAnswer = null;
                          });
                        } else {
                          showAlertDialog(
                            context,
                            isDismissible: false,
                            title: 'You Finished The Quiz',
                            content:
                                'you get $userCounter/${widget.selectedAmount},Go Take Another Quiz?',
                            buttonText: 'Ok',
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Text(' '),
            );
          }
        });
  }
}
