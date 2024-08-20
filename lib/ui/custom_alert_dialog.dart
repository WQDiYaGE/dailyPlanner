import 'package:flutter/material.dart';
import 'package:daily_planner/services/theme_services.dart';
import 'package:daily_planner/ui/theme.dart';

class CustomAlertDialog extends StatelessWidget {
  final Color bgColor;
  final String? title;
  final String? message;
  final String positiveBtnText;
  final String? negativeBtnText;
  final Function onPostivePressed;
  final Function? onNegativePressed;
  final double circularBorderRadius;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.circularBorderRadius = 15.0,
    required this.bgColor,
    required this.positiveBtnText,
    this.negativeBtnText,
    required this.onPostivePressed,
    this.onNegativePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null
          ? Text(
              title!,
              style: headingStyle,
            )
          : null,
      content:
          message != null ? Text(message!, style: subHeadingNormalStyle) : null,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      actions: <Widget>[
        negativeBtnText != null
            ? TextButton(
                child: Text(
                  negativeBtnText!,
                  style: TextStyle(color: ColorConstants.buttonColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onNegativePressed != null) {
                    onNegativePressed!();
                  }
                },
              )
            : Container(),
        // ignore: unnecessary_null_comparison
        positiveBtnText != null
            ? TextButton(
                child: Text(
                  positiveBtnText,
                  style: TextStyle(color: ColorConstants.buttonColor),
                ),
                onPressed: () {
                  onPostivePressed();
                                },
              )
            : Container(),
      ],
    );
  }
}
