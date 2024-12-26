import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(DinasTimer());
}

class DinasTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? timer;
  int remainingSeconds = 0;
  int initialTime = 0;
  bool isRunning = false;
  String buttonText = "Start";

  void toggleTimer() {
    if (isRunning) {
      stopTimer();
    } else {
      startTimer();
    }
  }

  void startTimer() {
    setState(() {
      buttonText = "Stop";
      isRunning = true;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        stopTimer();
        _showCompletionDialog();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      buttonText = "Start";
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Time\'s up!'),
          content: Text('Great job! Your session is complete.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  remainingSeconds = 0;
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void selectTime(int seconds) {
    stopTimer();
    setState(() {
      remainingSeconds = seconds;
      initialTime = seconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dina\'s Timer',
          style: TextStyle(fontFamily: 'Lobster', fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$minutes:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.purpleAccent,
              ),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: remainingSeconds == 0 ? 0 : remainingSeconds / initialTime,
              minHeight: 10,
              backgroundColor: Colors.purple[100],
              color: Colors.pinkAccent,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _timeButton('1 min', 60),
                SizedBox(width: 10),
                _timeButton('5 min', 300),
                SizedBox(width: 10),
                _timeButton('10 min', 600),
                SizedBox(width: 10),
                _timeButton('25 min', 1500),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: toggleTimer,
              child: Text(buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: isRunning ? Colors.redAccent : Colors.greenAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton _timeButton(String label, int timeInSeconds) {
    return ElevatedButton(
      onPressed: () => selectTime(timeInSeconds),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
