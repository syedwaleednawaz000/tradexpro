import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'dimens.dart';

Widget buttonRoundedMain(
    {String? text,
    VoidCallback? onPressCallback,
    Color? textColor,
    Color? bgColor,
    double buttonHeight = Dimens.btnHeightMain,
    double? width,
    double? borderRadius = Dimens.radiusCorner}) {
  width = width ?? Get.width;
  bgColor = bgColor ?? Get.theme.colorScheme.secondary;
  return Container(
      margin: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
      height: buttonHeight,
      width: width,
      child: ElevatedButton(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(bgColor),
              backgroundColor: MaterialStateProperty.all<Color>(bgColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius!)), side: BorderSide(color: bgColor)))),
          onPressed: onPressCallback,
          child: AutoSizeText(text ?? "", style: Get.theme.textTheme.labelLarge!.copyWith(color: textColor))));
}

Widget buttonText(String text, {VoidCallback? onPressCallback, Color? textColor, Color? bgColor}) {
  bgColor = bgColor ?? Get.theme.colorScheme.secondary;
  return ElevatedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 5, vertical: 0)),
          foregroundColor: MaterialStateProperty.all<Color>(bgColor),
          backgroundColor: MaterialStateProperty.all<Color>(bgColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(Dimens.radiusCorner)), side: BorderSide(color: bgColor)))),
      onPressed: onPressCallback,
      child: AutoSizeText(text, style: Get.theme.textTheme.labelLarge!.copyWith(fontSize: 14, color: textColor), minFontSize: 8));
}

Widget buttonOnlyIcon(
    {VoidCallback? onPressCallback,
    String? iconPath,
    IconData? iconData,
    double? size,
    Color? iconColor,
    double? padding,
    VisualDensity? visualDensity}) {
  size = size ?? Dimens.iconSizeMin;
  return IconButton(
    padding: padding == null ? EdgeInsets.zero : EdgeInsets.all(padding),
    visualDensity: visualDensity,
    onPressed: onPressCallback,
    icon: iconPath.isValid
        ? iconPath!.contains(".svg")
            ? SvgPicture.asset(iconPath, width: size, height: size, colorFilter: iconColor == null ? null : ColorFilter.mode(iconColor, BlendMode.srcIn))
            : Image.asset(iconPath, width: size, height: size, color: iconColor)
        : iconData != null
            ? Icon(iconData, size: size, color: iconColor)
            : const SizedBox(),
  );
}


Widget buttonIconWithBG({ String? iconPath, VoidCallback? onPress, Color? iconColor, Color? bgColor, double size = 50}) {
  return Container(
      height: size,
      width: size,
      decoration: boxDecorationRoundCorner(color: bgColor),
      child: buttonOnlyIcon(onPressCallback: onPress, iconPath: iconPath, iconColor: iconColor));
}

