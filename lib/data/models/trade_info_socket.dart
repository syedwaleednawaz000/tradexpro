import 'dart:convert';
import 'package:tradexpro_flutter/data/models/exchange_order.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'dashboard_data.dart';

/// *** ORDER PLACE *** ///
/// final socketOrderPlace = socketOrderPlaceFromJson(jsonString);
SocketOrderPlace socketOrderPlaceFromJson(String str) => SocketOrderPlace.fromJson(json.decode(str));

//String socketOrderPlaceToJson(SocketOrderPlace data) => json.encode(data.toJson());

class SocketOrderPlace {
  SocketOrderPlace({
    this.orderData,
    this.orders,
  });

  OrderData? orderData;
  Orders? orders;

  factory SocketOrderPlace.fromJson(Map<String, dynamic> json) => SocketOrderPlace(
        orderData: json["order_data"] == null ? null : OrderData.fromJson(json["order_data"]),
        orders: json["orders"] == null ? null : Orders.fromJson(json["orders"]),
      );

// Map<String, dynamic> toJson() => {
//   "pairs": List<dynamic>.from(pairs.map((x) => x.toJson())),
//   "order_data": orderData.toJson(),
//   "last_price_data": List<dynamic>.from(lastPriceData.map((x) => x.toJson())),
//   "orders": orders.toJson(),
// };
}

class Orders {
  Orders({
    this.orders,
    this.orderType,
    this.totalVolume,
  });

  List<ExchangeOrder>? orders;
  String? orderType;
  String? totalVolume;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        orders: List<ExchangeOrder>.from(json["orders"].map((x) => ExchangeOrder.fromJson(x))),
        orderType: json["order_type"],
        totalVolume: json["total_volume"],
      );

// Map<String, dynamic> toJson() => {
//       "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
//       "order_type": orderType,
//       "total_volume": totalVolume,
//     };
}

/// *** TRADE HISTORY *** ///
/// final tradeInfoSocket = tradeInfoSocketFromJson(jsonString);
SocketTradeInfo socketTradeInfoFromJson(String str) => SocketTradeInfo.fromJson(json.decode(str));

String socketTradeInfoToJson(SocketTradeInfo data) => json.encode(data.toJson());

class SocketTradeInfo {
  SocketTradeInfo({
    this.trades,
    this.lastTrade,
    this.orderData,
    this.updateTradeHistory,
    this.pairs,
    this.lastPriceData,
  });

  Trades? trades;
  ExchangeTrade? lastTrade;
  OrderData? orderData;
  bool? updateTradeHistory;
  List<CoinPair>? pairs;
  List<PriceData>? lastPriceData;

  factory SocketTradeInfo.fromJson(Map<String, dynamic> json) => SocketTradeInfo(
        trades: json["trades"] == null ? null : Trades.fromJson(json["trades"]),
        lastTrade: json["last_trade"] == null ? null : ExchangeTrade.fromJson(json["last_trade"]),
        orderData: json["order_data"] == null ? null : OrderData.fromJson(json["order_data"]),
        updateTradeHistory: json["update_trade_history"],
        pairs: json["pairs"] == null ? null : List<CoinPair>.from(json["pairs"].map((x) => CoinPair.fromJson(x))),
        lastPriceData: json["last_price_data"] == null ? null : List<PriceData>.from(json["last_price_data"].map((x) => PriceData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trades": trades == null ? null : trades!.toJson(),
        "last_trade": lastTrade == null ? null : lastTrade!.toJson(),
        "order_data": orderData == null ? null : orderData!.toJson(),
        "update_trade_history": updateTradeHistory,
      };
}

class Trades {
  Trades({this.transactions});

  List<ExchangeTrade>? transactions;

  factory Trades.fromJson(Map<String, dynamic> json) => Trades(
        transactions: json["transactions"] == null ? null : List<ExchangeTrade>.from(json["transactions"].map((x) => ExchangeTrade.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "transactions": transactions == null ? null : List<dynamic>.from(transactions!.map((x) => x.toJson())),
      };
}

class Summary {
  Summary({
    this.baseCoinId,
    this.tradeCoinId,
    this.total,
    this.fees,
    this.onOrder,
    this.sellPrice,
    this.buyPrice,
    this.baseCoin,
    this.tradeCoin,
    this.exchangePair,
    this.exchangeCoinPair,
  });

  int? baseCoinId;
  int? tradeCoinId;
  Total? total;
  Fees? fees;
  OnOrder? onOrder;
  double? sellPrice;
  double? buyPrice;
  String? baseCoin;
  String? tradeCoin;
  String? exchangePair;
  String? exchangeCoinPair;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        baseCoinId: makeInt(json["base_coin_id"]),
        tradeCoinId: makeInt(json["trade_coin_id"]),
        total: json["total"] == null ? null : Total.fromJson(json["total"]),
        fees: (json["fees"] == null || json["fees"] == 0) ? null : Fees.fromJson(json["fees"]),
        onOrder: json["on_order"] == null ? null : OnOrder.fromJson(json["on_order"]),
        sellPrice: makeDouble(json["sell_price"]),
        buyPrice: makeDouble(json["buy_price"]),
        baseCoin: json["base_coin"],
        tradeCoin: json["trade_coin"],
        exchangePair: json["exchange_pair"],
        exchangeCoinPair: json["exchange_coin_pair"],
      );

  Map<String, dynamic> toJson() => {
        "base_coin_id": baseCoinId,
        "trade_coin_id": tradeCoinId,
        "total": total == null ? null : total!.toJson(),
        "fees": fees == null ? null : fees!.toJson(),
        "on_order": onOrder == null ? null : onOrder!.toJson(),
        "sell_price": sellPrice,
        "buy_price": buyPrice,
        "base_coin": baseCoin,
        "trade_coin": tradeCoin,
        "exchange_pair": exchangePair,
        "exchange_coin_pair": exchangeCoinPair,
      };
}

/// *** SELF ORDER HISTORY *** ///
/// final socketUserHistory = socketUserHistoryFromJson(jsonString);
SocketUserHistory socketUserHistoryFromJson(String str) => SocketUserHistory.fromJson(json.decode(str));

//String socketUserHistoryToJson(SocketUserHistory data) => json.encode(data.toJson());

class SocketUserHistory {
  SocketUserHistory({
    this.openOrders,
    this.orderData,
  });

  OpenOrders? openOrders;
  OrderData? orderData;

  factory SocketUserHistory.fromJson(Map<String, dynamic> json) => SocketUserHistory(
        openOrders: json["open_orders"] == null ? null : OpenOrders.fromJson(json["open_orders"]),
        orderData: json["order_data"] == null ? null : OrderData.fromJson(json["order_data"]),
      );

// Map<String, dynamic> toJson() => {
//   "open_orders": openOrders.toJson(),
//   "order_data": orderData.toJson(),
// };
}

class OpenOrders {
  OpenOrders({
    this.orders,
    this.buyOrders,
    this.sellOrders,
  });

  List<Trade>? orders;
  List<Trade>? buyOrders;
  List<Trade>? sellOrders;

  factory OpenOrders.fromJson(Map<String, dynamic> json) => OpenOrders(
        orders: List<Trade>.from(json["orders"].map((x) => Trade.fromJson(x))),
        buyOrders: List<Trade>.from(json["buy_orders"].map((x) => Trade.fromJson(x))),
        sellOrders: List<Trade>.from(json["sell_orders"].map((x) => Trade.fromJson(x))),
      );

// Map<String, dynamic> toJson() => {
//   "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
//   "buy_orders": List<dynamic>.from(buyOrders.map((x) => x.toJson())),
//   "sell_orders": List<dynamic>.from(sellOrders.map((x) => x.toJson())),
// };
}
