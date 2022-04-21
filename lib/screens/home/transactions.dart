import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nerd_bank/helpers/constants.dart';
import 'package:nerd_bank/screens/details/detail.dart';
import 'package:text_to_speech/text_to_speech.dart';
import '../../helpers/api_helper.dart';
import '../../models/transaction.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final ApiHelper _apiHelper = ApiHelper();
  TextStyle style = const TextStyle(
    package: 'awesome_card',
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontFamily: 'MavenPro',
    fontSize: 22,
  );

  Widget getTransaction(TransactionModel transaction) {
    DateTime date = transaction.date!;
    return Card(
      color: fg,
      child: ListTile(
        onLongPress: () {
          int daysAgo = DateTime.now().difference(date).inDays;
          TextToSpeech().speak(
              "${transaction.type} made with ${transaction.amount} dollar $daysAgo days ago");
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Details(transaction: transaction),
            ),
          );
        },
        trailing: Text(
          '${date.year}-${date.month}-${date.day}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'MavenPro',
            fontSize: 16,
          ),
        ),
        leading: transaction.type == 'transaction'
            ? const Icon(
                Icons.swap_horizontal_circle,
                color: Colors.green,
              )
            : transaction.type == 'deposit'
                ? const Icon(
                    Icons.arrow_upward,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.arrow_downward,
                    color: Colors.red,
                  ),
        title: Text(transaction.type ?? '', style: style).tr(),
        subtitle: Text('${transaction.amount} EUR', style: style),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _apiHelper.getTransactions(),
      builder: (context, AsyncSnapshot<List<TransactionModel>> snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                TransactionModel transaction = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 17),
                  child: getTransaction(transaction),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
