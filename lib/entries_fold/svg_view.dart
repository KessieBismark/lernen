import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SVGView extends StatelessWidget {
  const SVGView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Possessive Pronouns'),
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
            child: RotationTransition(
          turns: AlwaysStoppedAnimation(90 / 360),
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 5,
            child: SvgPicture.asset(
              'assets/svg/possessive-pronoun_chart.svg',
              // You can provide additional properties for customization
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        )),
      ),
    );
  }
}
