import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

class FiatWithdrawalController extends GetxController {
  Rx<FiatWithdrawalResp> fiatWithdrawalResp = FiatWithdrawalResp().obs;
  Rx<Wallet> selectedWallet = Wallet(id: 0).obs;
  Rx<FiatCurrency> selectedCurrency = FiatCurrency(id: 0).obs;
  Rx<FiatWithdrawalRate> fiatWithdrawalRate = FiatWithdrawalRate().obs;
  final amountEditController = TextEditingController();
  final currencyEditController = TextEditingController();
  RxBool isDataLoading = false.obs;
  RxInt selectedBankIndex = 0.obs;
  Timer? _timer;

  void getFiatWithdrawal() {
    showLoadingDialog();
    APIRepository().getFiatWithdrawal().then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        fiatWithdrawalResp.value = FiatWithdrawalResp.fromJson(resp.data);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void onTextChanged(String amount) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () {
      getAndSetCoinRate();
    });
  }

  void getAndSetCoinRate() {
    if (!selectedCurrency.value.code.isValid || !selectedWallet.value.coinType.isValid) return;
    final amount = makeDouble(amountEditController.text.trim());
    if (amount <= 0) {
      fiatWithdrawalRate.value = FiatWithdrawalRate();
      currencyEditController.text = "0";
    } else {
      APIRepository().getFiatWithdrawalRate(selectedWallet.value.encryptId!, selectedCurrency.value.code!, amount).then((resp) {
        if (resp.success) {
          fiatWithdrawalRate.value = FiatWithdrawalRate.fromJson(resp.data);
          currencyEditController.text = (fiatWithdrawalRate.value.convertAmount ?? 0).toString();
        } else {
          showToast(resp.message);
        }
      }, onError: (err) {
        showToast(err.message);
      });
    }
  }

  List<String> getBankList(FiatWithdrawalResp? fiatWithdrawal) {
    if (fiatWithdrawal?.myBank.isValid ?? false) {
      return fiatWithdrawal!.myBank!.map((e) => e.bankName ?? "").toList();
    }
    return [];
  }

  void checkInputData(BuildContext context) {
    if (!selectedWallet.value.coinType.isValid) {
      showToast("select your wallet".tr);
      return;
    }

    if (!selectedCurrency.value.code.isValid) {
      showToast("select your currency".tr);
      return;
    }

    final amount = makeDouble(amountEditController.text.trim());
    if (amount <= 0) {
      showToast("Amount_less_then".trParams({"amount": "0"}));
      return;
    }
    if (selectedBankIndex.value == -1) {
      showToast("select your bank".tr);
      return;
    }
    hideKeyboard(context);
    fiatWithdrawalProcess(amount);
  }

  void fiatWithdrawalProcess(double amount) {
    final walletId = selectedWallet.value.encryptId ?? "";
    final currency = selectedCurrency.value.code ?? "";
    final bankId = fiatWithdrawalResp.value.myBank?[selectedBankIndex.value].id ?? 0;
    showLoadingDialog();
    APIRepository().fiatWithdrawalProcess(walletId, bankId, currency, amount).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success, isLong: true);
      if (resp.success) {
        amountEditController.text = "";
        currencyEditController.text = "";
        selectedWallet.value = Wallet(id: 0);
        selectedCurrency.value = FiatCurrency(id: 0);
        fiatWithdrawalRate.value = FiatWithdrawalRate();
        selectedBankIndex.value = -1;
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }
}
