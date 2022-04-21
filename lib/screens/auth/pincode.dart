import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nerd_bank/helpers/constants.dart';
import 'package:nerd_bank/screens/home/home.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../../helpers/screen.dart';
import '../../helpers/shared_pref.dart';

class Pincode extends StatefulWidget {
  const Pincode({Key? key}) : super(key: key);

  @override
  _PincodeState createState() => _PincodeState();
}

class _PincodeState extends State<Pincode> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isFinger = true;
  final TextEditingController _pinPutController = TextEditingController();
  final PrefHelper _prefHelper = PrefHelper();
  final ScreenHelper _screenHelper = ScreenHelper();

  Widget getWelcomeMessage() {
    return FutureBuilder(
      future: _prefHelper.getValue("pincode"),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          print("TEEST");
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'It seems that you dont have a pincode set up. 4 digits will be used as your new pincode.'
                  .tr(),
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: 'Choose biometrics to sign in',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
    } on PlatformException catch (e) {
      return;
    }
    if (!mounted) {
      return;
    }

    if (authenticated) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    }
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: const Color(0xFF243A59)),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  void signIn() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }

  // check if biometrics are available, if not use pincode default
  @override
  void initState() {
    super.initState();
    auth.canCheckBiometrics.then((canCheckBiometrics) {
      if (canCheckBiometrics) {
        _isFinger = true;
        setState(() {});
      } else {
        _isFinger = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appbar,
      appBar: getAppbar(
        'WELCOME',
        padding: 0,
      ),
      body: getBody(
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              getWelcomeMessage(),
              const SizedBox(height: 100),
              _isFinger
                  ? IconButton(
                      iconSize: 100,
                      icon: const Icon(Icons.fingerprint, color: Colors.grey),
                      onPressed: _authenticateWithBiometrics,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1),
                      child: PinPut(
                        onChanged: (val) {},
                        cursorColor: Colors.red,
                        fieldsCount: 4,
                        controller: _pinPutController,
                        submittedFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        selectedFieldDecoration: _pinPutDecoration,
                        followingFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: appbar,
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                  height: _isFinger
                      ? MediaQuery.of(context).size.height * 0.05
                      : MediaQuery.of(context).size.height * 0.144),
              Expanded(
                child: Container(
                  color: fg,
                  child: NumericKeyboard(
                    onKeyboardTap: (String val) async {
                      if (!_isFinger) {
                        _pinPutController.text += val;
                      }
                      String? pincode = await _prefHelper.getValue("pincode");
                      String text = _pinPutController.text;

                      if (text.length == 4) {
                        if (pincode == null) {
                          await _prefHelper.setValue("pincode", text);
                          signIn();
                          return;
                        }
                        if (text == pincode) {
                          signIn();
                        } else {
                          _pinPutController.text = "";
                          _screenHelper.showSnackbar(
                              true, "Wrong pincode", context);
                        }
                        setState(() {});
                        return;
                      }
                    },
                    textColor: const Color(0xFF343D63),
                    rightButtonFn: () async {
                      // check if biometrics are available
                      if (await auth.canCheckBiometrics) {
                        _isFinger = !_isFinger;
                      } else {
                        _isFinger = false;
                      }
                      setState(() {});
                    },
                    rightIcon: !_isFinger
                        ? const Icon(
                            Icons.fingerprint,
                            color: appbar,
                          )
                        : const Icon(
                            Icons.pin,
                            color: appbar,
                          ),
                    leftButtonFn: () {
                      if (!_isFinger && _pinPutController.text.isNotEmpty) {
                        _pinPutController.text = _pinPutController.text
                            .substring(0, _pinPutController.text.length - 1);
                      }
                      setState(() {});
                    },
                    leftIcon: const Icon(
                      Icons.backspace,
                      color: Color(
                        0xFF343D63,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context,
      ),
    );
  }
}
