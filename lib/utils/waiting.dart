import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/utils/extension.dart';

class MWaiting extends StatelessWidget {
  const MWaiting({super.key});

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isAndroid
        ? const CircularProgressIndicator().center
        : const CupertinoActivityIndicator().center;
  }
}

class MWaitingNoCenter extends StatelessWidget {
  const MWaitingNoCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isAndroid
        ? const CircularProgressIndicator()
        : const CupertinoActivityIndicator();
  }
}
