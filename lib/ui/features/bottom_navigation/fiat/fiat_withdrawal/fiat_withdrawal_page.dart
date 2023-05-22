import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'fiat_withdrawal_controller.dart';

class FiatWithdrawalPage extends StatefulWidget {
  const FiatWithdrawalPage({Key? key}) : super(key: key);

  @override
  FiatWithdrawalPageState createState() => FiatWithdrawalPageState();
}

class FiatWithdrawalPageState extends State<FiatWithdrawalPage> {
  final _controller = Get.put(FiatWithdrawalController());

  @override
  void initState() {
    _controller.selectedBankIndex.value = -1;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _controller.getFiatWithdrawal());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.paddingMid),
          child: Column(
            children: [
              twoTextSpace("Amount".tr, "Select Wallet".tr, color: context.theme.primaryColor),
              vSpacer5(),
              textFieldWithWidget(
                  controller: _controller.amountEditController,
                  hint: "Enter amount".tr,
                  onTextChange: _controller.onTextChanged,
                  type: TextInputType.number,
                  suffixWidget: Obx(
                    () => dropdownSuffix(
                      dropDownWallets(_controller.fiatWithdrawalResp.value.myWallet ?? [], _controller.selectedWallet.value, "Select".tr,
                          onChange: (selected) {
                        _controller.selectedWallet.value = selected;
                        _controller.getAndSetCoinRate();
                      }), width: 150
                    ),
                  )),
              vSpacer30(),
              twoTextSpace("Convert Price".tr, "Select Currency".tr, color: context.theme.primaryColor),
              vSpacer5(),
              textFieldWithWidget(
                controller: _controller.currencyEditController,
                hint: "0",
                readOnly: true,
                suffixWidget: Obx(
                    () => currencyView(context, _controller.selectedCurrency.value, _controller.fiatWithdrawalResp.value.currency ?? [], (selected) {
                          _controller.selectedCurrency.value = selected;
                          _controller.getAndSetCoinRate();
                        })),
              ),
              vSpacer5(),
              Obx(() {
                final fee = "${"Fees".tr}: ${currencyFormat(_controller.fiatWithdrawalRate.value.fees)}";
                final netAmount =
                    "${"Net Amount".tr}: ${currencyFormat(_controller.fiatWithdrawalRate.value.netAmount)} ${_controller.fiatWithdrawalRate.value.currency ?? ""}";
                return twoTextSpaceFixed(fee, netAmount, color: context.theme.primaryColor);
              }),
              vSpacer30(),
              twoTextSpace("Select Bank".tr, "", color: context.theme.primaryColor),
              vSpacer5(),
              Obx(
                () => dropDownListIndex(
                    _controller.getBankList(_controller.fiatWithdrawalResp.value), _controller.selectedBankIndex.value, "Select Bank".tr, (index) {
                  _controller.selectedBankIndex.value = index;
                }, hMargin: 0),
              ),
              vSpacer30(),
              buttonRoundedMain(text: "Submit Withdrawal".tr, onPressCallback: () => _controller.checkInputData(context))
            ],
          ),
        ),
      ),
    );
  }
}
