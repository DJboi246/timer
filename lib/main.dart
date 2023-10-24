import 'package:flutter/material.dart';
import 'package:dp_stopwatch/dp_stopwatch.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TimerApp());
  }
}

class TimerApp extends StatefulWidget {
  const TimerApp({super.key});

  @override
  State<TimerApp> createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  int bottomnavigationindex = 0;
  final stopwatchViewModel = DPStopwatchViewModel(
    clockTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 32,
    ),
  );
  int timerduration = 0;
  final circlecountdowncontroller = CountDownController();
  int duration = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.timer), label: "Stopwatch"),
            BottomNavigationBarItem(icon: Icon(Icons.timelapse), label: "Timer")
          ],
          currentIndex: bottomnavigationindex,
          onTap: (value) {
            setState(() {
              bottomnavigationindex = value;
            });
          },
        ),
        body: Container(
          alignment: Alignment.center,
          child: bottomnavigationindex == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DPStopWatchWidget(
                      stopwatchViewModel,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              stopwatchViewModel.start?.call();
                              stopwatchViewModel.resume?.call();
                            },
                            child: Text("Start")),
                        TextButton(
                            onPressed: () {
                              stopwatchViewModel.pause?.call();
                            },
                            child: Text("Stop")),
                        TextButton(
                            onPressed: () {
                              stopwatchViewModel.stop?.call();
                            },
                            child: Text("Restart"))
                      ],
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularCountDownTimer(
                      controller: circlecountdowncontroller,
                      isReverse: true,
                      isReverseAnimation: true,
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      duration: timerduration,
                      fillColor: Colors.blue,
                      ringColor: Colors.white,
                      autoStart: false,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text("Start"),
                          onPressed: () {
                            circlecountdowncontroller.resume();
                          },
                        ),
                        TextButton(
                          child: Text("Stop"),
                          onPressed: () {
                            circlecountdowncontroller.pause();
                          },
                        ),
                        TextButton(
                          child: Text("Restart"),
                          onPressed: () {
                            circlecountdowncontroller.restart(
                                duration: duration);
                            circlecountdowncontroller.pause();
                          },
                        ),
                        TextButton(
                          child: Text("New Timer"),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("New Timer"),
                                  content: Column(children: [
                                    Text("How long should the timer be:"),
                                    TimePickerSpinner(
                                      time: DateTime(1, 1, 1, 0, 0, 0, 0, 0),
                                      isForce2Digits: true,
                                      isShowSeconds: true,
                                      onTimeChange: (p0) {
                                        duration = p0.second.ceil() +
                                            p0.minute.ceil() * 60 +
                                            p0.hour.ceil() * 3600;
                                      },
                                    )
                                  ]),
                                  actions: [
                                    TextButton(
                                        onPressed: (() {
                                          circlecountdowncontroller.restart(
                                              duration: duration);
                                          circlecountdowncontroller.pause();
                                          Navigator.of(context).pop();
                                        }),
                                        child: Text("Ok"))
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
        ));
  }
}
