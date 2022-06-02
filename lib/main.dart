import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF393E46),
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                "WELCOME TO ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: 'Bangers',
                ),
              ),
              Text(
                "ROLL IT!",
                style: TextStyle(
                  color: Color(0xFFf9d92f),
                  fontSize: 30.0,
                  fontFamily: 'Bangers',
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFF393E46),
        ),
        body: DicePage(),
      ),
    ),
  );
}

class DicePage extends StatefulWidget {
  const DicePage({Key? key}) : super(key: key);

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int leftDiceNumber = 1;
  int rightDiceNumber = 1;
  int userScore = 0;
  int computerScore = 0;
  String winner = "";
  bool isButtonActive = true;
  bool isReset = false;

  Future restartApp() async {
    await Future.delayed(Duration(microseconds: 400));
    setState(() {
      DicePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    const textColors = [
      Color(0xFFf9d92f),
      Color(0xFFfa20ce),
      Color(0xFF04acfa)
    ];

    const colorizeTextStyle =
        TextStyle(fontSize: 30.0, fontFamily: 'IndieFlower');

    // Random Dice Generator Function
    void randomDice() {
      leftDiceNumber = Random().nextInt(6) + 1;
      rightDiceNumber = Random().nextInt(6) + 1;

      userScore += leftDiceNumber;
      computerScore += rightDiceNumber;

      if (leftDiceNumber > rightDiceNumber) {
        winner = ('👇 YOU WIN!');
      } else if (leftDiceNumber < rightDiceNumber) {
        winner = 'COMPUTER WINS 👇';
      } else {
        winner = 'Draw 🙄';
      }
    }

    if (userScore > 90) {
      isReset = true;
      isButtonActive = false;
      winner = "You Won 🏆";
      userScore = 0;
      computerScore = 0;
    } else if (computerScore > 90) {
      isReset = true;
      isButtonActive = false;
      winner = "You Lose 💔";
      userScore = 0;
      computerScore = 0;
    } else {
      isButtonActive = true;
      isReset = false;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 14.0),
            child: AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText("WINNER IS 90+",
                    textStyle: colorizeTextStyle, colors: textColors),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 35.0, top: 18.0),
            child: Text(
              winner,
              style: TextStyle(
                color: Color(0xFFF9D92F),
                fontSize: 55.0,
                fontFamily: 'Bangers',
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 78.0),
                  child: Text(
                    "You",
                    style: TextStyle(
                      color: Color(0xFFfa20ce),
                      fontSize: 32.0,
                      fontFamily: 'IndieFlower',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 42.0),
                  child: Text(
                    "Computer",
                    style: TextStyle(
                      color: Color(0xFF04acfa),
                      fontSize: 32.0,
                      fontFamily: 'IndieFlower',
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 94.0, top: 10.0),
                  child: Text(
                    userScore.toString(),
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Color(0xFFfa20ce),
                      fontFamily: 'Bangers',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 98.0, top: 10.0),
                  child: Text(
                    computerScore.toString(),
                    style: TextStyle(
                      color: Color(0xFF04acfa),
                      fontSize: 24.0,
                      fontFamily: 'Bangers',
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('images/dice$leftDiceNumber.png'),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('images/dice$rightDiceNumber.png'),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 30.0, bottom: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFF9D92F),
                      onPrimary: Color.fromARGB(255, 183, 158, 35),
                      shadowColor: Color(0xFF00000040),
                      elevation: 3,
                      onSurface: Color.fromARGB(255, 66, 71, 79),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: Size(113.0, 51.5),
                    ),
                    onPressed: isButtonActive
                        ? () {
                            final player = AudioCache();
                            player.play('dice.mp3');
                            setState(() {
                              randomDice();
                            });
                          }
                        : null,
                    child: Text(
                      "Roll It!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Bangers',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                color: Color(0xFFF9D92F),
                onPressed: isReset
                    ? () {
                        restartApp();
                      }
                    : null,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 56.0, bottom: 6.0),
                child: Text(
                  "Made with ❤️ by ",
                  style: TextStyle(
                    color: Color.fromARGB(139, 255, 255, 255),
                    fontSize: 16.0,
                    fontFamily: 'IndieFlower',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 56.0, bottom: 6.0),
                child: new InkWell(
                  child: new Text(
                    "Halim Shams",
                    style: TextStyle(
                      color: Color.fromARGB(175, 255, 255, 255),
                      fontFamily: 'IndieFlower',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    launch('https://twitter.com/HalimOFFI');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
