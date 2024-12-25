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

// class MWaiting extends StatelessWidget {
//   const MWaiting({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return LoadingAnimationWidget.inkDrop(
//       color: voilet,
//           // leftDotColor: const Color(0xFF1A1A3F),
//           // rightDotColor: const Color(0xFFEA3799),
//           size: 30,
//         )
//         .center;
//   }
// }
