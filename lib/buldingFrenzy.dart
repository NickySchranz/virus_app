import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virus_game/startWindow.dart';

class BuildingFrenzy extends StatefulWidget {
  final Function infect;
  const BuildingFrenzy({super.key, required this.infect});

  @override
  State<BuildingFrenzy> createState() => _BuildingFrenzyState();
}

class StartWindowProp {
  String text;
  String image;

  StartWindowProp({required this.image, required this.text});
}

class _BuildingFrenzyState extends State<BuildingFrenzy> {
  List<StartWindowProp> startWindows = [
    StartWindowProp(
        image: "assets/xp_loading.png",
        text:
            "Is it physically possible to review the permits and the safety of the construction sites?"),
    StartWindowProp(
        image: "assets/xp_caution.png",
        text: "The Planning Authority issues around 12,000 permits per year"),
    StartWindowProp(
        image: "assets/skull.png",
        text:
            "Since 2011, in construction, there have been:\n15,000 injuries\n65 deaths"),
  ];

  // List<String> startWindows = [
  //   'Since 2011, in construction, there have been:\n15,000 injuries\n65 deaths',
  //   'Is it physically possible to review the permits and the safety of the construction sites?',
  //   'The Planning Authority issues around 12,000 permits per year'
  // ];

  bool showStartWindows = false;

  AudioPlayer _audioPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.loop);

  @override
  void initState() {
    _audioPlayer.play(AssetSource('audio/GameLoadScreen.wav'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (!showStartWindows) {
          AudioPlayer audioPlayer = AudioPlayer()
            ..setReleaseMode(ReleaseMode.release);
          audioPlayer.play(AssetSource('audio/CloseWindow.wav'));
          audioPlayer.dispose();
          setState(() {
            showStartWindows = true;
          });
        }
      },
      child: Container(
          alignment: Alignment.center,
          width: fullWidth * 0.65,
          height: fullHeight * 0.65,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 4),
              image: DecorationImage(
                  image: AssetImage('assets/building_frenzy.gif'),
                  fit: BoxFit.fill)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              showStartWindows
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        ...startWindows.asMap().entries.map((item) {
                          AudioPlayer audioPlayer = AudioPlayer()
                            ..setReleaseMode(ReleaseMode.release);

                          return Center(
                            child: StartWindow(
                                image: item.value.image,
                                text: item.value.text,
                                closeWindow: () {
                                  setState(() {
                                    audioPlayer.play(
                                        AssetSource('audio/CloseWindow.wav'));
                                    audioPlayer.dispose();
                                    setState(() {
                                      if (item.key == 0) {
                                        // infect(fullWidth, fullHeight);
                                      }
                                      startWindows.removeAt(item.key);
                                    });
                                  });
                                },
                                bringToFront: () {
                                  setState(() {
                                    startWindows.removeAt(item.key);
                                    startWindows.add(item.value);
                                  });
                                }),
                          );
                        }),
                        startWindows.isEmpty
                            ? GestureDetector(
                                onTap: () {
                                  AudioPlayer audioPlayer = AudioPlayer()
                                    ..setReleaseMode(ReleaseMode.release);

                                  audioPlayer.play(
                                      AssetSource('audio/CloseWindow.wav'));
                                  audioPlayer.dispose();
                                  setState(() {
                                    _audioPlayer.stop();
                                    _audioPlayer.dispose();
                                    widget.infect(fullWidth, fullHeight);
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: fullHeight * 0.05),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: fullWidth * 0.1,
                                      vertical: fullHeight * 0.03),
                                  decoration: BoxDecoration(
                                      color: Colors.yellow.shade300),
                                  child: Text(
                                    'START',
                                    style: GoogleFonts.getFont('VT323',
                                        color: Colors.black,
                                        fontSize: fullHeight * 0.12),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        AudioPlayer audioPlayer = AudioPlayer()
                          ..setReleaseMode(ReleaseMode.release);
                        audioPlayer.play(AssetSource('audio/CloseWindow.wav'));
                        audioPlayer.dispose();
                        setState(() {
                          showStartWindows = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: fullWidth * 0.1,
                            vertical: fullHeight * 0.01),
                        child: Text(
                          'CLICK TO START',
                          style: GoogleFonts.getFont('VT323',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: fullHeight * 0.08),
                        ),
                      ),
                    )
            ],
          )),
    );
  }
}
