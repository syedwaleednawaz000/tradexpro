import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/faq.dart';
import 'package:tradexpro_flutter/data/models/history.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/wallet/wallet_controller.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/dimens.dart';
import '../../../../utils/image_util.dart';
import '../../../../utils/number_util.dart';
import '../../../../utils/spacers.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({Key? key, required this.wallet}) : super(key: key);
  final Wallet wallet;

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final WalletController _controller = Get.find<WalletController>();
  Rx<Wallet> walletRx = Wallet(id: 0).obs;
  RxString selectedAddress = "".obs;
  RxList<Network> networkList = <Network>[].obs;
  Rx<Network> selectedNetwork = Network(id: 0).obs;
  RxList<History> historyList = <History>[].obs;
  RxList<FAQ> faqList = <FAQ>[].obs;

  @override
  void initState() {
    walletRx.value = widget.wallet;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _controller.getWalletDeposit(widget.wallet.id, (value) {
          if (value.wallet != null) walletRx.value = value.wallet!;
          if (value.address.isValid) selectedAddress.value = value.address!;
          if (value.data != null) networkList.value = value.data!;
          if (selectedAddress.value.isEmpty && networkList.isNotEmpty) {
            final net = networkList.firstWhereOrNull((element) => element.id == walletRx.value.network);
            if (net != null) selectedNetwork.value = net;
            selectedAddress.value = selectedNetwork.value.address ?? "";
          }
          _controller.getHistoryListData(HistoryType.deposit, (list) => historyList.value = list);
          _controller.getFAQList(FAQType.deposit, (list) => faqList.value = list);
        }));
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
              appBarBackWithActions(title: "Deposit".tr),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(Dimens.paddingMid),
                  children: [
                    vSpacer10(),
                    walletTopView(walletRx.value),
                    vSpacer10(),
                    Obx(() => twoTextSpaceBackground("Balance".tr, coinFormat(walletRx.value.balance), textColor: context.theme.primaryColor)),
                    vSpacer10(),
                    Container(
                      padding: const EdgeInsets.all(Dimens.paddingMid),
                      decoration: boxDecorationRoundCorner(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              textAutoSizeKarla("Warning".tr, fontSize: Dimens.regularFontSizeMid, color: Colors.red),
                              hSpacer10(),
                              showImageAsset(icon: Icons.warning_outlined, width: Dimens.iconSizeMin, height: Dimens.iconSizeMin, color: Colors.red)
                            ],
                          ),
                          vSpacer10(),
                          textAutoSizePoppins("Sending_any_other_asset_message".trParams({"coinName": walletRx.value.coinType ?? ""}),
                              textAlign: TextAlign.start, maxLines: 5, color: Colors.red),
                          _networkView(),
                          vSpacer20(),
                          _addressView(),
                          vSpacer10(),
                        ],
                      ),
                    ),
                    vSpacer20(),
                    _historyListView(),
                    _faqView()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget _networkView() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSpacer10(),
            textAutoSizeKarla(networkList.isNotEmpty ? "Select Network".tr : "Network Name".tr,
                fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
            vSpacer5(),
            if (networkList.isNotEmpty)
              dropDownNetworks(networkList, selectedNetwork.value, "Select".tr, onChange: (value) {
                selectedNetwork.value = value;
                selectedAddress.value = selectedNetwork.value.address ?? "";
              })
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

  Widget _addressView() {
    return Obx(() => Container(
          width: context.width,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: boxDecorationRoundBorder(),
          child: selectedAddress.value.isNotEmpty
              ? Column(
                  children: [
                    qrView(selectedAddress.value),
                    vSpacer20(),
                    textWithCopyButton(selectedAddress.value),
                  ],
                )
              : Column(
                  children: [
                    textAutoSizePoppins("Address not found".tr, fontSize: Dimens.regularFontSizeMid),
                    if (selectedNetwork.value.id != 0) vSpacer20(),
                    if (selectedNetwork.value.id != 0)
                      buttonRoundedMain(
                          text: "Get Address".tr,
                          onPressCallback: () {
                            _controller.walletNetworkAddress(selectedNetwork.value, (address) {
                              selectedNetwork.value.address = address;
                              selectedAddress.value = address ?? "";
                            });
                          }),
                  ],
                ),
        ));
  }

  Widget _historyListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textAutoSizeKarla("Recent Deposits".tr, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
        Obx(() => historyList.isEmpty
            ? showEmptyView(height: 50)
            : Column(
                children: List.generate(historyList.length, (index) => historyItemView(historyList[index], HistoryType.deposit)),
              ))
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
