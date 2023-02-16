import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class XpTopbar extends StatelessWidget {
  final Function close;
  const XpTopbar({super.key, required this.close});

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3),
      color: Color.fromARGB(255, 8, 43, 96),
      width: double.infinity,
      height: fullHeight * 0.03,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'PlanningAuthorityMalta',
            style: GoogleFonts.getFont('VT323',
                color: Colors.white, fontSize: fullHeight * 0.018),
          ),
          GestureDetector(
            onTap: () {
              close();
            },
            child: Container(
              alignment: Alignment.center,
              height: fullHeight * 0.025,
              width: fullWidth * 0.015,
              color: Colors.grey.shade400,
              child: Icon(Icons.close,
                  color: Colors.grey.shade600, size: fullHeight * 0.025),
            ),
          )
        ],
      ),
    );
  }
}
