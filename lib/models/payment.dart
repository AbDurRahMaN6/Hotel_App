import 'dart:convert';

Payments paymentsFromJson(String str) => Payments.fromJson(json.decode(str));

String paymentsToJson(Payments data) => json.encode(data.toJson());

class Payments {
  String? id;
  String? cardNumber;
  String? cardHolderName;
  String? expiryDate;
  int? cvv;
  double? amount;

  Payments({
    this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    required this.amount,
  });

  factory Payments.fromJson(Map<String, dynamic> json) => Payments(
        id: json["id"],
        cardNumber: json["cardNumber"],
        cardHolderName: json["cardHolderName"],
        expiryDate: json["expiryDate"],
        cvv: json["cvv"],
        amount: json["amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cardNumber": cardNumber,
        "cardHolderName": cardHolderName,
        "expiryDate": expiryDate,
        "cvv": cvv,
        "amount": amount,
      };
}
