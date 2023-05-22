import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/ui/features/auth/change_password/change_password_screen.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/settings/settings_screen.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import '../../../../data/local/constants.dart';
import '../../../../data/models/user.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/dimens.dart';
import '../../../../utils/spacers.dart';
import 'my_profile_controller.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _controller = Get.put(MyProfileController());
  Rx<User> userRx = gUserRx.value.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getUserSetting((user) => userRx.value = user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(Dimens.paddingMid),
      children: [
        Align(alignment: Alignment.centerLeft, child: textAutoSizePoppins("Profile Security Status".tr, fontSize: Dimens.regularFontSizeExtraMid)),
        vSpacer10(),
        _basicSecurityView(),
        vSpacer20(),
        Align(alignment: Alignment.centerLeft, child: textAutoSizePoppins("Advanced Security".tr, fontSize: Dimens.regularFontSizeExtraMid)),
        vSpacer10(),
        _advanceSecurityView()
      ],
    ));
  }

  Widget _basicSecurityView() {
    return Obx(() {
      final user = userRx.value;
      return Column(
        children: [
          _securityItemView(
              imagePath: AssetConstants.icFingerprintScan,
              title: "Google Authenticator (Recommended)".tr,
              subTitle: "Protect your account and transactions".tr,
              btnText: user.google2FaSecret.isValid ? "Remove".tr : "Enable".tr,
              btnColor: user.google2FaSecret.isValid ? Colors.red : Colors.green,
              onTap: () => Get.to(() => const SettingsScreen())),
          _securityItemView(
              imagePath: AssetConstants.icSmartphone,
              title: "Phone Number Verification".tr,
              subTitle: "Protect your account and transactions".tr,
              btnText: user.phoneVerified == 1 ? "Verified".tr : "Verify".tr,
              btnColor: user.phoneVerified == 1 ? Colors.green : null,
              onTap: () => sendSms()),
          _securityItemView(
              imagePath: AssetConstants.icEmail,
              title: "Email Address Verification".tr,
              subTitle: "Protect your account and transactions".tr,
              btnText: user.isVerified == 1 ? "Verified".tr : "Verify".tr,
              btnColor: user.isVerified == 1 ? Colors.green : null),
        ],
      );
    });
  }

  Widget _advanceSecurityView() {
    return Column(
      children: [
        _securityItemView(
            imagePath: AssetConstants.icKey,
            title: "Login Password".tr,
            subTitle: "Login password is used to log in to your account".tr,
            btnText: "Change".tr,
            btnColor: Colors.green,
            onTap: () => Get.to(() => const ChangePasswordScreen())),
      ],
    );
  }

  Widget _securityItemView({String? imagePath, String? title, String? subTitle, String? btnText, Color? btnColor, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: showImageAsset(imagePath: imagePath, width: Dimens.iconSizeLarge, height: Dimens.iconSizeLarge),
      title:
          textAutoSizePoppins(title ?? "", fontSize: Dimens.regularFontSizeMid, fontWeight: FontWeight.bold, maxLines: 2, textAlign: TextAlign.start),
      subtitle: textAutoSizePoppins(subTitle ?? "", maxLines: 3, textAlign: TextAlign.start),
      trailing: buttonText(btnText ?? "", bgColor: btnColor),
      contentPadding: EdgeInsets.zero,
    );
  }

  void sendSms() {
    if (!userRx.value.phone.isValid) {
      showToast("Please update your profile with a valid phone number".tr);
      return;
    }
    _controller.sendSMS(userRx.value.phone!, false);
  }
}
