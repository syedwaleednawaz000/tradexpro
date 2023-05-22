import 'dart:convert';

import 'package:tradexpro_flutter/utils/number_util.dart';

/// final wallet = walletFromJson(jsonString?);
///
Wallet walletFromJson(String str) => Wallet.fromJson(json.decode(str));

String? walletToJson(Wallet data) => json.encode(data.toJson());

class Wallet {
  Wallet({
    required this.id,
    this.userId,
    this.name,
    this.coinId,
    this.key,
    this.type,
    this.coinType,
    this.status,
    this.isPrimary,
    this.isDeposit,
    this.isWithdrawal,
    this.tradeStatus,
    this.balance,
    this.createdAt,
    this.updatedAt,
    this.coinIcon,
    this.onOrder,
    this.availableBalance,
    this.total,
    this.onOrderUsd,
    this.availableBalanceUsd,
    this.totalBalanceUsd,
    this.network,
    this.networkName,
    this.minimumWithdrawal,
    this.maximumWithdrawal,
    this.withdrawalFees,
    this.withdrawalFeesType,
    this.encryptId,
  });

  int id;
  int? userId;
  String? encryptId;
  String? name;
  int? coinId;
  dynamic key;
  int? type;
  String? coinType;
  int? status;
  int? isPrimary;
  int? isDeposit;
  int? isWithdrawal;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? coinIcon;
  int? network;
  String? networkName;
  int? tradeStatus;

  double? balance;
  double? onOrder;
  double? availableBalance;
  double? total;
  double? onOrderUsd;
  double? availableBalanceUsd;
  double? totalBalanceUsd;
  double? minimumWithdrawal;
  double? maximumWithdrawal;
  double? withdrawalFees;

  int? withdrawalFeesType;

  factory Wallet.fromJson(Map<String?, dynamic> json) => Wallet(
        id: json["id"] ?? 0,
        userId: json["user_id"],
        encryptId: json["encryptId"],
        name: json["name"],
        coinId: json["coin_id"],
        key: json["key"],
        type: json["type"],
        coinType: json["coin_type"],
        status: json["status"],
        isPrimary: json["is_primary"],
        isDeposit: json["is_deposit"],
        isWithdrawal: json["is_withdrawal"],
        tradeStatus: json["trade_status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        coinIcon: json["coin_icon"],
        balance: makeDouble(json["balance"]),
        onOrder: makeDouble(json["on_order"]),
        availableBalance: makeDouble(json["available_balance"]),
        total: makeDouble(json["total"]),
        onOrderUsd: makeDouble(json["on_order_usd"]),
        availableBalanceUsd: makeDouble(json["available_balance_usd"]),
        totalBalanceUsd: makeDouble(json["total_balance_usd"]),
        network: json["network"],
        networkName: json["network_name"],
        minimumWithdrawal: makeDouble(json["minimum_withdrawal"]),
        maximumWithdrawal: makeDouble(json["maximum_withdrawal"]),
        withdrawalFees: makeDouble(json["withdrawal_fees"]),
        withdrawalFeesType: makeInt(json["withdrawal_fees_type"]),
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "encryptId": encryptId,
        "name": name,
        "coin_id": coinId,
        "key": key,
        "type": type,
        "coin_type": coinType,
        "status": status,
        "is_primary": isPrimary,
        "balance": balance,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "coin_icon": coinIcon,
        "on_order": onOrder,
        "available_balance": availableBalance,
        "total": total,
        "on_order_usd": onOrderUsd,
        "available_balance_usd": availableBalanceUsd,
        "total_balance_usd": totalBalanceUsd,
        "network": network,
        "is_deposit": isDeposit,
        "minimum_withdrawal": minimumWithdrawal,
        "maximum_withdrawal": maximumWithdrawal,
        "withdrawal_fees": withdrawalFees,
        "withdrawal_fees_type": withdrawalFeesType,
      };
}

/// final network = networkFromJson(jsonString);
Network networkFromJson(String str) => Network.fromJson(json.decode(str));

String networkToJson(Network data) => json.encode(data.toJson());

class Network {
  Network({
    required this.id,
    this.walletId,
    this.coinId,
    this.address,
    this.networkType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.networkName,
  });

  int id;
  int? walletId;
  int? coinId;
  String? address;
  String? networkType;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? networkName;

  factory Network.fromJson(Map<String, dynamic> json) => Network(
        id: json["id"],
        walletId: json["wallet_id"],
        coinId: json["coin_id"],
        address: json["address"],
        networkType: json["network_type"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        networkName: json["network_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "wallet_id": walletId,
        "coin_id": coinId,
        "address": address,
        "network_type": networkType,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "network_name": networkName,
      };
}

//final walletDeposit = walletDepositFromJson(jsonString);
WalletDeposit walletDepositFromJson(String str) => WalletDeposit.fromJson(json.decode(str));

String walletDepositToJson(WalletDeposit data) => json.encode(data.toJson());

class WalletDeposit {
  WalletDeposit({
    this.success,
    this.wallet,
    this.address,
    this.message,
    this.data,
  });

  bool? success;
  Wallet? wallet;
  String? address;
  String? message;
  List<Network>? data;

  factory WalletDeposit.fromJson(Map<String, dynamic> json) => WalletDeposit(
        success: json["success"],
        wallet: Wallet.fromJson(json["wallet"]),
        address: json["address"],
        message: json["message"],
        data: List<Network>.from(json["data"].map((x) => Network.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "wallet": wallet?.toJson(),
        "address": address,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
