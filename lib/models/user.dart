import 'package:nerd_bank/models/card.dart';

class UserModel {
  String? id;
  String? tag;
  int? pinCode;
  String? name;
  DateTime? createdAt;
  double? balance;
  String? pfpPath;
  List<dynamic>? cards;

  UserModel({
    this.id,
    this.pinCode,
    this.createdAt,
    this.balance,
    this.pfpPath,
    this.name,
    this.cards,
  });

  // static method that json deserializes the data
  static UserModel fromJson(Map<String, dynamic> json) {
    var user = json['user'];
    var cards = user['cards'];

    List<dynamic> cardList = cards.map((card) {
      CardModel cardModel = CardModel(
        expDate: DateTime.fromMillisecondsSinceEpoch(card['expDate']),
        nameHolder: card['nameHolder'].toString(),
      );
      return cardModel;
    }).toList();

    return UserModel(
      createdAt: DateTime.fromMillisecondsSinceEpoch(user['date']),
      balance: double.parse(user['balance'].toString()),
      pfpPath: user['profile_picture'] ?? "",
      name: user['name'],
      id: user['id'],
      cards: cardList,
    );
  }
}
