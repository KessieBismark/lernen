import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MLabel extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final bool bold;
  final bool selectable;
  const MLabel(
    this.title, {
    this.fontSize,
    this.color,
    this.selectable = false,
    this.bold = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return selectable ? SelectableText(
      title,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          overflow: TextOverflow.ellipsis),
    ):Text(
      title,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          overflow: TextOverflow.ellipsis),
    );
  }
}

class MAutoText extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final bool bold;
  const MAutoText(
    this.title, {
    this.fontSize,
    this.color,
    this.bold = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      title,
      maxLines: 2,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          overflow: TextOverflow.ellipsis,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal),
    );
  }
}
