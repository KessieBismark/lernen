import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/theme_provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
              alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(46, 33, 67, 83),
              spreadRadius: 1.5,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
          color: Colors.transparent,
        ),
        child: IconButton(
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
          icon: Icon(
            Provider.of<ThemeProvider>(context).isDarkTheme
                ? Icons.light_mode
                : Icons.dark_mode,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}