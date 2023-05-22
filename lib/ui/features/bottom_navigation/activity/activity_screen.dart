import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/exchange_order.dart';
import 'package:tradexpro_flutter/data/models/referral.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/data/models/history.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'activity_controller.dart';

class ActivityScreen extends StatefulWidget {
  final IconData? iconData;

  const ActivityScreen({Key? key, this.iconData}) : super(key: key);

  @override
  ActivityScreenState createState() => ActivityScreenState();
}

class ActivityScreenState extends State<ActivityScreen> with TickerProviderStateMixin {
  final _controller = Get.put(ActivityScreenController());
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (gUserRx.value.id > 0) {
        _controller.getListData(false);
        _scrollController.addListener(() {
          if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
            if (_controller.hasMoreData) _controller.getListData(true);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => gUserRx.value.id == 0
        ? Column(children: [appBarMain(context, title: "Reports".tr), signInNeedView()])
        : Column(
            children: [
              appBarMain(context, title: "Reports".tr),
              dropDownListIndex(_controller.getTypeMap().values.toList(), _controller.selectedType.value, "All type".tr, (value) {
                _controller.selectedType.value = value;
                _controller.getListData(false);
              }),
              _activityTypeList()
            ],
          ));
  }

  Widget _activityTypeList() {
    return Obx(() {
      final key = _controller.getKey();
      final historyData = getHistoryTypeData(key);
      return _controller.activityDataList.isEmpty
          ? handleEmptyViewWithLoading(_controller.isLoading.value)
          : Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
                controller: _scrollController,
                children: List.generate(
                  _controller.activityDataList.length,
                  (index) {
                    if (key == HistoryType.swap) {
                      return _swapHistoryItemView(_controller.activityDataList[index], historyData);
                    } else if (key == HistoryType.buyOrder || key == HistoryType.sellOrder || key == HistoryType.transaction) {
                      return _tradeItemView(_controller.activityDataList[index], historyData, key);
                    } else if (key == HistoryType.fiatDeposit || key == HistoryType.fiatWithdrawal) {
                      return _fiatHistoryItemView(_controller.activityDataList[index], historyData);
                    } else if (key == HistoryType.stopLimit) {
                      return _stopLimitItemView(_controller.activityDataList[index], historyData);
                    } else if (key == HistoryType.refEarningWithdrawal || key == HistoryType.refEarningTrade) {
                      return _referralItemView(_controller.activityDataList[index], historyData, key);
                    }
                    return _historyItemView(_controller.activityDataList[index], historyData, key);
                  },
                ),
              ),
            );
    });
  }

  Widget _historyItemView(History history, List historyData, String type) {
    final statusData = getStatusData(history.status ?? 0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buttonRoundedMain(text: historyData.first, width: 100, buttonHeight: Dimens.btnHeightMin, bgColor: historyData.last),
              textAutoSizePoppins(history.coinType ?? "",
                  color: context.theme.primaryColor, fontWeight: FontWeight.bold, fontSize: Dimens.regularFontSizeMid),
            ],
          ),
          vSpacer5(),
          twoTextSpace('Amount'.tr, coinFormat(history.amount)),
          vSpacer5(),
          twoTextSpace('Fees'.tr, coinFormat(history.fees)),
          vSpacer5(),
          twoTextSpaceFixed('Address'.tr, history.address ?? "", color: context.theme.primaryColorLight),
          vSpacer5(),
          if (type == HistoryType.deposit)
            twoTextSpaceFixed('Transaction ID'.tr, history.transactionId ?? "", color: context.theme.primaryColorLight),
          if (type == HistoryType.withdraw)
            twoTextSpaceFixed('Transaction Hash'.tr, history.transactionHash ?? "", color: context.theme.primaryColorLight),
          vSpacer5(),
          twoTextSpace('Created At'.tr, formatDate(history.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
          vSpacer5(),
          twoTextSpace('Status'.tr, statusData.first, subColor: statusData.last),
          dividerHorizontal()
        ],
      ),
    );
  }

  Widget _swapHistoryItemView(SwapHistory swapHistory, List historyData) {
    final statusData = getStatusData(swapHistory.status ?? 0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buttonRoundedMain(text: historyData.first, width: 100, buttonHeight: Dimens.btnHeightMin, bgColor: historyData.last),
          vSpacer5(),
          twoTextSpaceFixed('From Wallet'.tr, swapHistory.fromWallet ?? "", color: context.theme.primaryColorLight),
          vSpacer5(),
          twoTextSpaceFixed('To Wallet'.tr, swapHistory.toWallet ?? "", color: context.theme.primaryColorLight),
          vSpacer5(),
          twoTextSpace('Requested Amount'.tr, coinFormat(swapHistory.requestedAmount)),
          vSpacer5(),
          twoTextSpace('Converted Amount'.tr, coinFormat(swapHistory.convertedAmount)),
          vSpacer5(),
          twoTextSpace('Rate'.tr, coinFormat(swapHistory.rate), color: context.theme.primaryColorLight),
          vSpacer5(),
          twoTextSpace('Created At'.tr, formatDate(swapHistory.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
          vSpacer5(),
          twoTextSpace('Status'.tr, statusData.first, subColor: statusData.last),
          dividerHorizontal()
        ],
      ),
    );
  }

  Widget _tradeItemView(Trade tradeHistory, List historyData, String type) {
    final statusData = getStatusData(tradeHistory.status ?? 0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buttonText(historyData.first, bgColor: historyData.last),
          vSpacer5(),
          if (type == HistoryType.transaction)
            twoTextSpaceFixed('Transaction Id'.tr, tradeHistory.transactionId ?? "", color: context.theme.primaryColorLight),
          if (type == HistoryType.transaction) vSpacer5(),
          twoTextSpaceFixed('Base Coin'.tr, tradeHistory.baseCoin ?? "", color: context.theme.primaryColorLight),
          vSpacer5(),
          twoTextSpaceFixed('Trade Coin'.tr, tradeHistory.tradeCoin ?? "", color: context.theme.primaryColorLight),
          vSpacer5(),
          twoTextSpace('Amount'.tr, coinFormat(tradeHistory.amount)),
          vSpacer5(),
          if (type != HistoryType.transaction) twoTextSpace('Processed'.tr, coinFormat(tradeHistory.processed)),
          if (type != HistoryType.transaction) vSpacer5(),
          twoTextSpace('Price'.tr, coinFormat(tradeHistory.price)),
          vSpacer5(),
          if (type == HistoryType.transaction) twoTextSpaceFixed('Fees'.tr, coinFormat(tradeHistory.fees), color: context.theme.primaryColorLight),
          if (type == HistoryType.transaction) vSpacer5(),
          twoTextSpace('Date'.tr,
              type == HistoryType.transaction ? (tradeHistory.time ?? "") : formatDate(tradeHistory.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
          vSpacer5(),
          if (type != HistoryType.transaction) twoTextSpace('Status'.tr, statusData.first, subColor: statusData.last),
          dividerHorizontal()
        ],
      ),
    );
  }

  Widget _stopLimitItemView(Trade tradeHistory, List historyData) {
    final pcl = context.theme.primaryColorLight;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buttonText(historyData.first, bgColor: historyData.last),
          vSpacer5(),
          twoTextSpaceFixed('Base Coin'.tr, tradeHistory.baseCoin ?? "", color: pcl),
          vSpacer5(),
          twoTextSpaceFixed('Trade Coin'.tr, tradeHistory.tradeCoin ?? "", color: pcl),
          vSpacer5(),
          twoTextSpace('Amount'.tr, coinFormat(tradeHistory.amount)),
          vSpacer5(),
          twoTextSpace('Price'.tr, coinFormat(tradeHistory.price)),
          vSpacer5(),
          twoTextSpaceFixed('Order Type'.tr, tradeHistory.type ?? "", color: pcl),
          vSpacer5(),
          twoTextSpace('Date'.tr, formatDate(tradeHistory.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
          dividerHorizontal()
        ],
      ),
    );
  }

  Widget _fiatHistoryItemView(FiatHistory history, List historyData) {
    final statusData = getStatusData(history.status ?? 0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: buttonRoundedMain(text: historyData.first, width: 150, buttonHeight: Dimens.btnHeightMin, bgColor: historyData.last)),
          vSpacer5(),
          twoTextSpace('Currency Amount'.tr, "${coinFormat(history.currencyAmount)} ${history.currency ?? ""}"),
          vSpacer5(),
          twoTextSpace('Coin Amount'.tr, "${coinFormat(history.coinAmount)} ${history.coinType ?? ""}"),
          vSpacer5(),
          twoTextSpace('Rate'.tr, "${coinFormat(history.rate)} ${history.coinType ?? ""}"),
          vSpacer5(),
          if (history.transactionId.isValid)
            twoTextSpaceFixed('Transaction ID'.tr, history.transactionId ?? "", color: context.theme.primaryColorLight),
          if (history.transactionId.isValid) vSpacer5(),
          twoTextSpace('Date'.tr, formatDate(history.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
          vSpacer5(),
          twoTextSpace('Status'.tr, statusData.first, subColor: statusData.last),
          dividerHorizontal()
        ],
      ),
    );
  }

  Widget _referralItemView(ReferralHistory refHistory, List historyData, String type) {
    final pcl = context.theme.primaryColorLight;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buttonText(historyData.first, bgColor: historyData.last),
          vSpacer5(),
          twoTextSpaceFixed('Referral user mail'.tr, refHistory.referralUserEmail ?? "", color: pcl),
          vSpacer5(),
          twoTextSpaceFixed('Transaction Id'.tr, refHistory.transactionId ?? "", color: pcl),
          vSpacer5(),
          twoTextSpace('Amount'.tr, "${coinFormat(refHistory.amount)} ${refHistory.coinType}"),
          vSpacer5(),
          twoTextSpace('Date'.tr, formatDate(refHistory.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
          dividerHorizontal()
        ],
      ),
    );
  }
}
