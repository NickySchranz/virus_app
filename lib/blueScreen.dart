import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlueScreen extends StatelessWidget {
  final Function restart;
  final int currentScore;
  final int highScore;
  final int permitsIssued;
  BlueScreen(
      {super.key,
      required this.restart,
      required this.currentScore,
      required this.highScore,
      required this.permitsIssued});

  final AudioPlayer _audioPlayer = AudioPlayer()
    ..setReleaseMode(ReleaseMode.loop);

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;

    _audioPlayer.play(AssetSource('audio/BlueScreenLoop.wav'));

    return GestureDetector(
      onTap: () {
        _audioPlayer.stop();
        restart();
      },
      child: Container(
        color: Color.fromARGB(255, 6, 29, 179),
        width: fullWidth,
        height: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Permits Revoked\n' + currentScore.toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont('VT323',
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontSize: fullHeight * 0.05),
                ),
                Text(
                  'Permits Issued\n' + permitsIssued.toString(),
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
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: fullWidth * 0.25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'You have failed!!',
                        style: GoogleFonts.getFont('VT323',
                            backgroundColor: Colors.grey.shade400,
                            color: Color.fromARGB(255, 6, 29, 179),
                            fontSize: fullHeight * 0.04),
                      ),
                    ),
                    Text(
                      'Your heritage and environment are pretty much f***ed!!!',
                      style: GoogleFonts.getFont('VT323',
                          color: Colors.grey.shade300,
                          fontSize: fullHeight * 0.025),
                    ),
                    Text(
                      'An error has occurred. To continue:',
                      style: GoogleFonts.getFont('VT323',
                          color: Colors.grey.shade300,
                          fontSize: fullHeight * 0.025),
                    ),
                    Text(
                      'Keep voting into a bi-partisan system,\ncontrolled and funded by construction tycoons.',
                      style: GoogleFonts.getFont('VT323',
                          color: Colors.grey.shade300,
                          fontSize: fullHeight * 0.025),
                    ),
                    Text(
                      'Keep believing that only your political party presents the whole truth.',
                      style: GoogleFonts.getFont('VT323',
                          color: Colors.grey.shade300,
                          fontSize: fullHeight * 0.025),
                    ),
                   
                    SizedBox(
                      height: fullHeight * 0.01,
                    ),
                    Center(
                      child: Text(
                        "Press any key to continue _",
                        style: GoogleFonts.getFont('VT323',
                            color: Colors.grey.shade300,
                            fontSize: fullHeight * 0.06),
                      ),
                    ),
                    RawKeyboardListener(
                      focusNode: focusNode,
                      child: SizedBox(
                        height: fullHeight * 0.05,
                      ),
                      autofocus: true,
                      onKey: (value) {
                        _audioPlayer.stop();
                        restart();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
