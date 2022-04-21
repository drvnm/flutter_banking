import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../helpers/api_helper.dart';
import '../../helpers/screen.dart';
import '../../models/user.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _amountPreviewController =
      TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late UserModel user;
  final ScreenHelper _screenHelper = ScreenHelper();
  final ApiHelper _apiHelper = ApiHelper();

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      List<int> payload =
          tag.data['ndef']['cachedMessage']['records'][0]['payload'];
      String tagId = String.fromCharCodes(payload).substring(3);
      print(tagId);
      List<String>? info = await _apiHelper.getScanInfo(tagId);
      if (info.isNotEmpty) {
        _nameController.text = info[0];
        _ibanController.text = info[1];
      } else {
        _screenHelper.showSnackbar(
            true, 'Card does not belong to a user.', context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    NfcManager.instance.stopSession();
  }

  Widget _getFormTag(String text, TextEditingController controller) {
    return TextField(
      onChanged: (val) {
        if (val != '') {
          double amt = (user.balance! - double.parse(_amountController.text));

          _amountPreviewController.text = amt >= 0 ? amt.toString() : '0';
        } else {
          _amountPreviewController.text = user.balance.toString();
        }
      },
      keyboardType: TextInputType.number,
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.black),
        labelStyle: const TextStyle(color: Colors.black),
        hintText: 'Enter amount',
        labelText: text,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 0.7),
        ),
      ),
    );
  }

  Widget _getFormPreview(String text, TextEditingController controller) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.black),
        labelStyle: const TextStyle(color: Colors.black),
        labelText: controller.text,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 0.7),
        ),
      ),
    );
  }

  Widget _getFormIBAN(
      String text, TextEditingController controller, bool isKeyboard) {
    return TextField(
      keyboardType: isKeyboard ? TextInputType.number : TextInputType.text,
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.black),
        labelStyle: const TextStyle(color: Colors.black),
        labelText: text,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 0.7),
        ),
      ),
    );
  }

  Widget _getButton() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.08,
      color: Colors.blue,
      child: ElevatedButton(
        onPressed: () async {
          if (_amountController.text.isNotEmpty &&
              _ibanController.text.isNotEmpty &&
              _nameController.text.isNotEmpty) {
            double amt = double.parse(_amountController.text);
            amt = (user.balance! - amt) < 0 ? user.balance! : amt;
            String to = _ibanController.text;
            String name = _nameController.text;
            bool status = await _apiHelper.makeTransaction(amt, to, name);
            _screenHelper.showSnackbar(
                !status, !status ? "Success" : "Something went wrong", context);
          }
        },
        child: Text('Transfer'.tr()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: FutureBuilder(
            future: _apiHelper.getUser(ApiHelper.id, ApiHelper.pincode),
            builder: (context, AsyncSnapshot<UserModel?> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              user = snapshot.data!;
              _amountPreviewController.text = user.balance!.toString();
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: _getFormTag('Amount'.tr(), _amountController),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _getFormPreview(_amountPreviewController.text,
                            _amountPreviewController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _getFormIBAN('IBAN', _ibanController, true),
                  const SizedBox(height: 20),
                  _getFormIBAN('NAME'.tr(), _nameController, false),
                  const SizedBox(height: 20),
                  _getButton(),
                ],
              );
            }),
      ),
    );
  }
}
