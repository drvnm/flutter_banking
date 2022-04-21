import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nerd_bank/helpers/api_helper.dart';
import 'package:nerd_bank/helpers/constants.dart';
import 'package:nerd_bank/helpers/screen.dart';

import 'languages.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Widget _getTile(
    String text,
    IconData icon, {
    void Function()? onTap,
    Color? iconColor,
    String? subTitle,
  }) {
    return Card(
      color: fg,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(text),
        subtitle: Text(subTitle ?? ''),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenHelper _screenHelper = ScreenHelper();
    ApiHelper _apiHelper = ApiHelper();

    return Scaffold(
      backgroundColor: appbar,
      appBar: getAppbar(
        'SETTINGS'.tr(),
      ),
      body: getBody(
        Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _getTile(
                'Languages'.tr(),
                Icons.language,
                iconColor: Colors.blue,
                subTitle: "Language settings".tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Languages(),
                    ),
                  );
                },
              ),
              _getTile(
                'Logout'.tr(),
                Icons.logout_rounded,
                iconColor: Colors.red,
                subTitle: "Logout from current bank account".tr(),
                onTap: () {
                  _screenHelper.showMessageDialog(
                    "You are about to logout".tr(),
                    "This action will log you out and remove the data from your device.".tr(),
                    context,
                    () {
                      _apiHelper.forgetData(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        context,
      ),
    );
  }
}
