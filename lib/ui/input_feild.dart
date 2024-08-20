import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:daily_planner/services/theme_services.dart';
import 'package:daily_planner/ui/theme.dart';

class TextInputFeild extends StatelessWidget {
  final String hint;
  final String label;
  final Widget? widget;
  final TextEditingController? controller;
  final String? initialInput;
  final int? isDisabled;
  final int? maxLength;

  const TextInputFeild(
      {super.key,
      required this.label,
      required this.hint,
      required this.widget,
      required this.controller,
      this.maxLength,
      this.initialInput,
      this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: inputLabelTextStyle),
          Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                    color: ColorConstants.buttonColor
                        .withOpacity(Get.isDarkMode ? 0.6 : 0.4)),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                        inputFormatters: [
                      LengthLimitingTextInputFormatter(maxLength ?? 100),

                      /// here char limit is 5
                    ],
                        enabled: isDisabled == 1 ? false : true,
                        initialValue: initialInput,
                        controller: controller,
                        cursorColor: ColorConstants.buttonColor,
                        readOnly: widget == null ? false : true,
                        decoration: InputDecoration(
                            hintText: hint,
                            hintStyle: inputHintTextStyle,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            border: InputBorder.none))),
                widget == null ? Container() : Container(child: widget)
              ]))
        ],
      ),
    );
  }
}
