import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/wallet/swap_screen.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/wallet/withdraw_screen.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'deposit_screen.dart';
import 'wallet_controller.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  WalletScreenState createState() => WalletScreenState();
}

class WalletScreenState extends State<WalletScreen> with SingleTickerProviderStateMixin {
  final WalletController _controller = Get.put(WalletController());
  TabController? walletTabController;
  RxInt selectedTabIndex = 0.obs;

  List<String> getTabList() => isSwapActive() ? ["Overview".tr, "Swap".tr] : ["Overview".tr];

  @override
  void initState() {
    walletTabController = TabController(vsync: this, length: getTabList().length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return gUserRx.value.id == 0
          ? Column(children: [appBarMain(context, title: "Wallet".tr), signInNeedView()])
          : Column(
              children: [
                appBarMain(context, title: "Wallet".tr),
                tabBarFill(getTabList(), walletTabController, onTap: (index) => selectedTabIndex.value = index),
                dividerHorizontal(height: Dimens.paddingMid),
                selectedTabIndex.value == 0 ? _walletView() : const SwapScreen()
              ],
            );
    });
  }

  Widget _walletView() {
    return Expanded(
      child: EasyRefresh(
        controller: _controller.refreshController,
        refreshOnStart: true,
        onRefresh: _controller.getWalletList,
        header: ClassicHeader(showText: false, iconTheme: const IconThemeData().copyWith(color: context.theme.colorScheme.secondary)),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(Dimens.paddingMid),
          children: [
            Align(alignment: Alignment.centerLeft, child: textAutoSizeTitle('Wallet Overview'.tr)),
            vSpacer10(),
            Container(
              decoration: boxDecorationRoundCorner(),
              padding: const EdgeInsets.all(Dimens.paddingMid),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textAutoSizePoppins('Total Balance'.tr, color: context.theme.primaryColor),
                  Obx(() {
                    String currencyName = getSettingsLocal()?.currency ?? DefaultValue.currency;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textAutoSizePoppins(currencyFormat(_controller.totalBalance.value),
                            color: context.theme.primaryColor, fontSize: Dimens.regularFontSizeLarge, fontWeight: FontWeight.bold),
                        const SizedBox(width: Dimens.paddingMid),
                        buttonText(currencyName, bgColor: Colors.green)
                      ],
                    );
                  }),
                ],
              ),
            ),
            vSpacer20(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textAutoSizePoppins('Asset'.tr, color: context.theme.primaryColor, fontWeight: FontWeight.bold),
                textAutoSizePoppins('Available Balance'.tr, color: context.theme.primaryColor, fontWeight: FontWeight.bold)
              ],
            ),
            vSpacer5(),
            Obx(() => _controller.walletList.isEmpty
                ? showEmptyView(message: "Your wallets will listed here".tr, height: Dimens.mainContendGapTop)
                : Container(
                    decoration: boxDecorationRoundCorner(),
                    margin: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
                    child: Column(children: List.generate(_controller.walletList.length, (index) => _walletItem(_controller.walletList[index])))))
          ],
        ),
      ),
    );
  }

  Widget _walletItem(Wallet wallet) {
    String currencyName = getSettingsLocal()?.currency ?? DefaultValue.currency;
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingMid),
      child: InkWell(
        onTap: () => showModalSheetFullScreen(context, _walletDetailsView(wallet)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  showImageNetwork(imagePath: wallet.coinIcon, width: Dimens.iconSizeMid, height: Dimens.iconSizeMid),
                  hSpacer10(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textAutoSizePoppins(wallet.coinType ?? "",
                            color: context.theme.primaryColor, fontWeight: FontWeight.bold, fontSize: Dimens.regularFontSizeMid),
                        textAutoSizePoppins(wallet.name ?? "", fontSize: Dimens.regularFontSizeExtraMid),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textAutoSizeTitle(coinFormat(wallet.availableBalance), fontSize: Dimens.regularFontSizeMid),
                  textAutoSizePoppins(currencyFormat(wallet.availableBalanceUsd, name: currencyName), fontSize: Dimens.regularFontSizeExtraMid),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _walletDetailsView(Wallet wallet) {
    final pairList = _controller.getCoinPairList(wallet.coinType ?? "");
    String currencyName = getSettingsLocal()?.currency ?? DefaultValue.currency;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vSpacer10(),
        walletTopView(wallet),
        vSpacer20(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textAutoSizeTitle('Total Balance'.tr, fontSize: Dimens.regularFontSizeMid),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textAutoSizeTitle(coinFormat(wallet.total), fontSize: Dimens.regularFontSizeMid),
                textAutoSizePoppins(currencyFormat(wallet.totalBalanceUsd, name: currencyName), fontSize: Dimens.regularFontSizeExtraMid),
              ],
            ),
          ],
        ),
        dividerHorizontal(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textAutoSizeTitle('On Order'.tr, fontSize: Dimens.regularFontSizeMid),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textAutoSizeTitle(coinFormat(wallet.onOrder), fontSize: Dimens.regularFontSizeMid),
                textAutoSizePoppins(currencyFormat(wallet.onOrderUsd, name: currencyName), fontSize: Dimens.regularFontSizeExtraMid),
              ],
            ),
          ],
        ),
        dividerHorizontal(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textAutoSizeTitle('Available Balance'.tr, fontSize: Dimens.regularFontSizeMid),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textAutoSizeTitle(coinFormat(wallet.availableBalance), fontSize: Dimens.regularFontSizeMid),
                textAutoSizePoppins(currencyFormat(wallet.availableBalanceUsd, name: currencyName), fontSize: Dimens.regularFontSizeExtraMid),
              ],
            ),
          ],
        ),
        dividerHorizontal(),
        Wrap(
          spacing: 10,
          children: [
            if (wallet.isDeposit == 1)
              buttonText("Deposit".tr, onPressCallback: () {
                Get.back();
                Get.to(() => DepositScreen(wallet: wallet));
              }),
            if (wallet.isWithdrawal == 1)
              buttonText("Withdraw".tr, onPressCallback: () {
                Get.back();
                Get.to(() => WithdrawScreen(wallet: wallet));
              }),
            if (wallet.tradeStatus == 1 && pairList.isNotEmpty)
              popupMenu(pairList, child: buttonText("Trade".tr), onSelected: (selected) {
                Get.back();
                final pair = _controller.coinPairs.firstWhere((element) => element.coinPairName == selected);
                getDashboardController().selectedCoinPair.value = pair;
                getRootController().changeBottomNavIndex(0);
              }),
            if (isSwapActive())
              buttonText("Swap".tr, onPressCallback: () {
                Get.back();
                _controller.selectedSwapWallet = wallet;
                walletTabController?.animateTo(1);
                selectedTabIndex.value = 1;
              }),
          ],
        ),
        vSpacer10(),
      ],
    );
  }
}
