import 'dart:convert';

import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

//final fiatDeposit = fiatDepositFromJson(jsonString);
FiatDeposit fiatDepositFromJson(String str) => FiatDeposit.fromJson(json.decode(str));

String fiatDepositToJson(FiatDeposit data) => json.encode(data.toJson());

class FiatDeposit {
  FiatDeposit({
    this.banks,
    this.paymentMethods,
    this.walletList,
    this.currencyList,
  });

  List<Bank>? banks;
  List<PaymentMethod>? paymentMethods;
  List<Wallet>? walletList;
  List<FiatCurrency>? currencyList;

  factory FiatDeposit.fromJson(Map<String, dynamic> json) => FiatDeposit(
        banks: json["banks"] == null ? null : List<Bank>.from(json["banks"].map((x) => Bank.fromJson(x))),
        paymentMethods:
            json["payment_methods"] == null ? null : List<PaymentMethod>.from(json["payment_methods"].map((x) => PaymentMethod.fromJson(x))),
        walletList: json["wallet_list"] == null ? null : List<Wallet>.from(json["wallet_list"].map((x) => Wallet.fromJson(x))),
        currencyList: json["currency_list"] == null ? null : List<FiatCurrency>.from(json["currency_list"].map((x) => FiatCurrency.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banks": banks == null ? null : List<dynamic>.from(banks!.map((x) => x.toJson())),
        "payment_methods": paymentMethods == null ? null : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
        "wallet_list": walletList == null ? null : List<dynamic>.from(walletList!.map((x) => x.toJson())),
        "currency_list": currencyList == null ? null : List<dynamic>.from(currencyList!.map((x) => x.toJson())),
      };
}

class Bank {
  Bank({
    required this.id,
    this.accountHolderName,
    this.accountHolderAddress,
    this.bankName,
    this.bankAddress,
    this.country,
    this.swiftCode,
    this.iban,
    this.note,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String? accountHolderName;
  String? accountHolderAddress;
  String? bankName;
  String? bankAddress;
  String? country;
  String? swiftCode;
  String? iban;
  String? note;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json["id"],
        accountHolderName: json["account_holder_name"],
        accountHolderAddress: json["account_holder_address"],
        bankName: json["bank_name"],
        bankAddress: json["bank_address"],
        country: json["country"],
        swiftCode: json["swift_code"],
        iban: json["iban"],
        note: json["note"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == 0? null : id,
        "account_holder_name": accountHolderName,
        "account_holder_address": accountHolderAddress,
        "bank_name": bankName,
        "bank_address": bankAddress,
        "country": country,
        "swift_code": swiftCode,
        "iban": iban,
        "note": note,
      };

  String toCopy() =>
      "Account Holder Name: $accountHolderName,  Bank Name: $bankName, Bank Address: $bankAddress, Country: $country, Swift Code: $swiftCode, Account Number: $iban";
}

class FiatCurrency {
  FiatCurrency({
    required this.id,
    this.name,
    this.code,
    this.symbol,
    this.rate,
    this.status,
    this.isPrimary,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String? name;
  String? code;
  String? symbol;
  String? rate;
  int? status;
  int? isPrimary;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory FiatCurrency.fromJson(Map<String, dynamic> json) => FiatCurrency(
        id: json["id"] ?? 0,
        name: json["name"],
        code: json["code"],
        symbol: json["symbol"],
        rate: json["rate"],
        status: json["status"],
        isPrimary: json["is_primary"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "symbol": symbol,
        "rate": rate,
        "status": status,
        "is_primary": isPrimary,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class PaymentMethod {
  PaymentMethod({
    required this.id,
    this.title,
    this.paymentMethod,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String? title;
  int? paymentMethod;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"],
        title: json["title"],
        paymentMethod: json["payment_method"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "payment_method": paymentMethod,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

/// final fiatWithdrawalResp = fiatWithdrawalRespFromJson(jsonString);

FiatWithdrawalResp fiatWithdrawalRespFromJson(String str) => FiatWithdrawalResp.fromJson(json.decode(str));

String fiatWithdrawalRespToJson(FiatWithdrawalResp data) => json.encode(data.toJson());

class FiatWithdrawalResp {
  FiatWithdrawalResp({this.myWallet, this.currency, this.myBank});

  List<Wallet>? myWallet;
  List<FiatCurrency>? currency;
  List<Bank>? myBank;

  factory FiatWithdrawalResp.fromJson(Map<String, dynamic> json) => FiatWithdrawalResp(
        myWallet: json["my_wallet"] == null ? null : List<Wallet>.from(json["my_wallet"].map((x) => Wallet.fromJson(x))),
        currency: json["currency"] == null ? null : List<FiatCurrency>.from(json["currency"].map((x) => FiatCurrency.fromJson(x))),
        myBank: json["my_bank"] == null ? null : List<Bank>.from(json["my_bank"].map((x) => Bank.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "my_wallet": List<dynamic>.from(myWallet!.map((x) => x.toJson())),
        "currency": List<dynamic>.from(currency!.map((x) => x.toJson())),
        "my_bank": List<dynamic>.from(myBank!.map((x) => x.toJson())),
      };
}

/// final fiatWithdrawalRate = fiatWithdrawalRateFromJson(jsonString);

FiatWithdrawalRate fiatWithdrawalRateFromJson(String str) => FiatWithdrawalRate.fromJson(json.decode(str));

String fiatWithdrawalRateToJson(FiatWithdrawalRate data) => json.encode(data.toJson());

class FiatWithdrawalRate {
  FiatWithdrawalRate({
    this.amount,
    this.rate,
    this.convertAmount,
    this.fees,
    this.netAmount,
    this.currency,
  });

  double? amount;
  double? rate;
  double? convertAmount;
  double? fees;
  double? netAmount;
  String? currency;

  factory FiatWithdrawalRate.fromJson(Map<String, dynamic> json) => FiatWithdrawalRate(
        amount: makeDouble(json["amount"]),
        rate: makeDouble(json["rate"]),
        convertAmount: makeDouble(json["convert_amount"]),
        fees: makeDouble(json["fees"]),
        netAmount: makeDouble(json["net_amount"]),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "rate": rate,
        "convert_amount": convertAmount,
        "fees": fees,
        "net_amount": netAmount,
        "currency": currency,
      };
}
