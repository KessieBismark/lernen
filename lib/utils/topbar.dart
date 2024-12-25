import 'package:flutter/material.dart';
import 'package:lernen/utils/theme_switch.dart';

class TopBar extends StatelessWidget {
  final Widget? widget;
  const TopBar({
    super.key,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget ?? Container(),
        const ThemeSwitch(),
      ],
    );
  }
}
