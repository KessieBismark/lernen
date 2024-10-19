import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/utils/theme_switch.dart';

import '../entries_fold/entry.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () => Get.to(() => Entries()),
            icon: Icon(Icons.edit)),
        const ThemeSwitch(),
      ],
    );
  }
}