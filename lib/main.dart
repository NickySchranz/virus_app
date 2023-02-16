import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virus_game/blueScreen.dart';
import 'package:virus_game/buldingFrenzy.dart';
import 'package:virus_game/virusPopup.dart';
import 'package:window_manager/window_manager.dart';

import 'Position.dart';

void main() {
  if (Platform.isWindows) {
    WidgetsFlutterBinding.ensureInitialized();
    WindowManager.instance.setFullScreen(true);
    WindowManager.instance.setResizable(false);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final random = Random();

  List<Position> viruses = [];

  int milliSecondsBetweenEachVirus = 3000;

  int permitsIssued = 0;
  int permitsRevoked = 0;
  int highScore = 0;

  bool isFinished = false;
  bool isGameStarted = false;
  bool showBuildingFrenzy = false;
  bool showRecycleWindow = false;

  var windowCreateTimer = null;

  Position getNextPosition(width, height) {
    double windowWidth = 0.28 * width;
    double windowHeight = 0.16 * height;
    double x = random.nextDouble() * (width - windowWidth);
    double y = random.nextDouble() * (height - windowHeight - windowHeight);
    for (Position pos in viruses) {
      if (!((pos.x - x > windowWidth / 2 || x - pos.x > windowWidth / 2) ||
              (pos.y - y > windowHeight / 2 || y - pos.y > windowHeight / 2)) &&
          viruses.length < 15) {
        return getNextPosition(width, height);
      }
    }
    return Position(x: x, y: y);
  }

  void infect(double width, double height) {
    setState(() {
      showBuildingFrenzy = false;
      isGameStarted = true;
      permitsIssued++;
      viruses.add(getNextPosition(width, height));
    });
    AudioPlayer audioPlayer = AudioPlayer()
      ..setReleaseMode(ReleaseMode.release);
    audioPlayer.play(AssetSource('audio/PopUp.wav'));
    audioPlayer.dispose();
    Timer.periodic(const Duration(seconds: 4), ((timer) {
      if (viruses.length > 50) {
        timer.cancel();
        windowCreateTimer.cancel();
        setState(() {
          isFinished = true;
          milliSecondsBetweenEachVirus = 3000;
          highScore = permitsRevoked > highScore ? permitsRevoked : highScore;
          viruses.clear();
        });
      } else {
        setState(() {
          milliSecondsBetweenEachVirus = milliSecondsBetweenEachVirus == 200
              ? 200
              : milliSecondsBetweenEachVirus - 200;
        });

        if (windowCreateTimer != null) {
          windowCreateTimer.cancel();
        }
        Timer windowTimer = Timer.periodic(
            Duration(milliseconds: milliSecondsBetweenEachVirus),
            (timer) => setState(() {
                  AudioPlayer audioPlayer = AudioPlayer()
                    ..setReleaseMode(ReleaseMode.release);
                  permitsIssued++;
                  viruses.add(getNextPosition(width, height));
                  audioPlayer.play(AssetSource('audio/PopUp.wav'));
                  audioPlayer.dispose();
                }));
        setState(() {
          windowCreateTimer = windowTimer;
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: isFinished
            ? BlueScreen(
                permitsIssued: permitsIssued,
                highScore: highScore,
                currentScore: permitsRevoked,
                restart: () {
                  setState(() {
                    isFinished = false;
                    permitsRevoked = 0;
                    permitsIssued = 0;
                    isGameStarted = false;
                  });
                })
            : Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/xp_background.jpeg'),
                        fit: BoxFit.cover)),
                child: isFinished
                    ? Stack(
                        children: [],
                      )
                    : Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  border: const Border(
                                    top: BorderSide(
                                        color: Colors.white, width: 2),
                                  )),
                              width: fullWidth,
                              height: fullHeight * 0.04,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        border: const Border(
                                            top: BorderSide(
                                                color: Colors.white, width: 2),
                                            left: BorderSide(
                                                color: Colors.white, width: 2),
                                            right: BorderSide(
                                                color: Colors.black, width: 2),
                                            bottom: BorderSide(
                                                color: Colors.black,
                                                width: 2))),
                                    height: fullHeight * 0.03,
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 1,
                                        ),
                                        Image.asset(
                                          'assets/xp_taskbar.png',
                                          cacheHeight:
                                              (fullHeight * 0.15).floor(),
                                          cacheWidth: (fullWidth * 0.1).floor(),
                                        ),
                                        Text(
                                          'Start',
                                          style: GoogleFonts.getFont('VT323',
                                              color: Colors.black,
                                              fontSize: fullHeight * 0.02),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    margin: const EdgeInsets.only(left: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.grey.shade600,
                                                width: 2),
                                            left: BorderSide(
                                                color: Colors.grey.shade800,
                                                width: 2),
                                            right: BorderSide(
                                                color: Colors.grey.shade500,
                                                width: 1),
                                            bottom: BorderSide(
                                                color: Colors.grey.shade500,
                                                width: 1))),
                                    height: fullHeight * 0.03,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset(
                                          'assets/xp_time.png',
                                          cacheHeight:
                                              (fullHeight * 0.15).floor(),
                                          cacheWidth: (fullWidth * 0.1).floor(),
                                        ),
                                        const SizedBox(
                                          width: 1,
                                        ),
                                        Text(
                                          '12:52pm',
                                          style: GoogleFonts.getFont('VT323',
                                              color: Colors.black,
                                              fontSize: fullHeight * 0.015),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          isGameStarted
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Permits Revoked\n' +
                                          permitsRevoked.toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.getFont('VT323',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: fullHeight * 0.05),
                                    ),
                                    Text(
                                      'Permits Issued\n' +
                                          permitsIssued.toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.getFont('VT323',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: fullHeight * 0.05),
                                    ),
                                    Text(
                                      'High Score\n' + highScore.toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.getFont('VT323',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: fullHeight * 0.05),
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                          Positioned(
                              bottom: fullHeight * 0.08,
                              right: fullWidth * 0.03,
                              child: GestureDetector(
                                onDoubleTap: () {
                                  if (!(isGameStarted || showBuildingFrenzy)) {
                                    AudioPlayer ap = AudioPlayer()
                                      ..setReleaseMode(ReleaseMode.release);
                                    setState(() {
                                      showRecycleWindow = true;
                                    });
                                    ap.play(
                                        AssetSource('audio/CloseWindow.wav'));
                                    ap.dispose();
                                  }
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/xp_bin.png',
                                      cacheHeight: (fullHeight * 0.1).floor(),
                                      cacheWidth: (fullWidth * 0.05).floor(),
                                    ),
                                    Text(
                                      'Recycle',
                                      style: GoogleFonts.getFont('VT323',
                                          color: Colors.white,
                                          fontSize: fullHeight * 0.02),
                                    ),
                                  ],
                                ),
                              )),
                          Positioned(
                            bottom: fullHeight * 0.24,
                            right: fullWidth * 0.03,
                            child: GestureDetector(
                              onDoubleTap: () {
                                if (!isGameStarted) {
                                  AudioPlayer aP = AudioPlayer()
                                    ..setReleaseMode(ReleaseMode.release);
                                  aP.play(AssetSource('audio/CloseWindow.wav'));
                                  aP.dispose();
                                  setState(() {
                                    showBuildingFrenzy = true;
                                    showRecycleWindow = false;
                                  });
                                }
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/hard_hat.png',
                                    cacheHeight: (fullHeight * 0.1).floor(),
                                    cacheWidth: (fullWidth * 0.05).floor(),
                                  ),
                                  Text(
                                    'Building\nFrenzy',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.getFont('VT323',
                                        color: Colors.white,
                                        fontSize: fullHeight * 0.02),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          showBuildingFrenzy
                              ? Center(
                                  child: BuildingFrenzy(
                                  infect: infect,
                                ))
                              : SizedBox.shrink(),
                          ...viruses.asMap().entries.map((item) {
                            Position virus = item.value;
                            int index = item.key;
                            AudioPlayer audioPlayer = AudioPlayer()
                              ..setReleaseMode(ReleaseMode.release);

                            return VirusPopup(
                                buttonText: 'Revoke',
                                image: 'assets/xp_permit.png',
                                text:
                                    'The Planning Authority has issued a new building permit. Do you approve it?',
                                position: virus,
                                closeWindow: () {
                                  setState(() {
                                    permitsRevoked++;
                                    audioPlayer.play(
                                        AssetSource('audio/CloseWindow.wav'));
                                    viruses.removeAt(index);
                                    audioPlayer.dispose();
                                  });
                                },
                                bringToFront: () {
                                  setState(() {
                                    Position currentPosition =
                                        viruses.removeAt(index);
                                    viruses.add(currentPosition);
                                  });
                                });
                          }),
                          showRecycleWindow
                              ? VirusPopup(
                                  buttonText: 'OK',
                                  position: Position(
                                      x: fullWidth - fullWidth * 0.4,
                                      y: fullHeight - fullHeight * 0.76),
                                  closeWindow: () {
                                    AudioPlayer ap = AudioPlayer()
                                      ..setReleaseMode(ReleaseMode.release);
                                    setState(() {
                                      showRecycleWindow = false;
                                    });
                                    ap.play(
                                        AssetSource('audio/CloseWindow.wav'));
                                    ap.dispose();
                                  },
                                  bringToFront: () {},
                                  image: 'assets/xp_error.png',
                                  text:
                                      'Nice Try!!\nThere are no recycling plants in your country.')
                              : SizedBox.shrink()
                        ],
                      )),
      ),
    );
  }
}
