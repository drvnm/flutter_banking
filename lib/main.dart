import 'package:flutter/material.dart';
import 'package:nerd_bank/helpers/api_helper.dart';
import 'package:nerd_bank/screens/auth/pincode.dart';
import 'package:nerd_bank/screens/auth/register_tag.dart';
import 'helpers/shared_pref.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? lan = await PrefHelper().getValue("lan");
  print("$lan + !!!!!!!!!!!!!!!!!!!!!!!!");

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      child: MyApp(),
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('de'),
        Locale('nl'),
      ],
      startLocale: Locale(lan ?? "en"),
      path: 'assets/languages',
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PrefHelper _prefHelper = PrefHelper();

  Locale? _locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: Future.wait([
            _prefHelper.getValue('authPincode'),
            _prefHelper.getValueEnc('id'),
          ]),
          builder: (context, AsyncSnapshot<List<String?>> snapshot) {
            if (snapshot.hasData && snapshot.data?.elementAt(0) != null) {
              String pincode = snapshot.data!.elementAt(0) ?? "";
              String id = snapshot.data!.elementAt(1) ?? "";
              ApiHelper.pincode = pincode;
              ApiHelper.id = id;
              return const Pincode();
            } else {
              return const RegisterTag();
            }
          }),
    );
  }
}
