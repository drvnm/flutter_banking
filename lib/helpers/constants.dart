import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const appbar = Color(0xFF243A59);
const bg = Color(0xFFF6F8FA);
const fg = Colors.white;

PreferredSizeWidget getAppbar(String title,
    {double? padding = null, dynamic actions = null}) {
  return AppBar(
    // backgroundColor: const Color(0xFF212332),
    backgroundColor: const Color(0xFF243A59),
    title: Padding(
      padding: padding != null
          ? EdgeInsets.only(left: padding)
          : const EdgeInsets.only(right: 50),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.roboto(
            letterSpacing: 2.0,
            fontSize: 17,
            color: Colors.grey,
          ),
        ),
      ),
    ),
    actions: actions,
    elevation: 0,
    toolbarHeight: 80,
  );
}

Widget getBody(Widget inside, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      color: bg,
    ),
    child: inside,
  );
}
