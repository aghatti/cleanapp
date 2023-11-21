import 'package:flutter/material.dart';

class PlaceholderDialog extends StatelessWidget {
  const PlaceholderDialog({
    this.icon,
    this.title,
    this.message,
    this.actions = const [],
    Key? key,
  }) : super(key: key);

  final Widget? icon;
  final String? title;
  final String? message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    ThemeData appStyle = Theme.of(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return
      AlertDialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: (width-150)/2.0, vertical: (height-150)/2.0),
      icon: icon,
      title: title == null
          ? null
          : Text(
        title!,
        textAlign: TextAlign.center,
        style: appStyle.textTheme.headlineSmall,
      ),
      titleTextStyle: appStyle.textTheme.bodyLarge,
      content:
      ConstrainedBox(constraints: const BoxConstraints(maxWidth: 150, maxHeight: 150),
        child:
        message == null
            ? null
            : Text(
          message!,
          textAlign: TextAlign.center,
        ),
      ),
      contentTextStyle: appStyle.textTheme.bodyMedium,
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowButtonSpacing: 8.0,
      actions: actions,
    );
  }
}