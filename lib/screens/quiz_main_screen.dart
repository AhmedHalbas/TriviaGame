import 'package:flutter/material.dart';
import 'package:triviagame/screens/quiz_specific_screen.dart';
import '../utilities/constants.dart';
import '../components/rounded_button.dart';
import '../services/categories.dart';
import '../components/alert_dialog.dart';

class MainScreen extends StatefulWidget {
  List<Categories> categories = [];
  MainScreen({this.categories});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String selectedAmount, selectedCategory, selectedDifficulty, selectedType;

  int numberOfQuestions = 0, selectedCategoryID = 0;

  DropdownButton amountDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (int amount in amountList) {
      var newItem = DropdownMenuItem(
        child: Container(
          alignment: Alignment.center,
          child: Text(amount.toString()),
        ),
        value: amount.toString(),
      );

      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      isExpanded: true,
      hint: Center(child: Text('Choose Number of Questions')),
      iconSize: 40,
      value: selectedAmount != null ? selectedAmount : null,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedAmount = value;
          numberOfQuestions = int.parse(value);
        });
      },
    );
  }

  DropdownButton categoriesDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (int i = 0; i < widget.categories.length; i++) {
      var newItem = DropdownMenuItem(
        child: Container(
          alignment: Alignment.center,
          child: Text(widget.categories[i].categoryName),
        ),
        value: widget.categories[i].categoryName,
      );

      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      isExpanded: true,
      hint: Center(child: Text('Choose Category of Questions')),
      iconSize: 40,
      value: selectedCategory != null ? selectedCategory : null,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCategory = value;

          for (int i = 0; i < widget.categories.length; i++) {
            if (widget.categories[i].categoryName == selectedCategory) {
              selectedCategoryID = widget.categories[i].categoryID;
            }
          }
        });
      },
    );
  }

  DropdownButton difficultyDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String difficulty in difficultyList) {
      var newItem = DropdownMenuItem(
        child: Container(
          alignment: Alignment.center,
          child: Text(difficulty),
        ),
        value: difficulty,
      );

      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      isExpanded: true,
      hint: Center(child: Text('Choose Difficulty of Questions')),
      iconSize: 40,
      value: selectedDifficulty != null ? selectedDifficulty : null,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedDifficulty = value;
        });
      },
    );
  }

  DropdownButton typeDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String type in typeList) {
      var newItem = DropdownMenuItem(
        child: Container(
          alignment: Alignment.center,
          child: Text(type),
        ),
        value: type,
      );

      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      isExpanded: true,
      hint: Center(child: Text('Choose Type of Questions')),
      iconSize: 40,
      value: selectedType != null ? selectedType : null,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedType = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trivia Preferences'),
      ),
      body: quizPreferencesBuilder(context),
    );
  }

  Center quizPreferencesBuilder(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: amountDropDown()),
          Expanded(child: categoriesDropDown()),
          Expanded(child: difficultyDropDown()),
          Expanded(child: typeDropDown()),
          Flexible(
            child: RoundedButton(
              color: Colors.blue,
              title: 'Enter Trivia',
              onPressed: () {
                if (selectedAmount == null ||
                    selectedCategory == null ||
                    selectedDifficulty == null ||
                    selectedType == null) {
                  return showAlertDialog(
                    context,
                    isDismissible: false,
                    title: 'Something is Missing',
                    content: 'Please Choose All Preferences of The Quiz',
                    buttonText: 'Ok',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpecificScreen(
                        selectedAmount: numberOfQuestions,
                        selectedCategory: selectedCategoryID,
                        selectedDifficulty:
                            '${selectedDifficulty[0].toLowerCase()}${selectedDifficulty.substring(1)}',
                        selectedType: selectedType == typeList[0]
                            ? 'multiple'
                            : 'boolean',
                      ),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
