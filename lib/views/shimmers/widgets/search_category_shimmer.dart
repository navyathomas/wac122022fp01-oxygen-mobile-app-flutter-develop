import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';

class SearchCategoryShimmer extends StatelessWidget {
  const SearchCategoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          23.verticalSpace,
          Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  height: 24.h,
                  width: 154.w,
                  color: Colors.white)
              .addShimmer(),
          16.verticalSpace,
          LayoutBuilder(builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 8,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 15.r,
                    mainAxisSpacing: 15.r,
                    mainAxisExtent: constraints.maxWidth * .3334),
                itemBuilder: (BuildContext context, int index) {
                  return LayoutBuilder(builder: (context, constraints) {
                    return Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(25.r),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ).addShimmer(),
                        ),
                        20.verticalSpace,
                        Container(height: 20.h, color: Colors.white)
                            .addShimmer(),
                      ],
                    );
                  });
                },
              ),
            );
          }),
          // 28.verticalSpace,
          // Container(
          //         margin: EdgeInsets.symmetric(horizontal: 12.w),
          //         height: 24.h,
          //         width: 113.w,
          //         color: Colors.white)
          //     .addShimmer(),
          // 16.verticalSpace,
          // LayoutBuilder(builder: (context, constraints) {
          //   return Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 12.w),
          //     child: GridView.builder(
          //       shrinkWrap: true,
          //       physics: const NeverScrollableScrollPhysics(),
          //       itemCount: 8,
          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //           crossAxisCount: 4,
          //           crossAxisSpacing: 15.r,
          //           mainAxisSpacing: 15.r,
          //           mainAxisExtent: constraints.maxWidth * .3334),
          //       itemBuilder: (BuildContext context, int index) {
          //         return LayoutBuilder(builder: (context, constraints) {
          //           return Column(
          //             children: [
          //               Expanded(
          //                 child: Container(
          //                   padding: EdgeInsets.all(25.r),
          //                   decoration: const BoxDecoration(
          //                     color: Colors.white,
          //                     shape: BoxShape.circle,
          //                   ),
          //                 ).addShimmer(),
          //               ),
          //               20.verticalSpace,
          //               Container(height: 20.h, color: Colors.white)
          //                   .addShimmer(),
          //             ],
          //           );
          //         });
          //       },
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }
}
