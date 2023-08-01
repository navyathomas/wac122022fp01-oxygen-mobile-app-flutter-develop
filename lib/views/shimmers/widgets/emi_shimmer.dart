import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';

class EmiShimmer extends StatelessWidget {
  const EmiShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sw(size: 0.0587),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildEmiContainer(context),
          25.horizontalSpace,
          _buildEmiContainer(context),
          25.horizontalSpace,
          _buildEmiContainer(context),
          25.horizontalSpace,
          _buildEmiContainer(context),
          25.horizontalSpace,
          _buildEmiContainer(context),
        ],
      ),
    );
  }

  Container _buildEmiContainer(BuildContext context) {
    return Container(
      height: context.sw(size: 0.0587),
      width: context.sw(size: 0.184),
      color: Colors.white,
    );
  }
}
