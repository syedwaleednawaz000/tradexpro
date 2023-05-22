import 'dart:convert';

import 'package:tradexpro_flutter/data/models/user.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

import 'fiat_deposit.dart';

/// final commonSettings = commonSettingsFromJson(jsonString);
CommonSettings commonSettingsFromJson(String str) => CommonSettings.fromJson(json.decode(str));

String commonSettingsToJson(CommonSettings data) => json.encode(data.toJson());

class CommonSettings {
  CommonSettings({
    this.baseCurrency,
    this.currency,
    this.currencySymbol,
    this.currencyRate,
    this.appTitle,
    this.maintenanceMode,
    this.copyrightText,
    this.exchangeUrl,
    this.logo,
    this.loginBackground,
    this.favicon,
    this.cookieImage,
    this.cookieStatus,
    this.cookieHeader,
    this.cookieText,
    this.cookieButtonText,
    this.cookiePageKey,
    this.liveChatStatus,
    this.liveChatKey,
    this.swapStatus,
    this.maintenanceModeStatus,
    this.maintenanceModeTitle,
    this.maintenanceModeText,
    this.maintenanceModeImg,
    this.languageList,
    this.currencyDepositStatus,
    this.currencyDeposit2FaStatus,
    this.currencyDepositFaqStatus,
    this.faqTypeList,
    this.googleAnalyticsTrackingId,
    this.seoImage,
    this.seoMetaKeywords,
    this.seoMetaDescription,
    this.seoSocialTitle,
    this.seoSocialDescription,
    this.twoFactorWithdraw,
    this.exchangeLayoutView,
    this.publicChanelName,
    this.privateChanelName,
  });

  String? baseCurrency;
  String? currency;
  String? currencySymbol;
  double? currencyRate;
  String? appTitle;
  String? maintenanceMode;
  String? copyrightText;
  String? exchangeUrl;
  String? logo;
  String? loginBackground;
  String? favicon;
  String? cookieImage;
  String? cookieStatus;
  String? cookieHeader;
  String? cookieText;
  String? cookieButtonText;
  String? cookiePageKey;
  String? liveChatStatus;
  String? liveChatKey;
  int? swapStatus;
  String? maintenanceModeStatus;
  String? maintenanceModeTitle;
  String? maintenanceModeText;
  String? maintenanceModeImg;
  List<AppLanguage>? languageList;
  String? currencyDepositStatus;
  String? currencyDeposit2FaStatus;
  String? currencyDepositFaqStatus;
  List<dynamic>? faqTypeList;
  String? googleAnalyticsTrackingId;
  String? seoImage;
  String? seoMetaKeywords;
  String? seoMetaDescription;
  String? seoSocialTitle;
  String? seoSocialDescription;
  String? twoFactorWithdraw;
  int? exchangeLayoutView;
  String? publicChanelName;
  String? privateChanelName;

  factory CommonSettings.fromJson(Map<String, dynamic> json) => CommonSettings(
        baseCurrency: json["base_currency"],
        currency: json["currency"],
        currencySymbol: json["currency_symbol"],
        currencyRate: makeDouble(json["currency_rate"]),
        appTitle: json["app_title"],
        maintenanceMode: json["maintenance_mode"],
        copyrightText: json["copyright_text"],
        exchangeUrl: json["exchange_url"],
        logo: json["logo"],
        loginBackground: json["login_background"],
        favicon: json["favicon"],
        cookieImage: json["cookie_image"],
        cookieStatus: json["cookie_status"],
        cookieHeader: json["cookie_header"],
        cookieText: json["cookie_text"],
        cookieButtonText: json["cookie_button_text"],
        cookiePageKey: json["cookie_page_key"],
        liveChatStatus: json["live_chat_status"],
        liveChatKey: json["live_chat_key"],
        swapStatus: makeInt(json["swap_status"]),
        maintenanceModeStatus: json["maintenance_mode_status"],
        maintenanceModeTitle: json["maintenance_mode_title"],
        maintenanceModeText: json["maintenance_mode_text"],
        maintenanceModeImg: json["maintenance_mode_img"],
        languageList: json["LanguageList"] == null ? null : List<AppLanguage>.from(json["LanguageList"].map((x) => AppLanguage.fromJson(x))),
        currencyDepositStatus: json["currency_deposit_status"],
        currencyDeposit2FaStatus: json["currency_deposit_2fa_status"],
        currencyDepositFaqStatus: json["currency_deposit_faq_status"],
        faqTypeList: json["FaqTypeList"] == null ? null : List<dynamic>.from(json["FaqTypeList"].map((x) => x)),
        googleAnalyticsTrackingId: json["google_analytics_tracking_id"],
        seoImage: json["seo_image"],
        seoMetaKeywords: json["seo_meta_keywords"],
        seoMetaDescription: json["seo_meta_description"],
        seoSocialTitle: json["seo_social_title"],
        seoSocialDescription: json["seo_social_description"],
        twoFactorWithdraw: json["two_factor_withdraw"],
        exchangeLayoutView: makeInt(json["exchange_layout_view"]),
        publicChanelName: json["public_chanel_name"],
        privateChanelName: json["private_chanel_name"],
      );

  Map<String, dynamic> toJson() => {
        "base_currency": baseCurrency,
        "currency": currency,
        "currency_symbol": currencySymbol,
        "currency_rate": currencyRate,
        "app_title": appTitle,
        "maintenance_mode": maintenanceMode,
        "copyright_text": copyrightText,
        "exchange_url": exchangeUrl,
        "logo": logo,
        "login_background": loginBackground,
        "favicon": favicon,
        "cookie_image": cookieImage,
        "cookie_status": cookieStatus,
        "cookie_header": cookieHeader,
        "cookie_text": cookieText,
        "cookie_button_text": cookieButtonText,
        "cookie_page_key": cookiePageKey,
        "live_chat_status": liveChatStatus,
        "live_chat_key": liveChatKey,
        "swap_status": swapStatus,
        "maintenance_mode_status": maintenanceModeStatus,
        "maintenance_mode_title": maintenanceModeTitle,
        "maintenance_mode_text": maintenanceModeText,
        "maintenance_mode_img": maintenanceModeImg,
        "LanguageList": languageList == null ? null : List<dynamic>.from(languageList!.map((x) => x.toJson())),
        "currency_deposit_status": currencyDepositStatus,
        "currency_deposit_2fa_status": currencyDeposit2FaStatus,
        "currency_deposit_faq_status": currencyDepositFaqStatus,
        "FaqTypeList": languageList == null ? null : List<dynamic>.from(faqTypeList!.map((x) => x)),
        "google_analytics_tracking_id": googleAnalyticsTrackingId,
        "seo_image": seoImage,
        "seo_meta_keywords": seoMetaKeywords,
        "seo_meta_description": seoMetaDescription,
        "seo_social_title": seoSocialTitle,
        "seo_social_description": seoSocialDescription,
        "two_factor_withdraw": twoFactorWithdraw,
        "exchange_layout_view": exchangeLayoutView,
        "public_chanel_name": publicChanelName,
        "private_chanel_name": privateChanelName,
      };
}

class AppLanguage {
  AppLanguage({
    required this.id,
    this.name,
    this.key,
    this.status,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String? name;
  String? key;
  int? status;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AppLanguage.fromJson(Map<String, dynamic> json) => AppLanguage(
        id: json["id"],
        name: json["name"],
        key: json["key"],
        status: json["status"],
        image: json["image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "key": key,
        "status": status,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

//final userSettings = userSettingsFromJson(jsonString);

UserSettings userSettingsFromJson(String str) => UserSettings.fromJson(json.decode(str));

String userSettingsToJson(UserSettings data) => json.encode(data.toJson());

class UserSettings {
  UserSettings({this.fiatCurrency, this.user, this.google2faSecret, this.qrcode});

  List<FiatCurrency>? fiatCurrency;
  User? user;
  String? google2faSecret;
  String? qrcode;

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        fiatCurrency: json["fiat_currency"] == null ? null : List<FiatCurrency>.from(json["fiat_currency"].map((x) => FiatCurrency.fromJson(x))),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        google2faSecret: json["google2fa_secret"],
        qrcode: json["qrcode"],
      );

  Map<String, dynamic> toJson() => {
        "fiat_currency": fiatCurrency == null ? null : List<dynamic>.from(fiatCurrency!.map((x) => x.toJson())),
        "user": user == null ? null : user!.toJson(),
        "google2fa_secret": google2faSecret,
        "qrcode": qrcode,
      };
}
