import 'dart:ui';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tradexpro_flutter/data/models/user.dart';
import '../../utils/colors.dart';

Rx<User> gUserRx = User(id: 0).obs;
bool gIsDarkMode = false;
String gUserAgent = "";

enum IdVerificationType { none, nid, passport, driving, voter }

enum PhotoType { front, back, selfie }

class AssetConstants {
  //ICONS
  static const basePathIcons = "assets/icons/";
  static const icLogo = "${basePathIcons}icLogo.svg";
  static const icLogoWithTitle = "${basePathIcons}icLogoWithTitle.svg";
  static const icBottomBgMark = "${basePathIcons}icBottomBgMark.svg";
  static const icBottomBgMarkDark = "${basePathIcons}icBottomBgMarkDark.svg";
  static const icBottomBgAuth = "${basePathIcons}icBottomBgAuth.svg";
  static const icTopBgMark = "${basePathIcons}icTopBgMark.svg";
  static const icEllipseBg = "${basePathIcons}icEllipseBg.svg";
  static const icEmail = "${basePathIcons}ic_email.svg";
  static const icFingerprintScan = "${basePathIcons}ic_fingerprint_scan.svg";
  static const icKey = "${basePathIcons}ic_key.svg";
  static const icSmartphone = "${basePathIcons}ic_smartphone.svg";
  static const icUpload = "${basePathIcons}ic_upload.svg";
  static const icRibbon = "${basePathIcons}ic_ribbon.png";
  static const icInfoCircle = "${basePathIcons}ic_info_circle.svg";
  static const icMessage = "${basePathIcons}ic_message.svg";

  ///IMAGES
  static const basePathImages = "assets/images/";
  static const bgSplash = "${basePathImages}bgSplash.png";
  static const icAuthenticator = "${basePathImages}icGoogleAuthenticatorLogo.png";
  static const imgDrivingLicense = "${basePathImages}img_driving_license.png";
  static const imgNID = "${basePathImages}img_NID.png";
  static const imgPassport = "${basePathImages}img_passport.png";
  static const imgVoterCard = "${basePathImages}img_voter_card.png";

  //////////
  static const pathTempImageFolder = "/tmpImages/";
  static const pathTempFrontImageName = "_frontImage_id_verify.jpeg";
  static const pathTempBackImageName = "_backImage_id_verify.jpeg";

  static const avatar = "${basePathImages}avatar.png";
  static const noImage = "${basePathImages}noImage.png";
  static const imgNotAvailable = "${basePathImages}imageNotAvailable.png";

  static const bgScreen = "${basePathImages}bgScreen.png";
  static const bgAuth = "${basePathImages}bgAuth.png";
  static const bgAuthTop = "${basePathImages}bgAuthTop.png";
  static const bgAuthMiddle = "${basePathImages}bgAuthMiddle.png";
  static const bgAuthMiddleDark = "${basePathImages}bgAuthMiddleDark.png";
  static const bgAuthBottomLeft = "${basePathImages}bgAuthBottomLeft.png";
  static const bgAppBar = "${basePathImages}bgAppBar.png";
  static const bgAppBar2 = "${basePathImages}bgAppBar2.png";
  static const bg = "${basePathImages}bg.png";
  static const bg2 = "${basePathImages}bg2.png";
  static const bgNavHeader = "${basePathImages}bgNavHeader.png";
  static const qr = "${basePathImages}qr.png";
  static const btcChart = "${basePathImages}btcChart.png";
  static const learn = "${basePathImages}learn.png";

  static const bgOnBoarding = "${basePathImages}bgOnBoarding.png";
  static const onBoarding0 = "${basePathImages}onBoarding0.png";
  static const onBoarding1 = "${basePathImages}onBoarding1.png";
  static const onBoarding2 = "${basePathImages}onBoarding2.png";

  static const icGoogleAuthenticatorLogo = "${basePathImages}icGoogleAuthenticatorLogo.png";
  static const icEmptyDataPng = "${basePathImages}icEmptyDataPng.png";
  static const chartOverview = "${basePathImages}chartOverview.png";

  static const icArrowLeft = "${basePathIcons}ic_arrow_left.svg";
  static const icArrowRight = "${basePathIcons}ic_arrow_right.svg";
  static const icArrowDown = "${basePathIcons}ic_arrow_down.svg";
  static const icCloseBox = "${basePathIcons}ic_close_box.svg";
  static const icPasswordHide = "${basePathIcons}ic_password_hide.svg";
  static const icPasswordShow = "${basePathIcons}ic_password_show.svg";
  static const icBoxSquare = "${basePathIcons}ic_box_square.svg";
  static const icTickRound = "${basePathIcons}ic_tick_round.svg";
  static const icTickSquare = "${basePathIcons}ic_tick_square.svg";
  static const icTickLarge = "${basePathIcons}icTickLarge.svg";
  static const icTime = "${basePathIcons}icTime.svg";
  static const icBoxFilterAll = "${basePathIcons}icBoxFilterAll.svg";
  static const icBoxFilterSell = "${basePathIcons}icBoxFilterSell.svg";
  static const icBoxFilterBuy = "${basePathIcons}icBoxFilterBuy.svg";
  static const icCrossIsolated = "${basePathIcons}icCrossIsolated.svg";
  static const icAccentDot = "${basePathIcons}icAccentDot.svg";

  static const icCamera = "${basePathIcons}ic_camera.svg";
  static const icNotification = "${basePathIcons}icNotification.svg";
  static const icMenu = "${basePathIcons}icMenu.svg";
  static const icDashboard = "${basePathIcons}icDashboard.svg";
  static const icActivity = "${basePathIcons}icActivity.svg";
  static const icWallet = "${basePathIcons}icWallet.svg";
  static const icMarket = "${basePathIcons}icMarket.svg";

  static const icNavActivity = "${basePathIcons}icNavActivity.svg";
  static const icNavLogout = "${basePathIcons}icNavLogout.svg";
  static const icNavPersonalVerification = "${basePathIcons}icNavPersonalVerification.svg";
  static const icNavProfile = "${basePathIcons}icNavProfile.svg";
  static const icNavReferrals = "${basePathIcons}icNavReferrals.svg";
  static const icNavResetPassword = "${basePathIcons}icNavResetPassword.svg";
  static const icNavSecurity = "${basePathIcons}icNavSecurity.svg";
  static const icNavSettings = "${basePathIcons}icNavSettings.svg";

  static const icHomeTabSelected = "${basePathIcons}ic_home_tab_selected.svg";
  static const icExplore = "${basePathIcons}ic_explore.svg";
  static const icExploreTabSelected = "${basePathIcons}ic_explore_tab_selected.svg";
  static const icFavorite = "${basePathIcons}ic_favorite.svg";
  static const icFavoriteTabSelected = "${basePathIcons}ic_favorite_tab_selected.svg";
  static const icFavoriteFill = "${basePathIcons}ic_favorite_fill.svg";
  static const icCategory = "${basePathIcons}ic_category.svg";
  static const icCategoryFill = "${basePathIcons}ic_category_fill.svg";
  static const icCategoryTabSelected = "${basePathIcons}ic_category_tab_selected.svg";
  static const icStatus = "${basePathIcons}ic_status.svg";
  static const icStatusTabSelected = "${basePathIcons}ic_status_tab_selected.svg";

  static const icOption = "${basePathIcons}icOption.svg";
  static const icFilter = "${basePathIcons}icFilter.svg";
  static const icFilterTwo = "${basePathIcons}icFilterTwo.svg";
  static const icFavoriteStar = "${basePathIcons}icFavoriteStar.svg";
  static const icEmptyData = "${basePathIcons}icEmptyData.svg";
  static const icBack = "${basePathIcons}icBack.svg";
  static const icSearch = "${basePathIcons}icSearch.svg";
  static const icCoinLogo = "${basePathIcons}icCoinLogo.svg";

  static const icTether = "${basePathIcons}icTether.svg";
  static const icTotalHoldings = "${basePathIcons}icTotalHoldings.svg";
  static const icCryptoFill = "${basePathIcons}icCryptoFill.svg";
  static const icCross = "${basePathIcons}icCross.svg";
  static const icCopy = "${basePathIcons}icCopy.svg";
  static const icCelebrate = "${basePathIcons}icCelebrate.svg";

  static const icEditRoundBg = "${basePathIcons}icEditRoundBg.png";
}

class FromKey {
  static const up = "up";
  static const down = "down";
  static const buy = "buy";
  static const sell = "sell";
  static const all = "all";
  static const buySell = "buy_sell";
  static const trade = "trade";
  static const dashboard = "dashboard";
}

class HistoryType {
  static const deposit = "deposit";
  static const withdraw = "withdraw";
  static const stopLimit = "stop_limit";
  static const swap = "swap";
  static const buyOrder = "buy_order";
  static const sellOrder = "sell_order";
  static const transaction = "transaction";
  static const fiatDeposit = "fiat_deposit";
  static const fiatWithdrawal = "fiat_withdrawal";
  static const refEarningWithdrawal = "ref_earning_withdrawal";
  static const refEarningTrade = "ref_earning_trade";
}

class PreferenceKey {
  static const isDark = 'is_dark';
  static const languageKey = "language_key";
  static const isOnBoardingDone = 'is_on_boarding_done';
  static const isLoggedIn = "is_logged_in";
  static const accessToken = "access_token";
  static const accessType = "access_type";
  static const userObject = "user_object";
  static const settingsObject = "settings_object";
}

class DefaultValue {
  static const int kPasswordLength = 6;
  static const int codeLength = 6;
  static const String currency = "USD";
  static const String currencySymbol = "\$";
  static const String crispKey = "encrypt";

  static const int listLimitLarge = 20;
  static const int listLimitMedium = 10;
  static const int listLimitShort = 5;
  static const String country = "Bangladesh";
  static const String randomImage =
      "https://media.istockphoto.com/photos/high-angle-view-of-a-lake-and-forest-picture-id1337232523"; //"https://picsum.photos/200";
  static const String longString = "Expandable widgets are often used within a scroll view. "
      "When the user expands a widget, be it an ExpandablePanel or an Expandable with a custom control,"
      " they expect the expanded widget to fit within the viewable area (if possible). "
      "For example, if you show a list of articles with a summary of each article, "
      "and the user expands an article to read it, they expect the expanded article to "
      "occupy as much screen space as possible. The Expandable package contains a widget to "
      "help implement this behavior, ScrollOnExpand. Here's how to use it.";
  static const accessToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiZDg5YmIwNmQ5YTgyNTYxYzgzZTJmMmYwZDNiOTIxMDZkYjE5YTYzNmIyYjU3N2I4NThkOTEyNzVmZGNiMzU3OGM1YWRhZjY2ZTM2YzY5YjYiLCJpYXQiOjE2NjQ0NDY2NTYuNjU2NjM3LCJuYmYiOjE2NjQ0NDY2NTYuNjU2NjQzLCJleHAiOjE2OTU5ODI2NTYuNjUxNjY5LCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.PV-Mw0RDSfT0OWojilB-MFxxJIoh-b2iE0WYnW4zSNOMf0FP-1yUg4d1xERjeuzgirN3LWLBX_M8re3MBzfcR-rTIr-cRcDH2i_u4HF77YECVsFIqiUGkfUaaSf2SQa24Ha3SioG8OIYM25_WmXNsXKyrIMp7Vi0Qq_BjsQJyOkOFhqH-XEumORw73akGCkmrWA0WcL-om5xpj0GiafZs5qz19bNKzxzuF7q3Lguyo8df0PMpA_AhNmP4M7GpHT_gitlvINPRAHtD6p7WuHJ9w221EHOy1J97yVCgQy-7ymDZ6mZBAyDxRavP1j5H40GuS6ZtgUxbd-rF1t_VY96zxA4lS4uvEWjRzcBMu8TF2lspjb9WwYfUJHhew-mrq3Gy7wgfUkd-nItG2aOpeu6P8kJKcwGuoLN9wkZ_q7zsnphU8vHt5jH2IBCI_XpayG1CpRjhl10w4A2jip9evXlY1gPGOkCyCseunQpLcaq6wxltSqL6x4ZIxnWROIlNSJSiroco3SqeRDVNOHtC3B_vXW9TmE2lcceCO_Wv5VTNcgQxjKxLPyv-Szrc_FNLFm3OtseHR72qKv2qIOFdg_qZh3yZgCawRDQAYp0xo42c9FWAb_JU6lADew1QwPjpWi-OoI8qDSf4r3p0Jrdj4g8Lf-lAPXegi8MsQg5zNAzG0U";
}

class EnvKeyValue {
  static const kStripKey = "stripKey";
  static const kEnvFile = ".env";
  static const kModePaypal = "modePaypal";
  static const kClientIdPaypal = "clientIdPaypal";
  static const kSecretPaypal = "secretPaypal";
  static const kApiSecret = "apiSecret";
}

class IdVerificationStatus {
  static const notSubmitted = "Not Submitted";
  static const pending = "Pending";
  static const accepted = "Approved";
  static const rejected = "Rejected";
}

class UserStatus {
  static const pending = 0;
  static const accepted = 1;
  static const rejected = 2;
  static const suspended = 4;
  static const deleted = 5;
}

class PaymentMethodType {
  static const paypal = 3;
  static const bank = 4;
  static const card = 5;
  static const wallet = 6;
}

class FAQType {
  static const main = 1;
  static const deposit = 2;
  static const withdrawn = 3;
  static const buy = 4;
  static const sell = 5;
  static const coin = 6;
  static const wallet = 7;
  static const trade = 8;
}

class ListConstants {
  static const List<String> percents = ['25', '50', '75', '100'];

  static const List<String> coinType = ["BTC", "LTCT", "ETH", "LTC", "DOGE", "BCH", "DASH", "ETC", "USDT"];
  static const List<String> stopLimitList = ['Stop-limit', 'limit', 'market', 'OCO'];
  static const List<String> cryptoList = ['BTC/USDT', 'Eth', 'XOR', 'OCO'];
  static const List<String> currencyList = ['USD', 'EURO', 'INR', 'BDT'];
  static const List<String> tagItems = ['Post only', 'iceberg'];
  static const List<String> decimalPointList = ['0.01', '0.1', '1', '10', '50', '100'];
  static const kCategoryColorList = [Color(0xff1F78FC), Color(0xffE30261), Color(0xffD200A4), Color(0xffFFA800), cUfoGreen, cSlateGray];
  static const kCountry = ['United State', 'Bangladesh', 'Portugal', 'Saudi Arabia'];
  static const kTimeFormat = ['GMT', 'UTC'];
}

const htmlTextDemo = """
<h1>Header 1</h1>
<h3>Ruby Support:</h3>
      <h3>Support for <code>sub</code>/<code>sup</code></h3>
      Solve for <var>x<sub>n</sub></var>: log<sub>2</sub>(<var>x</var><sup>2</sup>+<var>n</var>) = 9<sup>3</sup>
      <p>One of the most <span>common</span> equations in all of physics is <br /><var>E</var>=<var>m</var><var>c</var><sup>2</sup>.</p>
      <h3>Inline Styles:</h3>
      <p>The should be <span style='color: blue;'>BLUE style='color: blue;'</span></p>
      <p>The should be <span style='color: red;'>RED style='color: red;'</span></p>
      <p style="text-align: center;"><span style="color: rgba(0, 0, 0, 0.95);">blasdafjklasdlkjfkl</span></p>
      <h3>Table support (with custom styling!):</h3>
      <p>
      <q>Famous quote...</q>
      </p>
      <table>
      <colgroup>
        <col width="50%" />
        <col span="2" width="25%" />
      </colgroup>
      <thead>
      <tr><th>One</th><th>Two</th><th>Three</th></tr>
      </thead>
      <tbody>
      <tr>
        <td rowspan='2'>Rowspan\nRowspan\nRowspan\nRowspan\nRowspan\nRowspan\nRowspan\nRowspan\nRowspan\nRowspan</td><td>Data</td><td>Data</td>
      </tr>
      <tr>
        <td colspan="2"><img alt='Google' src='https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png' /></td>
      </tr>
      </tbody>
      <tfoot>
      <tr><td>fData</td><td>fData</td><td>fData</td></tr>
      </tfoot>
      </table>
      <h3>Custom Element Support (inline: <bird></bird> and as block):</h3>
      <flutter></flutter>
      <flutter horizontal></flutter>
      <h3>SVG support:</h3>
      <svg id='svg1' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'>
            <circle r="32" cx="35" cy="65" fill="#F00" opacity="0.5"/>
            <circle r="32" cx="65" cy="65" fill="#0F0" opacity="0.5"/>
            <circle r="32" cx="50" cy="35" fill="#00F" opacity="0.5"/>
      </svg>
      <h3>List support:</h3>
      <ol>
            <li>
            ordered
            <ul>
            <li>With<br /><br />...</li>
            <li>nested</li>
            <li>unordered
            <ol>
            <li>With a nested</li>
            </ol>
            </li>
            <li>list</li>
            </ul>
            </li>
            <li>list! Lorem ipsum dolor sit amet.</li>
            <li><h2>Header 2</h2></li>
            <h2><li>Header 2</li></h2>
      </ol>
      <h3>Link support:</h3>
      <p>
        Linking to <a href='https://github.com'>websites</a> has never been easier.
      </p>
      <h3>Image support:</h3>
      <h3>Network png</h3>
      <img alt='Google' src='https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png' />
      <h3>Network svg</h3>
      <img src='https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/android.svg' />
      <h3>Base64</h3>
      <img alt='Red dot' src='data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==' />
      <h3>No image source</h3>
      <img alt='No source'  src=""/>
""";
