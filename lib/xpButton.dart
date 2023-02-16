import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class XpButton extends StatelessWidget {
  final String text;
  final Function onTap;
  const XpButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: 0.046 * fullWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.grey.shade400,
            border: Border(
                top: BorderSide(color: Colors.white, width: 2),
                left: BorderSide(color: Colors.white, width: 2),
                right: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Colors.black, width: 2))),
        child: Text(
          text,
          style: GoogleFonts.getFont('VT323',
              color: Colors.black, fontSize: fullHeight * 0.02),
        ),
      ),
    );
  }
}
