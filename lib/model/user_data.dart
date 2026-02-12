import 'package:motivational/model/card_detail.dart';
import 'package:motivational/model/quote_theme.dart';

class UserData {
  final String id;
  final String email;
  final String userType;
  final int isCard;
  final String packageId;
  QuoteTheme? quotetheme;
  final bool hasPreference;
  final CardDetail? cardDetail;
  final bool autoRenew;
  final bool isGlobal;

  UserData({
    required this.id,
    required this.email,
    required this.userType,
    required this.isCard,
    required this.packageId,
    this.quotetheme,
    required this.hasPreference,
    required this.cardDetail,
    required this.autoRenew,
    required this.isGlobal,
  });

  // Factory constructor to create a UserData instance from a JSON map with null handling
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'].toString(),
      email: json['email'] as String? ?? '',
      userType: json['user_type'].toString(),
      isCard: json['isCard'] ?? 0,
      packageId: (json['package_id'] ?? '').toString(),
      quotetheme:
          json['theme'] == null ? null : QuoteTheme.fromJson(json['theme']!),
      hasPreference: json['hasPreference'] ?? false,
      cardDetail: (json['brand'] ?? '').toString().isEmpty
          ? null
          : CardDetail.fromJson(json),
      autoRenew: json['auto_renew'] == 1,
      isGlobal: json['isGlobal'] == 1,
    );
  }

  bool get isCardAdded => isCard != 0;
  bool get isThemeSelected => quotetheme != null;

  // Method to convert a UserData instance to a JSON map
  Map<String, dynamic> toJson() {
    // return {
    //   'id': id,
    //   'email': email,
    //   'user_type': userType,
    //   'isCard': isCardAdded ? 1 : 0,
    //   'package_id': packageId,
    //   'theme': quotetheme?.toMap(),

    // };
    return {
      'id': id,
      'email': email,
      'user_type': userType,
      'isCard': isCardAdded ? 1 : 0,
      'package_id': packageId,
      'theme': quotetheme?.toMap(),
      'hasPreference': hasPreference,
      'auto_renew': autoRenew ? 1 : 0,
      'isGlobal': isGlobal ? 1 : 0,
      'brand': cardDetail?.brand,
      'exp_month': cardDetail?.expMonth,
      'exp_year': cardDetail?.expiryYear,
      'last4': cardDetail?.last4,
    };
  }

  // Copy with method to create a new instance with modified values
  UserData copyWith({
    String? id,
    String? email,
    String? userType,
    int? isCard,
    String? packageId,
    QuoteTheme? theme,
    bool? hasPreference,
    CardDetail? cardDetail,
    bool? autoRenew,
    bool? isGlobal,
  }) {
    return UserData(
      id: id ?? this.id,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      isCard: isCard ?? this.isCard,
      packageId: packageId ?? this.packageId,
      quotetheme: theme ?? this.quotetheme,
      hasPreference: hasPreference ?? this.hasPreference,
      cardDetail: cardDetail ?? this.cardDetail,
      autoRenew: autoRenew ?? this.autoRenew,
      isGlobal: isGlobal ?? this.isGlobal,
    );
  }
}
