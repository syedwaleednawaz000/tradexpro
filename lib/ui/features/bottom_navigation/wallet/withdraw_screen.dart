import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/faq.dart';
import 'package:tradexpro_flutter/data/models/history.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/wallet/wallet_controller.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key? key, required this.wallet}) : super(key: key);
  final Wallet wallet;

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _controller = Get.find<WalletController>();
  final _addressEditController = TextEditingController();
  final _amountEditController = TextEditingController();
  Rx<Wallet> walletRx = Wallet(id: 0).obs;
  RxList<Network> networkList = <Network>[].obs;
  Rx<Network> selectedNetwork = Network(id: 0).obs;
  bool isWithdraw2FActive = false;
  RxList<History> historyList = <History>[].obs;
  RxList<FAQ> faqList = <FAQ>[].obs;

  @override
  void initState() {
    walletRx.value = widget.wallet;
    isWithdraw2FActive = getSettingsLocal()?.twoFactorWithdraw == "1";
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getWalletWithdrawal(widget.wallet, (updateWallet, list) {
        walletRx.value = updateWallet;
        networkList.value = list;
        if (networkList.isNotEmpty) {
          final net = networkList.firstWhereOrNull((element) => element.id == walletRx.value.network);
          if (net != null) selectedNetwork.value = net;
        }
        _controller.getHistoryListData(HistoryType.withdraw, (list) => historyList.value = list);
        _controller.getFAQList(FAQType.withdrawn, (list) => faqList.value = list);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
            child: Column(
              children: [
                appBarBackWithActions(title: "Withdraw".tr),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(Dimens.paddingMid),
                    children: [
                      vSpacer10(),
                      walletTopView(widget.wallet),
                      vSpacer10(),
                      Obx(() => twoTextSpaceBackground("Balance".tr, coinFormat(walletRx.value.balance), textColor: context.theme.primaryColor)),
                      _networkView(),
                      vSpacer20(),
                      textFieldWithSuffixIcon(controller: _addressEditController, hint: "Address".tr, labelText: "Address".tr),
                      vSpacer10(),
                      textFieldWithSuffixIcon(
                          controller: _amountEditController, hint: "Amount to withdraw".tr, labelText: "Amount".tr, type: TextInputType.number),
                      vSpacer2(),
                      Obx(() => Column(
                            children: [
                              textAutoSizePoppins(
                                  "withdraw_Max_min_fees".trParams({
                                    "fee": coinFormat(walletRx.value.withdrawalFees),
                                    "sign": walletRx.value.withdrawalFeesType == 2 ? "%" : "",
                                    "min": coinFormat(walletRx.value.minimumWithdrawal),
                                    "max": coinFormat(walletRx.value.maximumWithdrawal),
                                  }),
                                  maxLines: 2,
                                  textAlign: TextAlign.start),
                              vSpacer10(),
                              if (isWithdraw2FActive && !gUserRx.value.google2FaSecret.isValid)
                                textWithBackground("Google 2FA is not enabled".tr,
                                    bgColor: Colors.red.withOpacity(0.25), textColor: context.theme.primaryColor),
                            ],
                          )),
                      vSpacer20(),
                      buttonRoundedMain(text: "Withdraw".tr, onPressCallback: () => _checkInputData()),
                      vSpacer30(),
                      _historyListView(),
                      _faqView()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _networkView() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSpacer10(),
            textAutoSizeKarla(networkList.isNotEmpty ? "Select Network".tr : "Network Name".tr,
                fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
            if (networkList.isEmpty) vSpacer5(),
            if (networkList.isNotEmpty)
              dropDownNetworks(networkList, selectedNetwork.value, "Select".tr, onChange: (value) => selectedNetwork.value = value)
            else
              Container(
                height: 50,
                alignment: Alignment.centerLeft,
                width: context.width,
                padding: const EdgeInsets.all(10),
                decoration: boxDecorationRoundBorder(),
                child: textAutoSizeKarla(walletRx.value.networkName ?? "", fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
              )
          ],
        ));
  }

  Widget _historyListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textAutoSizeKarla("Recent Withdrawals".tr, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
        Obx(() => historyList.isEmpty
            ? showEmptyView(height: 50)
            : Column(
          children: List.generate(historyList.length, (index) => historyItemView(historyList[index], HistoryType.deposit)),
        ))
      ],
    );
  }

  void _checkInputData() {
    final address = _addressEditController.text.trim();
    if (address.isEmpty) {
      showToast("Address can not be empty".tr);
      return;
    }
    final amount = makeDouble(_amountEditController.text.trim());
    final minAmount = widget.wallet.minimumWithdrawal ?? 0;
    if (amount < minAmount) {
      showToast("Amount_less_then".trParams({"amount": minAmount.toString()}));
      return;
    }
    final maxAmount = widget.wallet.maximumWithdrawal ?? 0;
    if (amount > maxAmount) {
      showToast("Amount_greater_then".trParams({"amount": maxAmount.toString()}));
      return;
    }
    if (isWithdraw2FActive && !gUserRx.value.google2FaSecret.isValid) {
      showToast("Please setup your google 2FA".tr);
      return;
    }
    showModalSheetFullScreen(context, _withdrawConfirmView(address, amount));
  }

  Widget _withdrawConfirmView(String address, double amount) {
    final subTitle = "${"You will withdrawal".tr} $amount ${widget.wallet.coinType ?? ""} ${"to this address".tr} $address";
    final codeEditController = TextEditingController();
    return Column(
      children: [
        vSpacer10(),
        textAutoSizeKarla("Withdrawal Coin".tr, fontSize: Dimens.regularFontSizeLarge),
        vSpacer10(),
        textAutoSizeKarla(subTitle, maxLines: 3, fontSize: Dimens.regularFontSizeMid),
        vSpacer10(),
        if (isWithdraw2FActive) textFieldWithSuffixIcon(controller: codeEditController, hint: "Input 2FA code".tr, labelText: "2FA code".tr),
        vSpacer15(),
        buttonRoundedMain(
            text: "Withdraw".tr,
            onPressCallback: () {
              if (isWithdraw2FActive && codeEditController.text.trim().length < DefaultValue.codeLength) {
                showToast("Code length must be".trParams({"count": DefaultValue.codeLength.toString()}));
                return;
              }
              hideKeyboard(context);
              _controller.walletWithdrawal(widget.wallet, address, amount, selectedNetwork.value.networkType ?? "", codeEditController.text.trim());
            }),
        vSpacer10(),
      ],
    );
  }

  Widget _faqView() {
    return Obx(() => faqList.isEmpty
        ? vSpacer2()
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vSpacer30(),
        textAutoSizeTitle("FAQ".tr, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeMid),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: List.generate(faqList.length, (index) => faqItem(faqList[index])))
      ],
    ));
  }
}
