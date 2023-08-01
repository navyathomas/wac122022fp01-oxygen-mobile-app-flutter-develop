import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/color_palette.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            strokeWidth: 4.0,
            valueColor:
                AlwaysStoppedAnimation<Color>(ColorPalette.primaryColor),
          ),
        ),
      ),
    );
  }
}
