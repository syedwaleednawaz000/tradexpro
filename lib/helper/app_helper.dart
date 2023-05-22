import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/exchange_order.dart';
import 'package:tradexpro_flutter/data/models/settings.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/dashboard/dashboard_controller.dart';
import 'package:tradexpro_flutter/ui/features/root/root_controller.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/data/models/user.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

bool isSwapActive() => (getSettingsLocal()?.swapStatus ?? 0) == 1;

Color getNumberColor(dynamic number) => isNegativeNum(number) ? Colors.red : Colors.green;

void logOutActions() {
  clearStorage();
  gUserRx.value = User(id: 0);
  APIRepository().unSubscribeAllChannels();
}

Trade getTradeDemo() {
  return Trade(id: 956)
    ..transactionId = "166425830600000000000000000941"
    ..type = "buy"
    ..price = 12.00
    ..createdAt = DateTime.now()
    ..actualAmount = 5631591.44958847
    ..processed = 0.00119256
    ..status = 0
    ..actualAmount = 67579097.39506164
    ..amount = 5631591.44839591
    ..total = 67579097.38075092
    ..fees = 3378954.86903754;
}

CommonSettings? getSettingsLocal() {
  var objMap = GetStorage().read(PreferenceKey.settingsObject);
  if (objMap != null) {
    try {
      CommonSettings settings = CommonSettings.fromJson(objMap);
      return settings;
    } catch (_) {
      printFunction("getSettingsLocal error", _);
    }
  }
  return null;
}

String getName(String? firstName, String? lastName) {
  String name = "";
  firstName = firstName ?? "";
  lastName = lastName ?? "";
  if (firstName.isNotEmpty) {
    name = firstName;
  }
  if (lastName.isNotEmpty) {
    name = "$name $lastName";
  }
  return name;
}

List getHistoryTypeData(String type) {
  switch (type) {
    case HistoryType.deposit:
      return ["Deposit", Colors.green];
    case HistoryType.withdraw:
      return ["Withdrawal", Colors.red];
    case HistoryType.stopLimit:
      return ["Stop Limit", Colors.teal];
    case HistoryType.swap:
      return ["Swap", Colors.blue];
    case HistoryType.buyOrder:
      return ["Buy Order", Colors.green];
    case HistoryType.sellOrder:
      return ["Sell Order", Colors.pinkAccent];
    case HistoryType.transaction:
      return ["Transaction", Colors.amber];
    case HistoryType.fiatDeposit:
      return ["Fiat Deposit", Colors.blueGrey];
    case HistoryType.fiatWithdrawal:
      return ["Fiat Withdrawal", Colors.deepOrangeAccent];
    case HistoryType.refEarningTrade:
      return ["From Trade", Colors.cyan];
    case HistoryType.refEarningWithdrawal:
      return ["From Withdrawal", Colors.deepOrange];
  }
  return [];
}

List getStatusData(int status) {
  switch (status) {
    case 0:
      return ["Pending".tr, Colors.amber];
    case 1:
      return ["Success".tr, Colors.green];
    case 2:
      return ["Failed".tr, Colors.red];
  }
  return [Colors.black];
}

String getUserStatus(int? status) {
  String statusStr = "Inactive".tr;
  if (status == 1) {
    statusStr = "Active".tr;
  }
  return statusStr;
}

void updateGlobalUser() => getRootController().getMyProfile();

void updateCommonSettings() => getRootController().getCommonSettings();

RootController getRootController() {
  if (Get.isRegistered<RootController>()) {
    return Get.find<RootController>();
  } else {
    return Get.put(RootController());
  }
}

DashboardController getDashboardController() {
  if (Get.isRegistered<DashboardController>()) {
    return Get.find<DashboardController>();
  } else {
    return Get.put(DashboardController());
  }
}

void saveGlobalUser({User? user, Map<String, dynamic>? userMap}) {
  if (userMap != null) {
    GetStorage().write(PreferenceKey.userObject, userMap);
    gUserRx.value = User.fromJson(userMap);
  } else if (user != null) {
    gUserRx.value = user;
    GetStorage().write(PreferenceKey.userObject, user.toJson());
  }
}

String getIdVerificationStatus(String? status) {
  if (status == IdVerificationStatus.pending) {
    return "Pending".tr;
  } else if (status == IdVerificationStatus.accepted) {
    return "Accepted".tr;
  } else if (status == IdVerificationStatus.rejected) {
    return "Rejected".tr;
  }
  return "Not submitted".tr;
}

Color getIdVerificationStatusColor(String? status) {
  if (status == IdVerificationStatus.pending) {
    return Colors.amber;
  } else if (status == IdVerificationStatus.accepted) {
    return Colors.green;
  } else if (status == IdVerificationStatus.rejected) {
    return Colors.red;
  }
  return Colors.red;
}

List<String> getCurrencyList(List<FiatCurrency>? currencyList) {
  if (currencyList != null) {
    List<String> cList = currencyList.map((e) => e.name ?? "").toList();
    return cList;
  }
  return [];
}

Candle getCandle(Map<String, dynamic> json) {
  return Candle(
    date: dateFromSecond(json["time"]),
    low: makeDouble(json["low"]),
    high: makeDouble(json["high"]),
    open: makeDouble(json["open"]),
    close: makeDouble(json["close"]),
    volume: makeDouble(json["volume"]),
  );
}

String getActivityActionText(String? status) {
  if (status == "1") {
    return "Login".tr;
  }
  return "";
}
