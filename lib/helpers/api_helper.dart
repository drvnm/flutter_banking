import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nerd_bank/helpers/shared_pref.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../screens/auth/register_tag.dart';

class ApiHelper {
  static String id = '';
  static String pincode = '';

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'id': id,
    'pincode': pincode,
  };

  static String url = "nerdbank.ga:8443";
  Uri uri = Uri.parse(url);

  // returns user model based on id
  Future<UserModel?> getUser(String id, String pincode) async {
    Uri uri = Uri.https(url, '/api/user/$id');
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'id': id,
      'pincode': pincode,
    });
    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      if (data['user'] == null) {
        return null;
      }
      return UserModel.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  // returns user model based on id
  Future<UserModel?> getUserByTag(String iban) async {
    Uri uri = Uri.https(url, '/api/user/$iban');
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      if (data['user'] == null) {
        return null;
      }
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  // returns a list of transaction models based on user id
  Future<List<TransactionModel>> getTransactions() async {
    print("ID:::$id");
    Uri uri = Uri.https(url, '/api/balance/history/$id');
    final response = await http.get(uri, headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var results = json.decode(response.body)['result'];
      List<TransactionModel> transactions = [];
      for (int i = 0; i < results.length; i++) {
        transactions.add(TransactionModel.fromJson(results[i]));
      }
      return transactions;
    } else {
      throw Exception('Failed to load post');
    }
  }

  // makes a transactions between 2 people and returns status message
  Future<bool> makeTransaction(double amount, String to, name) async {
    Uri uri = Uri.https(url, '/api/balance/transfer');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'pincode': pincode,
      'id': id,
      'amount': amount.toString(),
      'to': to,
      'name': name,
    };
    final response = await http.post(uri, headers: headers);
    return response.statusCode == 200;
  }

  // deletes all data from shared prefs and switches screen
  Future<void> forgetData(BuildContext context) async {
    PrefHelper helper = PrefHelper();
    await helper.clear();

    // switch screens
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterTag()),
    );
  }

  Future<List<String>> getScanInfo(String id) async {
    Uri uri = Uri.https(url, '/api/user/appInfo/$id');
    final response = await http.get(uri);
  
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return [data['result'][0], data['result'][1]];
    } else {
      return [];
    }
  }
}
