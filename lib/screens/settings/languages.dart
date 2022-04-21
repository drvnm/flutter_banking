import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nerd_bank/helpers/constants.dart';

import '../../helpers/screen.dart';
import '../../helpers/shared_pref.dart';
import '../../main.dart';

class Languages extends StatefulWidget {
  const Languages({Key? key}) : super(key: key);

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  final PrefHelper _prefHelper = PrefHelper();
  final ScreenHelper _screenHelper = ScreenHelper();

  Widget _getTile(
    String text, {
    void Function()? onTap,
  }) {
    return Card(
      color: fg,
      child: ListTile(
        leading: const Icon(Icons.language, color: Colors.blue),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }

  Future<void> setLanguage(String language, BuildContext context) async {
    MyApp.of(context)?.setLocale(Locale(language));
    await _prefHelper.setValue("lan", language);
    _screenHelper.showSnackbar(
        false, "Restart app to switch languages", context);

    await context.setLocale(Locale(language));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appbar,
      appBar: getAppbar("Language".tr()),
      body: getBody(
        Column(children: [
          const SizedBox(height: 20),
          _getTile(
            "English",
            onTap: () {
              setLanguage("en", context);
            },
          ),
          _getTile(
            "Nederlands",
            onTap: () {
              setLanguage("nl", context);
            },
          ),
          _getTile(
            "Français",
            onTap: () {
              setLanguage("fr", context);
            },
          ),
          _getTile(
            "Deutsch",
            onTap: () {
              setLanguage("de", context);
            },
          ),
        ]),
        context,
      ),
    );
  }
}
