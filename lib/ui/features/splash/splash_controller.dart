import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import '../../../data/remote/api_repository.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/network_util.dart';
import '../on_boarding/on_boarding_screen.dart';
import '../root/root_screen.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getCommonSettings();
  }

  void getCommonSettings() async {
    gUserAgent = await getUserAgent();
    NetworkCheck.isOnline().then((value) {
      if (value) {
        APIRepository().getCommonSettings().then((resp) {
          if (resp.success && resp.data != null && resp.data is Map<String, dynamic>) {
            GetStorage().write(PreferenceKey.settingsObject, resp.data);
          }
          takeNextStep();
        });
      }
    });
  }

  void takeNextStep() {
    var isOnBoarding = GetStorage().read(PreferenceKey.isOnBoardingDone);
    if (isOnBoarding) {
      Get.off(() => const RootScreen(), transition: Transition.leftToRightWithFade);
    } else {
      Get.off(() => const OnBoardingScreen(), transition: Transition.leftToRightWithFade);
    }
  }
}
