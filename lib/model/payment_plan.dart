class PaymentPlan {
  final int? id;
  final String? name;
  final String? description;
  final double? amount;
  final String? key;

  PaymentPlan({
    this.id,
    this.name,
    this.description,
    this.amount,
    this.key,
  });

  factory PaymentPlan.fromJson(Map<String, dynamic> json) {
    return PaymentPlan(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      key: json['key'] as String?,
    );
  }

  static List<PaymentPlan> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PaymentPlan.fromJson(json)).toList();
  }
}
