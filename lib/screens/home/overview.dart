import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/material.dart';
import 'package:nerd_bank/screens/home/transactions.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../helpers/api_helper.dart';
import '../../models/user.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  final ApiHelper _apiHelper = ApiHelper();
  TextStyle style = const TextStyle(
    package: 'awesome_card',
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontFamily: 'MavenPro',
    fontSize: 22,
  );

  PageController controller = PageController(viewportFraction: 0.2);

  Widget getCard(UserModel? user) {
    return Expanded(
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: user!.cards!.length,
        itemBuilder: (context, index) {
          dynamic cardModel = user.cards!.elementAt(index);
          DateTime? exprDate = cardModel.expDate;
          String? date =
              '${exprDate?.day}/${exprDate?.month}/${exprDate?.year}';

          return GestureDetector(
            onLongPress: () {
              TextToSpeech().speak('${user.name}  has ${user.balance} dollars');
            },
            child: CreditCard(
              height: 200,
              cardNumber: '${user.id}',
              cardExpiry: date,
              cardHolderName: '${cardModel?.nameHolder} | ${user.balance}\$',
              bankName: "Nerd Bank",
              cardType: CardType.other,
              frontTextColor: Colors.black,
              showBackSide: false,
              frontBackground: CardBackgrounds.custom(0xFFFFFFFF),
              backBackground: CardBackgrounds.white,
            ),
          );
        },
      ),
    );
  }

  Widget getOffsetText(String text, double offset) {
    return Padding(
      padding: EdgeInsets.only(left: offset, top: 10.0, bottom: 10.0),
      child: Text(
        text,
        style: style,
      ).tr(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 0,
        ),
        FutureBuilder(
          future: _apiHelper.getUser(ApiHelper.id, ApiHelper.pincode),
          builder: (context, AsyncSnapshot<UserModel?> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              UserModel? user = snapshot.data;

              return user != null ? getCard(user) : const SizedBox();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const SizedBox();
          },
        ),
        getOffsetText('History', 25.0),
        const TransactionHistory(),
      ],
    );
  }
}
