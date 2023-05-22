import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/data/remote/socket_provider.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/language_util.dart';
import '../local/api_constants.dart';
import '../models/response.dart';
import '../models/user.dart';
import 'api_provider.dart';

class APIRepository {
  final provider = Get.find<APIProvider>();
  final socketProvider = Get.find<SocketProvider>();

  Map<String, String> authHeader() {
    String? token = GetStorage().read(PreferenceKey.accessToken);
    String? type = GetStorage().read(PreferenceKey.accessType);
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.accept] = APIKeyConstants.vAccept;
    mapObj[APIKeyConstants.userApiSecret] = dotenv.env[EnvKeyValue.kApiSecret] ?? "";
    mapObj[APIKeyConstants.lang] = LanguageUtil.getCurrentKey();
    mapObj[APIKeyConstants.userAgent] = gUserAgent;
    if (token != null && token.isNotEmpty) {
      mapObj[APIKeyConstants.authorization] = "${type ?? APIKeyConstants.vBearer} $token";
    }
    //printFunction("authHeader", mapObj[APIKeyConstants.authorization]);
    return mapObj;
  }

  /// *** POST requests *** ///

  Future<ServerResponse> registerUser(String firstName, String lastName, String email, String password) async {
    var mapObj = {};
    mapObj[APIKeyConstants.firstName] = firstName;
    mapObj[APIKeyConstants.lastName] = lastName;
    mapObj[APIKeyConstants.email] = email;
    mapObj[APIKeyConstants.password] = password;
    mapObj[APIKeyConstants.confirmPassword] = password;
    mapObj[APIKeyConstants.recaptcha] = "noReCAPTCHA";
    return provider.postRequest(APIURLConstants.signUp, mapObj, authHeader());
  }

  Future<ServerResponse> verifyEmail(String email, String code) async {
    var mapObj = {};
    mapObj[APIKeyConstants.email] = email;
    mapObj[APIKeyConstants.verifyCode] = code;
    return provider.postRequest(APIURLConstants.verifyEmail, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> loginUser(String email, String password) async {
    var mapObj = {};
    mapObj[APIKeyConstants.email] = email;
    mapObj[APIKeyConstants.password] = password;
    //mapObj[APIKeyConstants.recaptcha] = "noReCAPTCHA";
    return provider.postRequest(APIURLConstants.signIn, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> verify2FACodeLogin(String code, int userId) async {
    var mapObj = {};
    mapObj[APIKeyConstants.code] = code;
    mapObj[APIKeyConstants.userId] = userId;
    return provider.postRequest(APIURLConstants.g2FAVerify, mapObj, authHeader());
  }

  Future<ServerResponse> forgetPassword(String email) async {
    var mapObj = {};
    mapObj[APIKeyConstants.email] = email;
    mapObj[APIKeyConstants.recaptcha] = "noReCAPTCHA";
    return provider.postRequest(APIURLConstants.forgotPassword, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> resetPassword(String email, String code, String password) async {
    var mapObj = {};
    mapObj[APIKeyConstants.email] = email;
    mapObj[APIKeyConstants.token] = code;
    mapObj[APIKeyConstants.password] = password;
    mapObj[APIKeyConstants.confirmPassword] = password;
    return provider.postRequest(APIURLConstants.resetPassword, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> changePassword(String currentPass, String newPass, String confirmPass) async {
    var mapObj = {};
    mapObj[APIKeyConstants.oldPassword] = currentPass;
    mapObj[APIKeyConstants.password] = newPass;
    mapObj[APIKeyConstants.confirmPassword] = confirmPass;
    return provider.postRequest(APIURLConstants.changePassword, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> logoutUser() async {
    return provider.postRequest(APIURLConstants.logoutApp, {}, authHeader());
  }

  Future<ServerResponse> walletNetworkAddress(int walletId, String networkType) async {
    var mapObj = {};
    mapObj[APIKeyConstants.walletId] = walletId.toString();
    mapObj[APIKeyConstants.networkType] = networkType;
    return provider.postRequest(APIURLConstants.walletNetworkAddress, mapObj, authHeader());
  }

  Future<ServerResponse> withdrawProcess(int walletId, String address, double amount, String networkType, String code) async {
    var mapObj = {};
    mapObj[APIKeyConstants.walletId] = walletId;
    mapObj[APIKeyConstants.address] = address;
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.code] = code;
    mapObj[APIKeyConstants.networkType] = networkType;
    return provider.postRequest(APIURLConstants.walletWithdrawalProcess, mapObj, authHeader());
  }

  Future<ServerResponse> swapCoinProcess(int fromCoinId, int toCoinId, double amount) async {
    var mapObj = {};
    mapObj[APIKeyConstants.fromCoinId] = fromCoinId;
    mapObj[APIKeyConstants.toCoinId] = toCoinId;
    mapObj[APIKeyConstants.amount] = amount;
    return provider.postRequest(APIURLConstants.swapCoinApp, mapObj, authHeader());
  }

  Future<ServerResponse> updateProfile(User user, File imageFile) async {
    var mapObj = <String, dynamic>{};
    mapObj[APIKeyConstants.firstName] = user.firstName;
    mapObj[APIKeyConstants.lastName] = user.lastName;
    mapObj[APIKeyConstants.phone] = user.phone;
    mapObj[APIKeyConstants.country] = user.country;
    mapObj[APIKeyConstants.gender] = user.gender;

    if (imageFile.path.isNotEmpty) {
      mapObj[APIKeyConstants.photo] = await makeMultipartFile(imageFile);
    }
    return provider.postRequestFormData(APIURLConstants.updateProfile, mapObj, authHeader());
  }

  Future<ServerResponse> sendPhoneSMS() async {
    return provider.postRequest(APIURLConstants.sendPhoneVerificationSms, {}, authHeader());
  }

  Future<ServerResponse> verifyPhone(String code) async {
    return provider.postRequest(APIURLConstants.phoneVerify, {APIKeyConstants.verifyCode: code}, authHeader());
  }

  Future<MultipartFile> makeMultipartFile(File file) async {
    List<int> arrayData = await file.readAsBytes();
    MultipartFile multipartFile = MultipartFile(arrayData, filename: file.path);
    return multipartFile;
  }

  Future<ServerResponse> setupGoogleSecret(String code, String secret, bool isAdd) async {
    var mapObj = {};
    mapObj[APIKeyConstants.code] = code;
    mapObj[APIKeyConstants.setup] = isAdd ? "add" : "remove";
    mapObj[APIKeyConstants.google2faSecret] = secret;
    return provider.postRequest(APIURLConstants.google2faSetup, mapObj, authHeader());
  }

  Future<ServerResponse> updateCurrency(String code) async {
    var mapObj = {};
    mapObj[APIKeyConstants.code] = code;
    return provider.postRequest(APIURLConstants.updateCurrency, mapObj, authHeader());
  }

  Future<ServerResponse> updateLanguage(String language) async {
    var mapObj = {};
    mapObj[APIKeyConstants.language] = language;
    return provider.postRequest(APIURLConstants.languageSetup, mapObj, authHeader());
  }

  Future<ServerResponse> thirdPartyKycVerified(String inquiryId) async {
    var mapObj = {};
    mapObj[APIKeyConstants.inquiryId] = inquiryId;
    return provider.postRequest(APIURLConstants.thirdPartyKycVerified, mapObj, authHeader());
  }

  Future<ServerResponse> uploadIdVerificationFiles(IdVerificationType type, File frontFile, File backFile, File selfieFile) async {
    var mapObj = <String, dynamic>{};
    if (frontFile.path.isNotEmpty) {
      mapObj[APIKeyConstants.fileTwo] = await makeMultipartFile(frontFile);
    }
    if (backFile.path.isNotEmpty) {
      mapObj[APIKeyConstants.fileThree] = await makeMultipartFile(backFile);
    }
    if (selfieFile.path.isNotEmpty) {
      mapObj[APIKeyConstants.fileSelfie] = await makeMultipartFile(selfieFile);
    }
    String url = "";
    switch (type) {
      case IdVerificationType.none:
        break;
      case IdVerificationType.nid:
        url = APIURLConstants.uploadNID;
        break;
      case IdVerificationType.passport:
        url = APIURLConstants.uploadPassport;
        break;
      case IdVerificationType.driving:
        url = APIURLConstants.uploadDrivingLicence;
        break;
      case IdVerificationType.voter:
        url = APIURLConstants.uploadVoterCard;
        break;
    }
    return provider.postRequestFormData(url, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> updateNotificationStatus(List<int> ids) async {
    var mapObj = {};
    mapObj[APIKeyConstants.ids] = ids;
    return provider.postRequest(APIURLConstants.notificationSeen, mapObj, authHeader());
  }

  Future<ServerResponse> placeOrderLimit(bool isBuy, int baseCoinId, int tradeCoinId, double price, double amount) async {
    var mapObj = {};
    mapObj[APIKeyConstants.price] = price;
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId;
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId;
    final url = isBuy ? APIURLConstants.buyLimitApp : APIURLConstants.sellLimitApp;
    return provider.postRequest(url, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> placeOrderMarket(bool isBuy, int baseCoinId, int tradeCoinId, double price, double amount) async {
    var mapObj = {};
    mapObj[APIKeyConstants.price] = price;
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId;
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId;
    final url = isBuy ? APIURLConstants.buyMarketApp : APIURLConstants.sellMarketApp;
    return provider.postRequest(url, mapObj, authHeader());
  }

  Future<ServerResponse> placeOrderStopMarket(bool isBuy, int baseCoinId, int tradeCoinId, double amount, double limit, double stop) async {
    var mapObj = {};
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.limit] = limit;
    mapObj[APIKeyConstants.stop] = stop;
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId;
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId;
    final url = isBuy ? APIURLConstants.buyStopLimitApp : APIURLConstants.sellStopLimitApp;
    return provider.postRequest(url, mapObj, authHeader());
  }

  Future<ServerResponse> cancelOpenOrderApp(String type, int id) async {
    var mapObj = {};
    mapObj[APIKeyConstants.type] = type;
    mapObj[APIKeyConstants.id] = id;
    return provider.postRequest(APIURLConstants.cancelOpenOrderApp, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> getCurrencyDepositRate(int walletId, int paymentMethodId, double amount,
      {String? currency, String? code, int? bankId, int? walletIdFrom}) async {
    var mapObj = {};
    mapObj[APIKeyConstants.walletId] = walletId;
    mapObj[APIKeyConstants.paymentMethodId] = paymentMethodId;
    mapObj[APIKeyConstants.amount] = amount;

    if (currency.isValid) mapObj[APIKeyConstants.currency] = currency;
    if (code.isValid) mapObj[APIKeyConstants.code] = code;
    if (bankId != null) mapObj[APIKeyConstants.bankId] = bankId;
    if (walletIdFrom != null) mapObj[APIKeyConstants.fromWalletId] = walletIdFrom;
    return provider.postRequest(APIURLConstants.currencyDepositRate, mapObj, authHeader());
  }

  Future<ServerResponse> getFiatWithdrawalRate(String walletId, String currency, double amount) async {
    var mapObj = {};
    mapObj[APIKeyConstants.walletId] = walletId;
    mapObj[APIKeyConstants.currency] = currency;
    mapObj[APIKeyConstants.amount] = amount;
    return provider.postRequest(APIURLConstants.getFiatWithdrawalRate, mapObj, authHeader());
  }

  Future<ServerResponse> currencyDepositProcess(int walletId, int paymentMethodId, double amount,
      {String? currency, int? bankId, File? file, int? walletIdFrom, String? stripeToken, String? paypalToken, String? code}) async {
    final mapObj = <String, dynamic>{};
    mapObj[APIKeyConstants.walletId] = walletId;
    mapObj[APIKeyConstants.paymentMethodId] = paymentMethodId;
    mapObj[APIKeyConstants.amount] = amount;
    if (currency.isValid) mapObj[APIKeyConstants.currency] = currency;
    if (bankId != null) {
      mapObj[APIKeyConstants.bankId] = bankId;
      if (file != null) mapObj[APIKeyConstants.bankReceipt] = await makeMultipartFile(file);
    }
    if (walletIdFrom != null) mapObj[APIKeyConstants.fromWalletId] = walletIdFrom;
    if (stripeToken.isValid) mapObj[APIKeyConstants.stripeToken] = stripeToken;
    if (paypalToken.isValid) mapObj[APIKeyConstants.paypalToken] = paypalToken;
    if (code.isValid) mapObj[APIKeyConstants.code] = code;

    return provider.postRequestFormData(APIURLConstants.currencyDepositProcess, mapObj, authHeader());
  }

  Future<ServerResponse> userBankSave(Bank bank) async {
    var mapObj = bank.toJson();
    return provider.postRequest(APIURLConstants.userBankSave, mapObj, authHeader());
  }

  Future<ServerResponse> userBankDelete(int id) async {
    return provider.postRequest(APIURLConstants.userBankDelete, {APIKeyConstants.id: id}, authHeader());
  }

  Future<ServerResponse> fiatWithdrawalProcess(String walletId, int bankId, String currency, double amount) async {
    var mapObj = {};
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.walletId] = walletId;
    mapObj[APIKeyConstants.bankId] = bankId;
    mapObj[APIKeyConstants.currency] = currency;
    mapObj[APIKeyConstants.type] = "fiat";
    return provider.postRequest(APIURLConstants.fiatWithdrawalProcess, mapObj, authHeader());
  }

  /// *** ------------ *** ///
  /// *** GET requests *** ///
  /// *** ------------ *** ///

  Future<ServerResponse> getDashBoardData(String key) async {
    return provider.getRequest(APIURLConstants.getAppDashboard + key, authHeader());
  }

  Future<ServerResponse> getExchangeChartDataApp(int baseCoinId, int tradeCoinId, int interval) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.interval] = interval.toString();
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId.toString();
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId.toString();
    return provider.getRequest(APIURLConstants.getExchangeChartDataApp, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getExchangeOrderList(String orderType, int baseCoinId, int tradeCoinId) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.dashboardType] = "dashboard";
    mapObj[APIKeyConstants.orderType] = orderType;
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId.toString();
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId.toString();
    return provider.getRequest(APIURLConstants.getExchangeAllOrdersApp, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getExchangeTradeList(int baseCoinId, int tradeCoinId) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.dashboardType] = "dashboard";
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId.toString();
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId.toString();
    return provider.getRequest(APIURLConstants.getExchangeMarketTradesApp, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getTradeHistoryList(int baseCoinId, int tradeCoinId, String orderType) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.dashboardType] = "dashboard";
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId.toString();
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId.toString();
    if (orderType != FromKey.trade) mapObj[APIKeyConstants.orderType] = orderType;
    final url = orderType == FromKey.trade ? APIURLConstants.getMyTradesApp : APIURLConstants.getMyAllOrdersApp;
    return provider.getRequest(url, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getSelfProfile() async {
    return provider.getRequest(APIURLConstants.getProfile, authHeader());
  }

  Future<ServerResponse> getKYCDetails() async {
    return provider.getRequest(APIURLConstants.getKYCDetails, authHeader());
  }

  Future<ServerResponse> getUserKYCSettingsDetails() async {
    return provider.getRequest(APIURLConstants.getUserKYCSettingsDetails, authHeader());
  }

  Future<ServerResponse> getUserSetting() async {
    return provider.getRequest(APIURLConstants.getUserSetting, authHeader());
  }

  Future<ServerResponse> getUserActivityList() async {
    return provider.getRequest(APIURLConstants.getActivityList, authHeader());
  }

  Future<ServerResponse> getCommonSettings() async {
    return provider.getRequest(APIURLConstants.getCommonSettings, authHeader());
  }

  Future<ServerResponse> getWalletList(int page) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = "$page";
    mapObj[APIKeyConstants.limit] = DefaultValue.listLimitLarge.toString();
    return provider.getRequest(APIURLConstants.getWalletList, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getWalletDeposit(int id) async {
    return provider.getRequest(APIURLConstants.getWalletDeposit + id.toString(), authHeader(), isDynamic: true);
  }

  Future<ServerResponse> getWalletWithdrawal(int id) async {
    return provider.getRequest(APIURLConstants.getWalletWithdrawal + id.toString(), authHeader(), isDynamic: true);
  }

  Future<ServerResponse> getActivityList(int page, String type) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = "$page";
    mapObj[APIKeyConstants.perPage] = DefaultValue.listLimitMedium.toString();
    if (type != HistoryType.stopLimit) {
      mapObj[APIKeyConstants.type] = type;
    }
    mapObj[APIKeyConstants.columnName] = type == HistoryType.transaction ? APIKeyConstants.time : APIKeyConstants.createdAt;
    mapObj[APIKeyConstants.orderBy] = APIKeyConstants.vOrderDESC;

    var url = APIURLConstants.getWalletHistoryApp;
    if (type == HistoryType.swap) {
      url = APIURLConstants.getCoinConvertHistoryApp;
    } else if (type == HistoryType.buyOrder) {
      url = APIURLConstants.getAllBuyOrdersHistoryApp;
    } else if (type == HistoryType.sellOrder) {
      url = APIURLConstants.getAllSellOrdersHistoryApp;
    } else if (type == HistoryType.transaction) {
      url = APIURLConstants.getAllTransactionHistoryApp;
    } else if (type == HistoryType.fiatDeposit) {
      url = APIURLConstants.getCurrencyDepositHistory;
    } else if (type == HistoryType.fiatWithdrawal) {
      url = APIURLConstants.getFiatWithdrawalHistory;
    } else if (type == HistoryType.stopLimit) {
      url = APIURLConstants.getAllStopLimitOrdersApp;
    } else if (type == HistoryType.refEarningTrade || type == HistoryType.refEarningWithdrawal) {
      mapObj[APIKeyConstants.type] = (type == HistoryType.refEarningTrade ? 2 : 1).toString();
      url = APIURLConstants.getReferralHistory;
    }
    return provider.getRequest(url, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getCoinRate(String amount, int fromId, int toId) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.fromCoinId] = fromId.toString();
    mapObj[APIKeyConstants.toCoinId] = toId.toString();
    return provider.getRequest(APIURLConstants.getRateApp, authHeader(), query: mapObj, isDynamic: true);
  }

  Future<ServerResponse> twoFALoginEnableDisable() async {
    return provider.getRequest(APIURLConstants.getSetupGoogle2faLogin, authHeader());
  }

  Future<ServerResponse> getFAQList(int page, {int? type}) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = "$page";
    mapObj[APIKeyConstants.perPage] = DefaultValue.listLimitLarge.toString();
    if (type != null) {
      mapObj[APIKeyConstants.faqTypeId] = type.toString();
    }
    return provider.getRequest(APIURLConstants.getFaqList, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getNotifications() async {
    return provider.getRequest(APIURLConstants.getNotifications, authHeader());
  }

  Future<ServerResponse> getReferralApp() async {
    return provider.getRequest(APIURLConstants.getReferralApp, authHeader());
  }

  Future<ServerResponse> getCurrencyDepositData() async {
    return provider.getRequest(APIURLConstants.getCurrencyDeposit, authHeader());
  }

  Future<ServerResponse> getFiatWithdrawal() async {
    return provider.getRequest(APIURLConstants.getFiatWithdrawal, authHeader());
  }

  Future<ServerResponse> getUserBankList() async {
    return provider.getRequest(APIURLConstants.getUserBankList, authHeader());
  }

  /// *** ---------------- *** ///
  /// *** SOCKET requests *** ///
  /// *** -------------- *** ///
  void subscribeEvent(String channel, SocketListener listener) {
    socketProvider.subscribeEvent(channel, listener);
  }

  void unSubscribeEvent(String channel, SocketListener? listener) {
    socketProvider.unSubscribeEvent(channel, listener);
  }

  void unSubscribeAllChannels() {
    socketProvider.unSubscribeAllChannel();
  }

  /// *** ---------------- *** ///
  /// *** Others requests *** ///
  /// *** -------------- *** ///
// Future<ServerResponse> getMarketPrice(String currency, List<String> idList) async {
//   var mapObj = <String, dynamic>{};
//   mapObj["fsyms"] = idList;
//   mapObj["tsyms"] = currency;
//   return provider.getRequestWithFullUrl(URLConstants.cryptoComparePriceFull, query: mapObj);
// }
//
// Future<ServerResponse> getNetworkInfo() async {
//   return provider.getRequestWithFullUrl(URLConstants.networkInfo);
// }
}
