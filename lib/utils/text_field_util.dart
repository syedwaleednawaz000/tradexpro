import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'dimens.dart';

Widget textFieldWithSuffixIcon(
    {Widget? countryPick,
    TextEditingController? controller,
    String? hint,
    String? text,
    String? labelText,
    TextInputType? type,
    String? iconPath,
    VoidCallback? iconAction,
    bool isObscure = false,
    bool isEnable = true,
    int maxLines = 1,
    double? width,
    double? borderRadius = 7,
    Function(String)? onTextChange}) {
  if (controller != null && text != null && text.isNotEmpty) {
    controller.text = text;
  }
  return Container(
      height: 50,
      width: width,
      padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        cursorColor: Get.theme.primaryColor,
        obscureText: isObscure,
        enabled: isEnable,
        style: Get.theme.textTheme.bodyMedium,
        onChanged: (value) {
          if (onTextChange != null) onTextChange(value);
        },
        decoration: InputDecoration(
            prefixIcon: countryPick,
            //prefixStyle: Get.theme.textTheme.bodyMedium,
            labelText: labelText,
            labelStyle: Get.theme.textTheme.bodyMedium,
            filled: false,
            isDense: true,
            hintText: hint,
            //hintStyle: Get.theme.textTheme.bodyMedium,
            enabledBorder: _textFieldBorder(borderRadius: borderRadius!),
            disabledBorder: _textFieldBorder(borderRadius: borderRadius),
            focusedBorder: _textFieldBorder(isFocus: true, borderRadius: borderRadius),
            suffixIcon: iconPath == null
                ? null
                : _buildTextFieldIcon(iconPath: iconPath, action: iconAction, color: Get.theme.primaryColorLight, size: Dimens.iconSizeMid)),
      ));
}

Widget textFieldWithWidget(
    {TextEditingController? controller,
    String? hint,
    String? text,
    String? labelText,
    Widget? suffixWidget,
    Widget? prefixWidget,
    TextInputType? type,
    bool isObscure = false,
    bool isEnable = true,
    bool readOnly = false,
    int maxLines = 1,
    double? width,
    double? borderRadius = 7,
    Function(String)? onTextChange}) {
  if (controller != null && text != null && text.isNotEmpty) {
    controller.text = text;
  }
  return Container(
      height: 50,
      width: width,
      padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        cursorColor: Get.theme.primaryColor,
        obscureText: isObscure,
        enabled: isEnable,
        readOnly: readOnly,
        style: Get.theme.textTheme.bodyMedium,
        onChanged: (value) {
          if (onTextChange != null) onTextChange(value);
        },
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: Get.theme.textTheme.bodyMedium,
            filled: false,
            isDense: true,
            hintText: hint,
            enabledBorder: _textFieldBorder(borderRadius: borderRadius!),
            disabledBorder: _textFieldBorder(borderRadius: borderRadius),
            focusedBorder: _textFieldBorder(isFocus: true, borderRadius: borderRadius),
            prefixIcon: prefixWidget,
            suffixIcon: suffixWidget),
      ));
}

Widget textFieldSearch({TextEditingController? controller, double? borderRadius = 7, Function()? onSearch, Function(String)? onTextChange}) {
  return Container(
      margin: const EdgeInsets.all(10),
      height: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        cursorColor: Get.theme.primaryColor,
        style: Get.theme.textTheme.bodyMedium,
        decoration: InputDecoration(
            filled: false,
            isDense: true,
            hintText: "Search".tr,
            enabledBorder: _textFieldBorder(borderRadius: borderRadius!),
            disabledBorder: _textFieldBorder(borderRadius: borderRadius),
            focusedBorder: _textFieldBorder(isFocus: true, borderRadius: borderRadius),
            suffixIcon: _buildTextFieldIcon(
              iconPath: AssetConstants.icSearch,
              color: Get.theme.primaryColorLight,
              size: Dimens.iconSizeMid,
              action: () {
                if (onSearch != null) onSearch();
              },
            )),
        onSubmitted: (value) {
          if (onSearch != null) onSearch();
        },
        onChanged: (value) {
          if (onTextChange != null) onTextChange(value);
        },
      ));
}

Widget textFieldWithPrefixSuffixText(
    {TextEditingController? controller,
    String? text,
    String? prefixText,
    String? suffixText,
    bool isEnable = true,
    double? width,
    Function(String)? onTextChange}) {
  if (controller != null && text != null) controller.text = text;
  return SizedBox(
      height: 50,
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        cursorColor: Get.theme.primaryColor,
        enabled: isEnable,
        style: Get.theme.textTheme.bodyMedium,
        textAlign: TextAlign.end,
        textAlignVertical: TextAlignVertical.center,
        onChanged: (value) {
          if (onTextChange != null) onTextChange(value);
        },
        decoration: InputDecoration(
            prefixIcon: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  hSpacer5(),
                  Text(prefixText ?? "", style: Get.textTheme.titleSmall?.copyWith(fontSize: Dimens.regularFontSizeMid)),
                  hSpacer5()
                ],
              ),
            ),
            filled: false,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            enabledBorder: _textFieldBorder(borderRadius: 7),
            disabledBorder: _textFieldBorder(borderRadius: 7),
            focusedBorder: _textFieldBorder(isFocus: true, borderRadius: 7),
            suffixIcon: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  hSpacer5(),
                  Text(suffixText ?? "",
                      style: Get.textTheme.titleSmall?.copyWith(fontSize: Dimens.regularFontSizeMid, color: Get.theme.colorScheme.secondary)),
                  hSpacer5()
                ],
              ),
            )),
        // decoration: InputDecoration(
        //     prefixIcon: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
        //       child: Text(prefixText ?? "", style: Get.textTheme.titleSmall?.copyWith(fontSize: Dimens.regularFontSizeMid)),
        //     ),
        //     filled: false,
        //     isDense: true,
        //     contentPadding: EdgeInsets.zero,
        //     enabledBorder: _textFieldBorder(borderRadius: 7),
        //     disabledBorder: _textFieldBorder(borderRadius: 7),
        //     focusedBorder: _textFieldBorder(isFocus: true, borderRadius: 7),
        //     suffixIcon: Padding(
        //       padding: const EdgeInsets.all(Dimens.paddingMid),
        //       child: Text(suffixText ?? "",
        //           style: Get.textTheme.titleSmall?.copyWith(fontSize: Dimens.regularFontSizeMid, color: Get.theme.colorScheme.secondary)),
        //     )),
      ));
}

Widget textFieldBordered(BuildContext context,
    {TextEditingController? controller,
    String? hint,
    double? width,
    String? text,
    bool enabled = true,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatter}) {
  if (controller != null && text != null && text.isNotEmpty) {
    controller.text = text;
  }
  return SizedBox(
      height: 50,
      width: width,
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: inputType,
        inputFormatters: inputFormatter,
        style: Get.theme.textTheme.bodyMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
        maxLines: 1,
        cursorColor: Get.theme.primaryColorDark,
        decoration: InputDecoration(
          filled: true,
          isDense: true,
          fillColor: Get.theme.primaryColor,
          hintText: hint,
          hintStyle: Get.theme.textTheme.labelSmall!.copyWith(fontWeight: FontWeight.normal),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Get.theme.shadowColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Get.theme.shadowColor),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(7)), borderSide: BorderSide(color: Get.theme.colorScheme.secondary)),
        ),
      ));
}

_textFieldBorder({bool isFocus = false, double borderRadius = 5}) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: BorderSide(width: 1, color: isFocus ? Get.theme.focusColor : Get.theme.dividerColor));
}

Widget _buildTextFieldIcon({String? iconPath, VoidCallback? action, Color? color, double? size}) {
  return InkWell(
    onTap: action,
    child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SvgPicture.asset(
          iconPath!,
          colorFilter: color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
          height: size,
          width: size,
        )),
  );
}

textFieldBorder({bool isFocus = false, double borderRadius = 5}) => _textFieldBorder(isFocus: isFocus, borderRadius: borderRadius);
