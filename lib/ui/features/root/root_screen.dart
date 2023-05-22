import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/activity/activity_screen.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/dashboard/dashboard_screen.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/fiat/fiat_screen.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/profile/profile_screen.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/wallet/wallet_screen.dart';
import 'package:tradexpro_flutter/ui/features/root/custom_icon_icons.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/faq/faq_page.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/referrals/referrals_screen.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/settings/settings_screen.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import '../../../data/models/user.dart';
import '../../../helper/app_helper.dart';
import '../../../helper/app_widgets.dart';
import '../../../utils/alert_util.dart';
import '../../../utils/button_util.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/image_util.dart';
import '../../../utils/spacers.dart';
import '../../../utils/text_util.dart';
import '../side_navigation/support/crisp_chat.dart';
import 'root_controller.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  RootScreenState createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  final RootController _controller = Get.put(RootController());
  final autoSizeGroup = AutoSizeGroup();
  final iconList = <IconData>[CustomIcons.dashboard, CustomIcons.wallet, CustomIcons.profile, CustomIcons.activity];
  RxBool isKeyBoardShowing = false.obs;
  bool isCurrencyDeposit = false;
  late StreamSubscription<bool> keyboardSubscription;
  Animation<double>? animation;

  @override
  void initState() {
    isCurrencyDeposit = getSettingsLocal()?.currencyDepositStatus == "1";
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) => isKeyBoardShowing.value = visible);
    if (isCurrencyDeposit) initAnimation();
    _controller.changeBottomNavIndex = changeBottomNavTab;
  }

  @override
  void dispose() {
    hideKeyboard(context);
    keyboardSubscription.cancel();
    super.dispose();
  }

  void changeBottomNavTab(int index) {
    setState(() => _controller.bottomNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      floatingActionButton: isCurrencyDeposit ? _floatingButtonView() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: _getDrawerNew(),
      bottomNavigationBar: _bottomNavigationView(),
      body: BGViewMain(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
            child: _getBody(),
          ),
        ),
      ),
    );
  }

  void initAnimation() {
    AnimationController animationController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 0.9).animate(curve);
    Future.delayed(const Duration(seconds: 1), () => animationController.forward());
  }

  Widget _floatingButtonView() {
    return Obx(() {
      return isKeyBoardShowing.value
          ? vSpacer0()
          : ScaleTransition(
              scale: animation!,
              child: FloatingActionButton(
                  backgroundColor: Get.theme.focusColor,
                  onPressed: () => changeBottomNavTab(13),
                  child: const Icon(Icons.add, size: Dimens.iconSizeMid)));
    });
  }

  Widget _bottomNavigationView() {
    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        final iconColor = gIsDarkMode
            ? Colors.white
            : isActive
                ? context.theme.colorScheme.background
                : context.theme.colorScheme.secondary;
        final bgColor = isActive ? context.theme.colorScheme.secondary : context.theme.colorScheme.background;
        return Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
            child: Icon(iconList[index], size: index == 2 ? Dimens.iconSizeMid : Dimens.iconSizeMin, color: iconColor));
      },
      activeIndex: _controller.bottomNavIndex,
      backgroundColor: context.theme.colorScheme.background,
      splashColor: context.theme.colorScheme.secondary,
      leftCornerRadius: Dimens.radiusCornerLarge,
      rightCornerRadius: Dimens.radiusCornerLarge,
      onTap: (index) => changeBottomNavTab(index),
      gapLocation: isCurrencyDeposit ? GapLocation.center : GapLocation.none,
      notchAndCornersAnimation: isCurrencyDeposit ? animation : null,
      splashSpeedInMilliseconds: isCurrencyDeposit ? 300 : null,
      notchSmoothness: isCurrencyDeposit ? NotchSmoothness.sharpEdge : null,
    );
  }

  Widget _getBody() {
    switch (_controller.bottomNavIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const WalletScreen();
      case 2:
        return const ProfileScreen();
      case 3:
        return const ActivityScreen();
      case 13:
        return const FiatScreen();
      default:
        return Container();
    }
  }

  _getDrawerNew() {
    return BGViewMain(
      child: Theme(
        data: context.theme.copyWith(canvasColor: Colors.transparent),
        child: Drawer(
            elevation: 0,
            width: context.width,
            child: SafeArea(
              child: Obx(() {
                final hasUser = gUserRx.value.id > 0;
                return ListView(
                  padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
                  shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        buttonOnlyIcon(
                            iconPath: AssetConstants.icCloseBox, iconColor: context.theme.primaryColorDark, onPressCallback: () => Get.back()),
                      ],
                    ),
                    if (!hasUser) signInNeedView(),
                    if (hasUser) _profileView(gUserRx.value),
                    vSpacer20(),
                    if (hasUser) _loggedInMenuView(),
                  ],
                );
              }),
            )),
      ),
    );
  }

  Widget _profileView(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        showCircleAvatar(user.photo),
        vSpacer10(),
        textAutoSizeKarla(getName(user.firstName, user.lastName), fontSize: Dimens.regularFontSizeLarge),
        vSpacer5(),
        textAutoSizeKarla(user.email ?? "", fontSize: Dimens.regularFontSizeMid, fontWeight: FontWeight.normal),
      ],
    );
  }

  Widget _loggedInMenuView() {
    final isSupport = getSettingsLocal()?.liveChatStatus == "1";
    return Column(
      children: [
        drawerNavMenuItem(
            navTitle: 'Referrals'.tr,
            iconPath: AssetConstants.icNavReferrals,
            navAction: () {
              Get.back();
              Get.to(() => const ReferralsScreen());
            }),
        drawerNavMenuItem(
            navTitle: 'Activity'.tr,
            iconPath: AssetConstants.icNavActivity,
            navAction: () {
              Get.back();
              changeBottomNavTab(3);
            }),
        drawerNavMenuItem(
            navTitle: 'Settings'.tr,
            iconPath: AssetConstants.icNavSettings,
            navAction: () {
              Get.back();
              Get.to(() => const SettingsScreen());
            }),
        if (isSupport)
          drawerNavMenuItem(navTitle: 'Support'.tr, iconPath: AssetConstants.icMessage, navAction: () => Get.to(() => const CrispChat())),
        drawerNavMenuItem(
            navTitle: 'FAQ'.tr,
            iconPath: AssetConstants.icInfoCircle,
            navAction: () {
              Get.back();
              Get.to(() => const FAQPage());
            }),
        drawerNavMenuItem(navTitle: 'Log out'.tr, iconPath: AssetConstants.icNavLogout, navAction: () => showLogOutAlert()),
      ],
    );
  }

  Widget drawerNavMenuItem({required String navTitle, required String iconPath, VoidCallback? navAction}) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: Dimens.paddingLargeDouble),
      leading: showImageAsset(imagePath: iconPath, color: context.theme.primaryColorLight, width: Dimens.iconSizeMin, height: Dimens.iconSizeMin),
      title: textAutoSizeKarla(navTitle,
          color: context.theme.primaryColorLight, fontWeight: FontWeight.normal, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.left),
      onTap: navAction,
    );
  }

  void showLogOutAlert() {
    alertForAction(context, title: "Log out".tr, subTitle: "Are you want to logout from app".tr, buttonTitle: "YES".tr, onOkAction: () {
      Get.back();
      _controller.logOut();
    });
  }
}
