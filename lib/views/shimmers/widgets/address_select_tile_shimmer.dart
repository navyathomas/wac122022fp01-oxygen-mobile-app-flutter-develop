import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';

class AddressSelectTileShimmer extends StatelessWidget {
  const AddressSelectTileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 18.h,
              width: 18.w,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
            ),
            14.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 24.h, width: 150.w, color: Colors.white),
                5.verticalSpace,
                Container(height: 24.h, width: 290.w, color: Colors.white),
                5.verticalSpace,
                Container(height: 24.h, width: 290.w, color: Colors.white),
                10.verticalSpace
              ],
            ),
          ],
        ).addShimmer();
      },
    );
  }
}
