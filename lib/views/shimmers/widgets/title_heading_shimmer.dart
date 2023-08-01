import 'package:flutter/material.dart';
import 'package:oxygen/common/extensions.dart';

class TitleHeadingShimmer extends StatelessWidget {
  const TitleHeadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: context.sw(size: 0.0587),
          width: context.sw(size: 0.336),
          color: Colors.white,
        ),
        Container(
          height: context.sw(size: 0.0587),
          width: context.sw(size: 0.184),
          color: Colors.white,
        )
      ],
    );
  }
}
