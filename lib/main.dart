import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String name = 'Guess The Number';
    return MaterialApp(
      title: name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightBlue[900],
      ),
      home: HomePage(title: name),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int numberOfTries = 0;
  int numberOfTimes = 5;

  final guessedNumber = new TextEditingController();

  static Random ran = new Random();
  int randomNumber = ran.nextInt(20) + 1;

  @override
  Widget build(BuildContext context) {
    var ulBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.pink),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'I\'m thinking of a number between 1 and 20. You only have 5 tries.',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.grey[800]),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Can you guess it?',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                      enabledBorder: ulBorder,
                      focusedBorder: ulBorder,
                      hintText: 'Please enter a number'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  controller: guessedNumber),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton(
                  child: new Text(
                    "Guess",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  color: Colors.lightBlue[900],
                  textColor: Colors.white,
                  onPressed: guess,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(12.0))),
            ),
          ],
        ),
      ),
    );
  }

  void guess() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (isEmpty()) {
      makeToast("You did not enter a number");
      return;
    }

    int guess = int.parse(guessedNumber.text);

    if (guess > 20 || guess < 1) {
      makeToast("Choose number between 1 and 20");
      guessedNumber.clear();
      return;
    }

    numberOfTries++;
    if (numberOfTries == numberOfTimes && guess != randomNumber) {
      makeToast(
          "Game Over! Your Number of Tries is: $numberOfTries My number is: $randomNumber");
      numberOfTries = 0;
      randomNumber = ran.nextInt(20) + 1;
      guessedNumber.clear();
      return;
    }

    if (guess > randomNumber) {
      makeToast("Lower! Number of Tries is: $numberOfTries");
    } else if (guess < randomNumber) {
      makeToast("Higher! Number of Tries is: $numberOfTries");
    } else {
      makeToast("That's right. You Win! Number of Tries is: $numberOfTries");
      numberOfTries = 0;
      randomNumber = ran.nextInt(20) + 1;
    }
    guessedNumber.clear();
  }

  void makeToast(String feedback) {
    Fluttertoast.showToast(
        msg: feedback,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14);
  }

  bool isEmpty() {
    return guessedNumber.text.isEmpty;
  }
}
