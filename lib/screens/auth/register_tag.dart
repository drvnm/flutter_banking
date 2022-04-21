import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nerd_bank/helpers/api_helper.dart';
import 'package:nerd_bank/models/user.dart';
import 'package:nerd_bank/screens/auth/pincode.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../../helpers/constants.dart';
import '../../helpers/screen.dart';
import '../../helpers/shared_pref.dart';

class RegisterTag extends StatefulWidget {
  const RegisterTag({Key? key}) : super(key: key);

  @override
  _RegisterTagState createState() => _RegisterTagState();
}

class _RegisterTagState extends State<RegisterTag> {
  final ApiHelper _apiHelper = ApiHelper();
  final TextEditingController _tagController = TextEditingController();
  final ScreenHelper _screenHelper = ScreenHelper();
  final PrefHelper _prefHelper = PrefHelper();
  final TextEditingController _pinPutController = TextEditingController();

  // NTC
  ValueNotifier<dynamic> result = ValueNotifier(null);
  final FocusNode _pinFocus = new FocusNode();

  // builds a form field with custom controller
  Widget _getForm(String text, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.black),
        labelStyle: const TextStyle(color: Colors.black),
        hintText: 'Enter Tag',
        labelText: text,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: appbar, width: 0.7),
        ),
      ),
    );
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: appbar),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      List<int> payload =
          tag.data['ndef']['cachedMessage']['records'][0]['payload'];
      String tagId = String.fromCharCodes(payload).substring(3);
      print(tagId);

      _tagController.text = tagId;
      _pinFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    NfcManager.instance.stopSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appbar,
      appBar: getAppbar(
        'AUTHENTICATE',
        padding: 30,
      ),
      body: getBody(
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _getForm('Tag', _tagController),
                    const SizedBox(height: 30),
                    PinPut(
                      focusNode: _pinFocus,
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
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          UserModel? model = await _apiHelper.getUser(
                            _tagController.text,
                            _pinPutController.text,
                          );

                          if (model != null) {
                            // nav to home page with navigator
                            _prefHelper.setValue("id", _tagController.text);
                            _prefHelper.setValueEnc("authPincode", _pinPutController.text);

                            ApiHelper.id = _tagController.text;
                            ApiHelper.pincode = _pinPutController.text;

                            Navigator.of(context).pop();
                            NfcManager.instance.stopSession();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Pincode()),
                            );
                            _screenHelper.showSnackbar(
                                false, "Signing in", context);
                          } else {
                            _screenHelper.showSnackbar(
                                true, "Incorrect login", context);
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          context),
    );
  }
}
