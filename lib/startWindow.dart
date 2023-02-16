import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virus_game/Position.dart';
import 'package:virus_game/xpButton.dart';
import 'package:virus_game/xpTopbar.dart';

class StartWindow extends StatelessWidget {
  final Function closeWindow;
  final Function bringToFront;
  final String image;
  final String text;

  const StartWindow(
      {super.key,
      required this.closeWindow,
      required this.bringToFront,
      required this.image,
      required this.text});

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: fullHeight * 0.2),
      child: GestureDetector(
        onTap: () {
          bringToFront();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow.shade300,
          ),
          width: 0.28 * fullWidth,
          height: 0.16 * fullHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: fullWidth * 0.01, vertical: fullHeight * 0.01),
                child: Text(
                  'Planning Authority Malta',
                  style: GoogleFonts.getFont('VT323',
                      color: Colors.blue.shade900, fontSize: fullHeight * 0.02),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      image,
                      cacheHeight: (fullHeight * 0.15).floor(),
                      cacheWidth: (fullWidth * 0.17).floor(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.getFont('VT323',
                            color: Colors.black, fontSize: fullHeight * 0.018),
                      ),
                    ),
                  ],
                ),
              ),
              Center(child: XpButton(text: 'OK', onTap: closeWindow)),
              SizedBox(
                height: fullHeight * 0.003,
              )
            ],
          ),
        ),
      ),
    );
  }
}
