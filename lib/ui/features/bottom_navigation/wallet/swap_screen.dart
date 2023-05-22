import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/wallet/wallet_controller.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({Key? key}) : super(key: key);

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  final WalletController _controller = Get.find<WalletController>();
  TextEditingController toEditController = TextEditingController();
  TextEditingController fromEditController = TextEditingController();
  Rx<Wallet> selectedFromCoin = Wallet(id: 0).obs;
  Rx<Wallet> selectedToCoin = Wallet(id: 0).obs;
  Timer? _debounce;
  final RxDouble _rate = 0.0.obs;
  final RxDouble _convertRate = 0.0.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_controller.selectedSwapWallet != null) {
        selectedFromCoin.value = _controller.selectedSwapWallet!;
        _controller.selectedSwapWallet = null;
      } else if (_controller.walletList.isNotEmpty) {
        selectedFromCoin.value = _controller.walletList.first;
      }
      if (_controller.walletList.length > 1) selectedToCoin.value = _controller.walletList[1];
      fromEditController.text = 1.toString();
      _getAndSetCoinRate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Obx(() {
      return ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Dimens.paddingMid),
        children: [
          Align(alignment: Alignment.centerLeft, child: textAutoSizeTitle('Swap Coin'.tr)),
          vSpacer20(),
          twoTextSpace(
              "From".tr, "${"Available".tr} ${coinFormat(selectedFromCoin.value.availableBalance)} ${selectedFromCoin.value.coinType ?? ""}"),
          vSpacer5(),
          textFieldWithWidget(
              controller: fromEditController,
              type: TextInputType.number,
              onTextChange: _onTextChanged,
              suffixWidget: dropdownSuffix(dropDownWallets(_controller.walletList, selectedFromCoin.value, "Select".tr, onChange: (selected) {
                selectedFromCoin.value = selected;
                _getAndSetCoinRate();
              }), width: 125)
          ),
          vSpacer10(),
          buttonOnlyIcon(iconData: Icons.swap_vert_circle_outlined, size: Dimens.iconSizeMid, onPressCallback: () => _swapCoinSelectView()),
          vSpacer10(),
          twoTextSpace("To".tr, "${"Available".tr} ${coinFormat(selectedToCoin.value.availableBalance)} ${selectedToCoin.value.coinType ?? ""}"),
          vSpacer5(),
          textFieldWithWidget(
              controller: toEditController,
              readOnly: true,
              suffixWidget: dropdownSuffix(dropDownWallets(_controller.walletList, selectedToCoin.value, "Select".tr, onChange: (selected) {
                selectedToCoin.value = selected;
                _getAndSetCoinRate();
              }), width: 125)),
          _coinRateView(),
          vSpacer20(),
          buttonRoundedMain(text: "Convert".tr, onPressCallback: () => _checkInputData())
        ],
      );
    }));
  }

  void _swapCoinSelectView() {
    final fromCoin = selectedFromCoin.value;
    final toCoin = selectedToCoin.value;
    selectedToCoin.value = fromCoin;
    selectedFromCoin.value = toCoin;
    _getAndSetCoinRate();
  }

  Widget _coinRateView() {
    return Obx(() => Column(children: [
          vSpacer10(),
          twoTextSpace("Price".tr, "1 ${selectedFromCoin.value.coinType ?? ""} = ${_rate.value} ${selectedToCoin.value.coinType ?? ""}"),
          twoTextSpace("You will spend".tr, "${_convertRate.value} ${selectedToCoin.value.coinType ?? ""}",
              subColor: context.theme.colorScheme.secondary),
          vSpacer10(),
        ]));
  }

  void _onTextChanged(String amount) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      _getAndSetCoinRate();
    });
  }

  void _getAndSetCoinRate() {
    String amount = fromEditController.text.trim();
    if (amount.isEmpty || amount == "0") {
      _rate.value = 0;
      _convertRate.value = 0;
      toEditController.text = _convertRate.value.toString();
      return;
    }

    if (selectedFromCoin.value.id != 0 && selectedToCoin.value.id != 0) {
      _controller.getCoinRate(amount, selectedFromCoin.value.id, selectedToCoin.value.id, (rate, covertRate) {
        _rate.value = rate;
        _convertRate.value = covertRate;
        toEditController.text = _convertRate.value.toString();
      });
    }
  }

  void _checkInputData() {
    var amount = makeDouble(fromEditController.text.trim());
    if (amount <= 0) {
      showToast("Invalid amount".tr);
      return;
    }
    final subTitle =
        "${"You will swap".tr} $amount ${selectedFromCoin.value.coinType ?? ""} ${"To".tr.toLowerCase()} ${selectedToCoin.value.coinType ?? ""}";
    alertForAction(context,
        title: "Swap Coin".tr,
        subTitle: subTitle,
        buttonTitle: "Convert".tr,
        onOkAction: () => _controller.swapCoinProcess(selectedFromCoin.value.id, selectedToCoin.value.id, amount));
  }
}
