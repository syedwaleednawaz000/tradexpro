import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/utils/theme.dart';
import '../../../../helper/main_bg_view.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/spacers.dart';
import 'settings_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final _controller = Get.put(SettingsController());
  RxBool isDark = false.obs;
  final _iconSize = Get.width / 4;

  @override
  void initState() {
    super.initState();
    isDark.value = ThemeService().loadThemeFromBox();
    _controller.setCurrentLanguage(gUserRx.value);
    _controller.selectedCurrency.value = -1;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getUserSetting();
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
                appBarBackWithActions(title: "Settings".tr),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(Dimens.paddingMid),
                    children: [
                      vSpacer10(),
                      textAutoSizePoppins("Google Authentication Settings".tr, maxLines: 2, textAlign: TextAlign.start, color: context.theme.primaryColor),
                      vSpacer20(),
                      showImageAsset(imagePath: AssetConstants.icGoogleAuthenticatorLogo, width: _iconSize, height: _iconSize),
                      vSpacer20(),
                      textAutoSizeTitle("Authenticator app".tr, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
                      textAutoSizePoppins("Authenticator_app_use_message".tr, maxLines: 5, textAlign: TextAlign.start),
                      vSpacer10(),
                      _g2FAButtonView(),
                      vSpacer20(),
                      textAutoSizeTitle("Security".tr, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
                      textAutoSizePoppins("Please turn on this option to enable two factor authentication".tr,
                          maxLines: 2, textAlign: TextAlign.start),
                      vSpacer10(),
                      Obx(() {
                        final g2FEnabled = _controller.userSettings.value.user?.g2FEnabled == 1;
                        return toggleSwitch(
                            selectedValue: g2FEnabled,
                            activeText: "On".tr,
                            inactiveText: "Off".tr,
                            onChange: (value) => _controller.enableDisable2FALogin());
                      }),
                      dividerHorizontal(height: Dimens.mainContendGapTop),
                      textAutoSizeTitle("Preference Settings".tr, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
                      vSpacer20(),
                      textAutoSizePoppins("Currency".tr, textAlign: TextAlign.start),
                      Obx(() {
                        final list = getCurrencyList(_controller.userSettings.value.fiatCurrency);
                        return dropDownListIndex(list, _controller.selectedCurrency.value, "Select".tr, (value) {
                          _controller.selectedCurrency.value = value;
                          _controller.saveCurrency();
                        }, hMargin: 0);
                      }),
                      vSpacer15(),
                      textAutoSizePoppins("Language".tr, textAlign: TextAlign.start),
                      Obx(() {
                        final list = _controller.getLanguageList();
                        return dropDownListIndex(list, _controller.selectedLanguage.value, "Select".tr, (value) {
                          _controller.selectedLanguage.value = value;
                          _controller.saveLanguage();
                        }, hMargin: 0);
                      }),
                      vSpacer20(),
                      Obx(() => CupertinoFormRow(
                        padding: EdgeInsets.zero,
                        prefix: Row(
                          children: <Widget>[
                            Icon(isDark.value ? Icons.dark_mode : Icons.light_mode, size: Dimens.iconSizeMid),
                            hSpacer10(),
                            textAutoSizeTitle(isDark.value ? 'Dark Mode'.tr : "Light Mode".tr, fontSize: Dimens.regularFontSizeMid)
                          ],
                        ),
                        child: CupertinoSwitch(
                          value: isDark.value,
                          activeColor: context.theme.focusColor,
                          onChanged: (value) {
                            ThemeService().switchTheme();
                            isDark.value = value;
                          },
                        ),
                      )),
                      vSpacer20(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _g2FAButtonView() {
    return Obx(() {
      final isValid = _controller.userSettings.value.user?.google2FaSecret.isValid ?? false;
      return Row(
        children: [
          buttonRoundedMain(
              text: isValid ? "Remove".tr : "Set Up".tr,
              width: context.width / 2,
              bgColor: isValid ? Colors.red : null,
              onPressCallback: () {
                if (isValid) {
                  showBottomSheetFullScreen(context, _showGoogleAuthyRemoveView(),
                      title: "Remove".tr, onClose: () => _controller.codeEditController.text = "");
                } else {
                  showBottomSheetFullScreen(context, _showGoogleAuthyAddView(),
                      title: "Set Up".tr, onClose: () => _controller.codeEditController.text = "");
                }
              }),
        ],
      );
    });
  }

  Widget _showGoogleAuthyAddView() {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Dimens.paddingMid),
        children: [
          showImageNetwork(imagePath: _controller.userSettings.value.qrcode, width: context.width / 2, height: context.width / 2),
          vSpacer20(),
          textAutoSizePoppins("Google Authenticator app info message".tr, maxLines: 5),
          vSpacer10(),
          textWithCopyButton(_controller.userSettings.value.google2faSecret ?? ""),
          dividerHorizontal(height: Dimens.mainContendGapTop, indent: context.width / 8),
          textFieldWithSuffixIcon(
              controller: _controller.codeEditController, hint: "Enter Your Code".tr, labelText: "Your Code".tr, type: TextInputType.number),
          vSpacer20(),
          buttonRoundedMain(text: "Verify".tr, onPressCallback: () => _controller.setupGoogleSecret()),
          vSpacer20(),
        ],
      ),
    );
  }

  Widget _showGoogleAuthyRemoveView() {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Dimens.paddingMid),
        children: [
          showImageAsset(imagePath: AssetConstants.icGoogleAuthenticatorLogo, width: _iconSize, height: _iconSize),
          vSpacer20(),
          textAutoSizePoppins("Google Authenticator remove message".tr, maxLines: 5),
          vSpacer20(),
          textFieldWithSuffixIcon(
              controller: _controller.codeEditController, hint: "Enter Your Code".tr, labelText: "Your Code".tr, type: TextInputType.number),
          vSpacer20(),
          buttonRoundedMain(text: "Remove".tr, onPressCallback: () => _controller.setupGoogleSecret()),
          vSpacer20(),
        ],
      ),
    );
  }
}
