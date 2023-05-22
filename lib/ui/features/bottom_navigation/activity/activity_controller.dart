import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/exchange_order.dart';
import 'package:tradexpro_flutter/data/models/history.dart';
import 'package:tradexpro_flutter/data/models/referral.dart';
import '../../../../data/models/list_response.dart';
import '../../../../data/models/response.dart';
import '../../../../data/remote/api_repository.dart';
import '../../../../helper/app_helper.dart';
import '../../../../utils/common_utils.dart';

class ActivityScreenController extends GetxController {
  bool hasMoreData = true;
  int loadedPage = 0;
  RxBool isLoading = true.obs;
  RxInt selectedType = 0.obs;
  TextEditingController searchController = TextEditingController();
  HistoryResponse? historyResponse;
  Map<String, String>? statusMap;
  RxList<dynamic> activityDataList = <dynamic>[].obs;

  Map<String, String> getTypeMap() {
    final isCurrencyDeposit = getSettingsLocal()?.currencyDepositStatus == "1";
    var map = {
      HistoryType.deposit: "Deposit History".tr,
      HistoryType.withdraw: "Withdrawal History".tr,
      HistoryType.stopLimit: "Stop Limit History".tr,
      HistoryType.swap: "Swap History".tr,
      HistoryType.buyOrder: "Buy Order History".tr,
      HistoryType.sellOrder: "Sell Order History".tr,
      HistoryType.transaction: "Transaction History".tr
    };
    if (isCurrencyDeposit) {
      map[HistoryType.fiatDeposit] = "Fiat Deposit History".tr;
      map[HistoryType.fiatWithdrawal] = "Fiat Withdrawal History".tr;
    }
    map[HistoryType.refEarningWithdrawal] = "Referral Earning From Withdrawal".tr;
    map[HistoryType.refEarningTrade] = "Referral Earning From Trade".tr;
    return map;
  }

  String getKey() {
    return getTypeMap().keys.toList()[selectedType.value];
    //return getMapKey(selectedType.value, getTypeMap());
  }

  Future<void> getListData(bool isLoadMore) async {
    if (!isLoadMore) {
      loadedPage = 0;
      hasMoreData = true;
      activityDataList.clear();
    }
    isLoading.value = true;
    loadedPage++;
    final type = getKey();
    APIRepository().getActivityList(loadedPage, type).then((resp) {
      isLoading.value = false;
      ListResponse? listResponse;
      if (resp.success) {
        if (type == HistoryType.fiatDeposit || type == HistoryType.fiatWithdrawal ||
            type == HistoryType.refEarningTrade || type == HistoryType.refEarningWithdrawal) {
          listResponse = ListResponse.fromJson(resp.data);
        } else {
          historyResponse = HistoryResponse.fromJson(resp.data);
          statusMap = historyResponse?.status;
          listResponse = historyResponse?.histories;
        }

        if (listResponse != null) {
          loadedPage = listResponse.currentPage ?? 0;
          hasMoreData = listResponse.nextPageUrl != null;
          List<dynamic> list = [];
          if (type == HistoryType.swap) {
            list = List<SwapHistory>.from(listResponse.data!.map((x) => SwapHistory.fromJson(x)));
          } else if (type == HistoryType.buyOrder ||
              type == HistoryType.sellOrder ||
              type == HistoryType.transaction ||
              type == HistoryType.stopLimit) {
            list = List<Trade>.from(listResponse.data!.map((x) => Trade.fromJson(x)));
          } else if (type == HistoryType.fiatDeposit || type == HistoryType.fiatWithdrawal) {
            list = List<FiatHistory>.from(listResponse.data!.map((x) => FiatHistory.fromJson(x)));
          } else if (type == HistoryType.refEarningTrade || type == HistoryType.refEarningWithdrawal) {
            list = List<ReferralHistory>.from(listResponse.data!.map((x) => ReferralHistory.fromJson(x)));
          } else {
            list = List<History>.from(listResponse.data!.map((x) => History.fromJson(x)));
          }
          activityDataList.addAll(list);
        }
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoading.value = false;
      showToast(err.toString());
    });
  }
}
