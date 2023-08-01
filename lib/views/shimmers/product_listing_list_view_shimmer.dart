import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';

class ProductListingListViewShimmer extends StatelessWidget {
  const ProductListingListViewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 10,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: context.sw(size: 0.12),
                width: context.sw(size: 0.12),
                color: Colors.white,
              ),
              19.horizontalSpace,
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 14.h,
                              width: constraints.maxWidth * .5107,
                              color: Colors.white),
                          Container(
                              height: 14.h,
                              width: constraints.maxWidth * .1857,
                              color: Colors.white),
                        ],
                      ),
                      16.verticalSpace,
                      Container(
                          height: 14.h,
                          width: double.maxFinite,
                          color: Colors.white),
                      16.verticalSpace,
                      Container(
                          height: 14.h,
                          width: double.maxFinite,
                          color: Colors.white),
                    ],
                  );
                }),
              )
            ],
          ),
        ).addShimmer();
      },
      separatorBuilder: (BuildContext context, int index) {
        return 50.verticalSpace;
      },
    );
  }
}
