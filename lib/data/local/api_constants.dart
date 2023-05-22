

class APIURLConstants {
  static const baseUrl = "https://tradexpro-laravel.cdibrandstudio.com";

  ///End Urls : POST
  static const signIn = "/api/sign-in";
  static const signUp = "/api/sign-up";
  static const verifyEmail = "/api/verify-email";
  static const g2FAVerify = "/api/g2f-verify";
  static const forgotPassword = "/api/forgot-password";
  static const resetPassword = "/api/reset-password";
  static const changePassword = "/api/change-password";
  static const logoutApp = "/api/log-out-app";
  static const walletNetworkAddress = "/api/get-wallet-network-address";
  static const walletWithdrawalProcess = "/api/wallet-withdrawal-process";
  static const swapCoinApp = "/api/swap-coin-app";
  static const updateProfile = "/api/update-profile";
  static const sendPhoneVerificationSms = "/api/send-phone-verification-sms";
  static const phoneVerify = "/api/phone-verify";
  static const google2faSetup = "/api/google2fa-setup";
  static const updateCurrency = "/api/update-currency";
  static const languageSetup = "/api/language-setup";
  static const uploadNID = "/api/upload-nid";
  static const uploadPassport = "/api/upload-passport";
  static const uploadDrivingLicence = "/api/upload-driving-licence";
  static const uploadVoterCard = "/api/upload-voter-card";
  static const notificationSeen = "/api/notification-seen";
  static const sellLimitApp = "/api/sell-limit-app";
  static const buyLimitApp = "/api/buy-limit-app";
  static const buyMarketApp = "/api/buy-market-app";
  static const sellMarketApp = "/api/sell-market-app";
  static const sellStopLimitApp = "/api/sell-stop-limit-app";
  static const buyStopLimitApp = "/api/buy-stop-limit-app";
  static const cancelOpenOrderApp = "/api/cancel-open-order-app";
  static const currencyDepositRate = "/api/get-currency-deposit-rate";
  static const currencyDepositProcess = "/api/currency-deposit-process";
  static const getFiatWithdrawalRate = "/api/get-fiat-withdrawal-rate";
  static const userBankSave = "/api/user-bank-save";
  static const userBankDelete = "/api/user-bank-delete";
  static const fiatWithdrawalProcess = "/api/fiat-withdrawal-process";
  static const thirdPartyKycVerified = "/api/third-party-kyc-verified";

  ///End Urls : GET
  static const getAppDashboard = "/api/app-dashboard/";
  static const getExchangeChartDataApp = "/api/get-exchange-chart-data-app";
  static const getExchangeAllOrdersApp = "/api/get-exchange-all-orders-app";
  static const getExchangeMarketTradesApp = "/api/get-exchange-market-trades-app";
  static const getMyAllOrdersApp = "/api/get-my-all-orders-app";
  static const getMyTradesApp = "/api/get-my-trades-app";
  static const getProfile = "/api/profile";
  static const getWalletList = "/api/wallet-list";
  static const getWalletDeposit = "/api/wallet-deposit-";
  static const getWalletWithdrawal = "/api/wallet-withdrawal-";
  static const getCommonSettings = "/api/common-settings";
  static const getWalletHistoryApp = "/api/wallet-history-app";
  static const getCoinConvertHistoryApp = "/api/coin-convert-history-app";
  static const getAllBuyOrdersHistoryApp = "/api/all-buy-orders-history-app";
  static const getAllSellOrdersHistoryApp = "/api/all-sell-orders-history-app";
  static const getAllTransactionHistoryApp = "/api/all-transaction-history-app";
  static const getCurrencyDepositHistory = "/api/currency-deposit-history";
  static const getFiatWithdrawalHistory = "/api/fiat-withdrawal-history";
  static const getAllStopLimitOrdersApp = "/api/get-all-stop-limit-orders-app";
  static const getReferralHistory = "/api/referral-history";
  static const getRateApp = "/api/get-rate-app";
  static const getUserSetting = "/api/user-setting";
  static const getActivityList = "/api/activity-list";
  static const getKYCDetails = "/api/kyc-details";
  static const getUserKYCSettingsDetails = "/api/user-kyc-settings-details";
  static const getSetupGoogle2faLogin = "/api/setup-google2fa-login";
  static const getFaqList = "/api/faq-list";
  static const getNotifications = "/api/notifications";
  static const getReferralApp = "/api/referral-app";
  static const getCurrencyDeposit = "/api/currency-deposit";
  static const getFiatWithdrawal = "/api/fiat-withdrawal";
  static const getUserBankList = "/api/user-bank-list";
}

class APIKeyConstants {
  static const firstName = "first_name";
  static const lastName = "last_name";
  static const email = "email";
  static const password = "password";
  static const confirmPassword = "password_confirmation";
  static const oldPassword = "old_password";
  static const accessToken = "access_token";
  static const accessType = "access_type";
  static const userId = "user_id";
  static const user = "user";
  static const refreshToken = "refreshToken";
  static const gRecaptchaResponse = "g-recaptcha-response";
  static const recaptcha = "recapcha";
  static const score = "score";
  static const expireAt = "expireAt";
  static const phone = "phone";
  static const name = "name";
  static const title = "title";
  static const status = "status";
  static const image = "image";
  static const id = "id";
  static const ids = "ids";
  static const updatedAt = "updated_at";
  static const createdAt = "created_at";
  static const avatar = "avatar";
  static const isEmailVerified = "isEmailVerified";
  static const walletAddress = "walletAddress";
  static const first = "first";
  static const paginateNumber = "paginateNumber";
  static const currentPassword = "current_password";
  static const country = "country";
  static const gender = "gender";
  static const photo = "photo";
  static const verificationType = "verification_type";
  static const frontImage = "front_image";
  static const backImage = "back_image";
  static const fileTwo = "file_two";
  static const fileThree = "file_three";
  static const fileSelfie = "file_selfie";
  static const accept = "Accept";
  static const authorization = "Authorization";
  static const page = "page";
  static const perPage = "per_page";
  static const limit = "limit";
  static const type = "type";
  static const language = "language";
  static const verifyCode = "verify_code";
  static const code = "code";
  static const token = "token";
  static const url = "url";
  static const remove = "remove";
  static const google2factSecret = "google2fa_secret";
  static const g2fEnabled = "g2f_enabled";
  static const userApiSecret = "userapisecret";
  static const userAgent = "User-Agent";
  static const lang = "lang";
  static const dashboardType = "dashboard_type";
  static const orderType = "order_type";
  static const baseCoinId = "base_coin_id";
  static const tradeCoinId = "trade_coin_id";
  static const orders = "orders";
  static const transactions = "transactions";
  static const wallets = "wallets";
  static const wallet = "wallet";
  static const address = "address";
  static const amount = "amount";
  static const currency = "currency";
  static const price = "price";
  static const stop = "stop";
  static const total = "total";
  static const columnName = "column_name";
  static const orderBy = "order_by";
  static const success = "success";
  static const message = "message";
  static const emailVerified = "email_verified";
  static const time = "time";
  static const data = "data";
  static const walletId = "wallet_id";
  static const fromWalletId = "from_wallet_id";
  static const paymentMethodId = "payment_method_id";
  static const bankId = "bank_id";
  static const bankReceipt = "bank_receipt";
  static const networkType = "network_type";
  static const fromCoinId = "from_coin_id";
  static const toCoinId = "to_coin_id";
  static const convertRate = "convert_rate";
  static const rate = "rate";
  static const note = "note";
  static const setup = "setup";
  static const google2faSecret = "google2fa_secret";
  static const faqTypeId = "faq_type_id";
  static const calculatedAmount = "calculated_amount";
  static const stripeToken = "stripe_token";
  static const paypalToken = "paypal_token";
  static const interval = "interval";
  static const activityLog = "activityLog";
  static const inquiryId = "inquiry_id";

  static const vAccept = "application/json";
  static const vProfilePhotoPath = "";
  static const vBearer = "Bearer";
  static const vOrderDESC = "desc";
  static const vOrderASC = "asc";
}

class SocketConstants {
  static const baseUrl = "wss://tradexpro-laravel.cdibrandstudio.com/app/test";

  static const channelNotification = "notification_";
  static const channelDashboard = "dashboard-";
  static const channelTradeInfo = "trade-info-";
  static const channelTradeHistory = "trade-history-";
  static const channelOrderPlace = "order_place_";

  static const eventNotification = "notification";
  static const eventOrderPlace = "order_place";
  static const eventProcess = "process";
  static const eventOrderRemove = "order_removed";
}

class URLConstants {
  static const website = "https://tradexpro-exchange.cdibrandstudio.com";
  static const referralLink = "$website/authentication/signup?";
  static const fbReferral = "https://www.facebook.com/sharer/sharer.php?u=";
  static const twitterReferral = "https://www.twitter.com/share?url=";
}

class ErrorConstants {
  static const unauthorized = "Unauthorized";
}
