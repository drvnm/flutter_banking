import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nerd_bank/helpers/constants.dart';
import 'package:nerd_bank/screens/settings/settings.dart';
import 'package:text_to_speech/text_to_speech.dart';
import '../transaction/transaction.dart';
import 'overview.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _widgets = [const Overview(), const Transaction()];
  int _curr = 0;

  TextStyle style = const TextStyle(
    package: 'awesome_card',
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontFamily: 'MavenPro',
    fontSize: 22,
  );

  Widget getOffsetText(String text, double offset) {
    return Padding(
      padding: EdgeInsets.only(left: offset),
      child: Text(
        text,
        style: style,
      ),
    );
  }

  final TextToSpeech _textToSpeech = TextToSpeech();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appbar,
      appBar: getAppbar(
        'NERD BANK',
        padding: 65,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: fg),
            onPressed: () {
              // naviage to settings
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: bg,
        ),
        child: _widgets[_curr],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bg,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _curr,
        onTap: (int index) => setState(() => _curr = index),
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onLongPress: () {
                _textToSpeech.speak(
                  'Home',
                );
              },
              child: const Icon(
                Icons.home,
              ),
            ),
            label: 'Home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onLongPress: () {
                _textToSpeech.speak("Make Transaction");
              },
              child: const Icon(
                Icons.payment,
              ),
            ),
            label: 'Transaction'.tr(),
          ),
        ],
      ),
    );
  }
}
