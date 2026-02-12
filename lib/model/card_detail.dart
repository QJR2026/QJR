class CardDetail {
  String? brand;
  String? expMonth;
  String? expiryYear;
  String? last4;

  CardDetail(
      {required this.brand,
      required this.expMonth,
      required this.expiryYear,
      required this.last4});

  factory CardDetail.fromJson(Map<String, dynamic> json) {
    return CardDetail(
      brand: (json['brand'] ?? '').toString(),
      expMonth: (json['exp_month'] ?? '').toString(),
      expiryYear: (json['exp_year'] ?? '').toString(),
      last4: (json['last4'] ?? '').toString(),
    );
  }
}
