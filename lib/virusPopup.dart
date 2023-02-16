import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virus_game/Position.dart';
import 'package:virus_game/xpButton.dart';
import 'package:virus_game/xpTopbar.dart';

class VirusPopup extends StatelessWidget {
  final Position position;
  final Function closeWindow;
  final Function bringToFront;
  final String image;
  final String text;
  final String buttonText;

  const VirusPopup({
    super.key,
    required this.position,
    required this.closeWindow,
    required this.bringToFront,
    required this.image,
    required this.text,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return Positioned(
      bottom: position.y,
      left: position.x,
      child: GestureDetector(
        onTap: () {
          bringToFront();
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade400,
              border: Border(
                  top: BorderSide(color: Colors.white, width: 2),
                  left: BorderSide(color: Colors.white, width: 2),
                  right: BorderSide(color: Colors.black, width: 2),
                  bottom: BorderSide(color: Colors.black, width: 1))),
          width: 0.28 * fullWidth,
          height: 0.16 * fullHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              XpTopbar(close: closeWindow),
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
     
                  XpButton(text: buttonText, onTap: closeWindow),

              
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
