import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nerd_bank/helpers/constants.dart';
import 'package:nerd_bank/models/transaction.dart';

class Details extends StatefulWidget {
  final TransactionModel transaction;
  const Details({Key? key, required this.transaction}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Widget _getText(String text, bool isPrimary) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: isPrimary ? 17 : 13,
        color: isPrimary ? Colors.black : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appbar,
      appBar: getAppbar('TRANSACTION DETAILS'),
      body: getBody(
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getText("From", false),
                _getText(widget.transaction.fromId ?? '', true),
                const SizedBox(height: 10),
                _getText("To", false),
                _getText(widget.transaction.toId ?? 'SELF', true),
                const SizedBox(height: 10),
                _getText("Amount", false),
                _getText("${widget.transaction.amount.toString()}\$", true),
                const SizedBox(height: 10),
                _getText("Date", false),
                _getText(widget.transaction.date.toString(), true),
                const SizedBox(height: 10),
                _getText("Type", false),
                Row(
                  children: [
                    _getText(widget.transaction.type ?? '', true),
                    const SizedBox(width: 10),
                    widget.transaction.type == 'transaction'
                        ? const Icon(
                            Icons.swap_horizontal_circle,
                            color: Colors.green,
                          )
                        : widget.transaction.type == 'deposit'
                            ? const Icon(
                                Icons.arrow_upward,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.arrow_downward,
                                color: Colors.red,
                              ),
                  ],
                ),
              ],
            ),
          ),
          context),
    );
  }
}
