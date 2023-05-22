import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/exchange_order.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/dashboard/buy_sell_tab_views.dart';
import 'package:tradexpro_flutter/ui/features/chart/chart_screen.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'dashboard_controller.dart';
import 'history_tab_views.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final _controller = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getDashBoardData();
    });
  }

  @override
  void dispose() {
    _controller.unSubscribeChannel(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Column(
        children: [
          appBarMain(context, title: "Trade".tr),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
              shrinkWrap: true,
              children: [
                Obx(
                  () => InkWell(
                    onTap: () => chooseCoinPairModal(),
                    child: Row(
                      children: [
                        textAutoSizeTitle(_controller.selectedCoinPair.value.coinPair ?? "", fontSize: Dimens.regularFontSizeLarge),
                        hSpacer5(),
                        showImageAsset(icon: Icons.arrow_drop_down_outlined, color: context.theme.primaryColor)
                      ],
                    ),
                  ),
                ),
                vSpacer10(),
                _coinDetailsView(),
                vSpacer10(),
                Container(padding: const EdgeInsets.all(Dimens.paddingMin), decoration: boxDecorationRoundBorder(), child: const ChartScreenDBoard()),
                vSpacer15(),
                _oderBookView(),
                vSpacer10(),
                const HistoryTabViews(),
                vSpacer10(),
                const BuySellTabViews(),
                vSpacer10(),
                _tradeListView(),
                vSpacer10(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void chooseCoinPairModal() {
    _controller.getCoinPairList("");
    Get.bottomSheet(
        Container(
            alignment: Alignment.bottomCenter,
            color: context.theme.scaffoldBackgroundColor,
            height: getContentHeight(),
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                textFieldSearch(controller: _controller.searchEditController, onTextChange: (value) => _controller.getCoinPairList(value)),
                vSpacer10(),
                listHeaderView("Coin".tr, "Last".tr, "Change".tr),
                dividerHorizontal(),
                Expanded(
                  child: Obx(() {
                    return ListView(
                      shrinkWrap: true,
                      children: List.generate(_controller.coinPairs.length, (index) => _coinPairItemView(_controller.coinPairs[index])),
                    );
                  }),
                )
              ],
            )),
        isDismissible: true);
  }

  Widget _coinPairItemView(CoinPair coinPair) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: InkWell(
        onTap: () {
          Get.back();
          _controller.selectedCoinPair.value = coinPair;
          _controller.getDashBoardData();
        },
        child: Row(
          children: [
            Expanded(flex: 1, child: textAutoSizePoppins(coinPair.coinPairName ?? "", textAlign: TextAlign.start, color: context.theme.primaryColor)),
            Expanded(flex: 1, child: textAutoSizePoppins(coinPair.lastPrice ?? "", color: context.theme.primaryColor)),
            Expanded(
                flex: 1,
                child: textAutoSizePoppins("${coinPair.priceChange ?? ""}%", textAlign: TextAlign.end, color: getNumberColor(coinPair.priceChange))),
          ],
        ),
      ),
    );
  }

  Widget _coinDetailsView() {
    return Obx(() {
      final total = _controller.dashboardData.value.orderData?.total;
      PriceData? lastPData;
      if (_controller.dashboardData.value.lastPriceData.isValid) lastPData = _controller.dashboardData.value.lastPriceData?.first;
      final baseVolume = (total?.tradeWallet?.volume ?? 0) * (total?.tradeWallet?.lastPrice ?? 0);
      final isUp = (lastPData?.price ?? 0) >= (lastPData?.lastPrice ?? 0);
      return Table(
        children: [
          TableRow(children: [
            coinDetailsItemView(currencyFormat(lastPData?.price), "${currencyFormat(lastPData?.lastPrice)}(${total?.baseWallet?.coinType ?? ""})",
                isSwap: true, fromKey: isUp ? FromKey.up : FromKey.down),
            coinDetailsItemView("24h change".tr, "${currencyFormat(total?.tradeWallet?.priceChange)}%",
                subColor: getNumberColor(total?.tradeWallet?.priceChange)),
            coinDetailsItemView("24h high".tr, currencyFormat(total?.tradeWallet?.high))
          ]),
          TableRow(children: [
            coinDetailsItemView("24h low".tr, currencyFormat(total?.tradeWallet?.low)),
            coinDetailsItemView("${"24h volume".tr}(${total?.tradeWallet?.coinType ?? ""})", currencyFormat(total?.tradeWallet?.volume)),
            coinDetailsItemView("${"24h volume".tr}(${total?.baseWallet?.coinType ?? ""})", currencyFormat(baseVolume)),
          ])
        ],
      );
    });
  }

  Widget _oderBookView() {
    return Container(
      padding: const EdgeInsets.all(Dimens.paddingMid),
      decoration: boxDecorationRoundBorder(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textAutoSizeTitle("Order Book".tr, fontSize: Dimens.regularFontSizeLarge),
              Row(
                children: [
                  buttonOnlyIcon(
                      iconPath: AssetConstants.icBoxFilterAll,
                      visualDensity: minimumVisualDensity,
                      onPressCallback: () => _controller.selectedOrderSort.value = FromKey.all),
                  buttonOnlyIcon(
                      iconPath: AssetConstants.icBoxFilterSell,
                      visualDensity: minimumVisualDensity,
                      onPressCallback: () => _controller.selectedOrderSort.value = FromKey.sell),
                  buttonOnlyIcon(
                      iconPath: AssetConstants.icBoxFilterBuy,
                      visualDensity: minimumVisualDensity,
                      onPressCallback: () => _controller.selectedOrderSort.value = FromKey.buy),
                ],
              ),
            ],
          ),
          dividerHorizontal(),
          Obx(() {
            final total = _controller.dashboardData.value.orderData?.total;
            return listHeaderView(
                "${"Price".tr}(${total?.baseWallet?.coinType ?? ""})", "${"Amount".tr}(${total?.tradeWallet?.coinType ?? ""})", "Total".tr);
          }),
          dividerHorizontal(),
          Obx(() {
            return _controller.selectedOrderSort.value == FromKey.buy
                ? vSpacer0()
                : _controller.sellExchangeOrder.isEmpty
                    ? showEmptyView()
                    : Column(
                        children: List.generate(
                            _controller.sellExchangeOrder.length, (index) => _oderBookItemView(_controller.sellExchangeOrder[index], FromKey.sell)),
                      );
          }),
          dividerHorizontal(),
          Obx(() {
            PriceData? lastPData;
            if (_controller.dashboardData.value.lastPriceData.isValid) lastPData = _controller.dashboardData.value.lastPriceData?.first;
            final isUp = (lastPData?.price ?? 0) >= (lastPData?.lastPrice ?? 0);
            final color = isUp ? Colors.green : Colors.red;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textAutoSizeKarla(coinFormat(lastPData?.price), fontSize: Dimens.regularFontSizeMid, color: color),
                Icon(isUp ? Icons.arrow_upward : Icons.arrow_downward, color: color, size: Dimens.iconSizeMinExtra),
                hSpacer5(),
                textAutoSizeKarla(
                    "${coinFormat(lastPData?.lastPrice)}(${_controller.dashboardData.value.orderData?.total?.baseWallet?.coinType ?? ""})",
                    fontSize: Dimens.regularFontSizeSmall),
              ],
            );
          }),
          dividerHorizontal(),
          Obx(() {
            return _controller.selectedOrderSort.value == FromKey.sell
                ? vSpacer0()
                : _controller.buyExchangeOrder.isEmpty
                    ? showEmptyView()
                    : Column(
                        children: List.generate(
                            _controller.buyExchangeOrder.length, (index) => _oderBookItemView(_controller.buyExchangeOrder[index], FromKey.buy)),
                      );
          }),
        ],
      ),
    );
  }

  Widget _oderBookItemView(ExchangeOrder exchangeOrder, String type) {
    final color = type == FromKey.buy ? Colors.green : Colors.red;
    final percent = getPercentageValue(1, exchangeOrder.percentage);
    return Stack(children: [
      RotatedBox(
        quarterTurns: -2,
        child: LinearProgressIndicator(value: percent, minHeight: 20, color: color.withOpacity(0.15), backgroundColor: Colors.transparent),
      ),
      Row(
        children: [
          Expanded(flex: 1, child: textAutoSizePoppins(coinFormat(exchangeOrder.price), textAlign: TextAlign.start, color: color)),
          Expanded(flex: 1, child: textAutoSizePoppins(coinFormat(exchangeOrder.amount), color: context.theme.primaryColor)),
          Expanded(
              flex: 1,
              child: textAutoSizePoppins(coinFormat(exchangeOrder.total, fixed: 2), textAlign: TextAlign.end, color: context.theme.primaryColor)),
        ],
      ),
    ]);
  }

  Widget _tradeListView() {
    return Container(
      padding: const EdgeInsets.all(Dimens.paddingMid),
      decoration: boxDecorationRoundBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textAutoSizeTitle("Trades".tr, fontSize: Dimens.regularFontSizeLarge, textAlign: TextAlign.start),
          dividerHorizontal(),
          Obx(() {
            final total = _controller.dashboardData.value.orderData?.total;
            return listHeaderView(
                "${"Price".tr}(${total?.baseWallet?.coinType ?? ""})", "${"Amount".tr}(${total?.tradeWallet?.coinType ?? ""})", "Time".tr);
          }),
          dividerHorizontal(),
          Obx(() {
            return _controller.exchangeTrades.isEmpty
                ? showEmptyView()
                : ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: Dimens.listHeightMin, maxHeight: Dimens.listHeightMax),
                    child: ListView(
                        shrinkWrap: true,
                        children: List.generate(_controller.exchangeTrades.length, (index) => _tradeItemView(_controller.exchangeTrades[index]))));
            //: Column(children: List.generate(_controller.exchangeTrades.length, (index) => _tradeItemView(_controller.exchangeTrades[index])),);
          }),
        ],
      ),
    );
  }

  Widget _tradeItemView(ExchangeTrade exchangeTrade) {
    final color = (exchangeTrade.price ?? 0) > (exchangeTrade.lastPrice ?? 0)
        ? Colors.green
        : ((exchangeTrade.price ?? 0) < (exchangeTrade.lastPrice ?? 0) ? Colors.red : context.theme.primaryColor);
    return Row(
      children: [
        Expanded(flex: 1, child: textAutoSizePoppins(coinFormat(exchangeTrade.price), textAlign: TextAlign.start, color: color)),
        Expanded(flex: 1, child: textAutoSizePoppins(coinFormat(exchangeTrade.amount), color: context.theme.primaryColor)),
        Expanded(flex: 1, child: textAutoSizePoppins(exchangeTrade.time ?? "", textAlign: TextAlign.end, color: context.theme.primaryColor)),
      ],
    );
  }
}
