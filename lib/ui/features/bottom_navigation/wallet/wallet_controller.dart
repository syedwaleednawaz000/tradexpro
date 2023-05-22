import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/faq.dart';
import 'package:tradexpro_flutter/data/models/history.dart';
import 'package:tradexpro_flutter/data/models/response.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/data/models/list_response.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';

class WalletController extends GetxController with GetSingleTickerProviderStateMixin {
  int loadedPage = 0;
  bool hasMoreData = true;
  RxList<Wallet> walletList = <Wallet>[].obs;
  RxDouble totalBalance = 0.0.obs;
  final refreshController = EasyRefreshController(controlFinishRefresh: true);
  Wallet? selectedSwapWallet;
  List<CoinPair> coinPairs = [];

  Future<void> getWalletList({bool isFromLoadMore = false}) async {
    if (gUserRx.value.id == 0) {
      refreshController.finishRefresh();
      return;
    }
    if (!isFromLoadMore) {
      loadedPage = 0;
      hasMoreData = true;
      walletList.clear();
    }
    loadedPage++;
    APIRepository().getWalletList(loadedPage).then((resp) {
      refreshController.finishRefresh();
      if (resp.success) {
        totalBalance.value = makeDouble(resp.data[APIKeyConstants.total]);
        totalBalance.refresh();
        final wallets = resp.data[APIKeyConstants.wallets];
        if (wallets != null) {
          ListResponse response = ListResponse.fromJson(wallets);
          loadedPage = response.currentPage ?? 0;
          hasMoreData = response.nextPageUrl != null;
          if (response.data != null) {
            List<Wallet> list = List<Wallet>.from(response.data!.map((x) => Wallet.fromJson(x)));
            walletList.addAll(list);
            walletList.refresh();
          }
        }
      } else {
        showToast(resp.message);
      }
      getDashBoardData();
    }, onError: (err) {
      refreshController.finishRefresh();
      showToast(err.toString());
    });
  }

  void getDashBoardData() async {
    if (coinPairs.isNotEmpty) return;
    APIRepository().getDashBoardData("").then((resp) {
      if (resp.success) {
        final dashboardData = DashboardData.fromJson(resp.data);
        coinPairs = dashboardData.coinPairs ?? [];
      }
    }, onError: (err) {});
  }

  List<String> getCoinPairList(String text) {
    final pairList = coinPairs.where((element) => (element.coinPairName ?? "").toLowerCase().contains(text.toLowerCase())).toList();
    return pairList.map((e) => e.coinPairName ?? "").toList();
  }

  Future<void> getWalletDeposit(int id, Function(WalletDeposit) onGetDeposit) async {
    showLoadingDialog();
    APIRepository().getWalletDeposit(id).then((resp) {
      hideLoadingDialog();
      if (resp.success && resp.data != null) {
        final walletDeposit = WalletDeposit.fromJson(resp.data);
        if (walletDeposit.success ?? false) {
          onGetDeposit(walletDeposit);
        } else {
          showToast(walletDeposit.message ?? "");
        }
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  Future<void> walletNetworkAddress(Network network, Function(String?) onAddress) async {
    showLoadingDialog();
    APIRepository().walletNetworkAddress(network.walletId ?? 0, network.networkType ?? "").then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) {
        final address = resp.data[APIKeyConstants.address] as String?;
        onAddress(address);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  Future<void> getWalletWithdrawal(Wallet wallet, Function(Wallet, List<Network>) onWallet) async {
    showLoadingDialog();
    APIRepository().getWalletWithdrawal(wallet.id).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.success] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        if (success) {
          final newWallet = Wallet.fromJson(resp.data[APIKeyConstants.wallet]);
          wallet.balance = newWallet.balance;
          wallet.availableBalance = newWallet.availableBalance;
          wallet.minimumWithdrawal = newWallet.minimumWithdrawal;
          wallet.maximumWithdrawal = newWallet.maximumWithdrawal;
          wallet.withdrawalFees = newWallet.withdrawalFees;
          wallet.withdrawalFeesType = newWallet.withdrawalFeesType;
          wallet.network = newWallet.network;
          wallet.networkName = newWallet.networkName;
          List<Network> list = [];
          final dataList = resp.data[APIKeyConstants.data];
          if (dataList != null) {
            list = List<Network>.from(dataList.map((x) => Network.fromJson(x)));
          }
          onWallet(wallet, list);
        } else {
          showToast(message);
        }
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  Future<void> walletWithdrawal(Wallet wallet, String address, double amount, String networkType, String code) async {
    showLoadingDialog();
    APIRepository().withdrawProcess(wallet.id, address, amount, networkType, code).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) Get.back();
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  Future<void> getCoinRate(String amount, int fromId, int toId, Function(double, double) onRate) async {
    APIRepository().getCoinRate(amount, fromId, toId).then((resp) {
      if (resp.success) {
        final success = resp.data[APIKeyConstants.success] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        if (success) {
          final rate = makeDouble(resp.data[APIKeyConstants.rate]);
          final convertRate = makeDouble(resp.data[APIKeyConstants.convertRate]);
          onRate(rate, convertRate);
        } else {
          showToast(message);
        }
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  Future<void> swapCoinProcess(int fromCoinId, int toCoinId, double amount) async {
    showLoadingDialog();
    APIRepository().swapCoinProcess(fromCoinId, toCoinId, amount).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.success] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        showToast(message, isError: !success);
        if (success) Get.back();
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  Future<void> getHistoryListData(String type, Function(List<History>) onGetHistory) async {
    APIRepository().getActivityList(0, type).then((resp) {
      if (resp.success) {
        final historyResponse = HistoryResponse.fromJson(resp.data);
        final listResponse = historyResponse.histories;
        if (listResponse != null) {
          final list = List<History>.from(listResponse.data!.map((x) => History.fromJson(x)));
          onGetHistory(list);
        }
      }
    }, onError: (err) {});
  }

  Future<void> getFAQList(int type, Function(List<FAQ>) onList) async {
    APIRepository().getFAQList(1, type: type).then((resp) {
      if (resp.success) {
        ListResponse response = ListResponse.fromJson(resp.data);
        if (response.data != null) {
          List<FAQ> list = List<FAQ>.from(response.data!.map((x) => FAQ.fromJson(x)));
          onList(list);
        }
      }
    }, onError: (err) {});
  }
}
