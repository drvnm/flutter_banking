class TransactionModel {
  String? fromId;
  String? toId;
  double? amount;
  DateTime? date;
  String? type;

  TransactionModel({
    this.fromId,
    this.toId,
    this.amount,
    this.date,
    this.type,
  });

  // static method wich returns model based on json result
  static TransactionModel fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      fromId: json["fromId"],
      toId: json["toId"],
      amount: json["amount"]?.toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(json['time']),
      type: json["type"],
    );
  }
}
