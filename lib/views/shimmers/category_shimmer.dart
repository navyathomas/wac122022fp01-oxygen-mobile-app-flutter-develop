import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';

import '../../utils/font_palette.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          28.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text('',
                style: FontPalette.black18Medium.copyWith(letterSpacing: .3.w)),
          ),
          20.verticalSpace,
          LayoutBuilder(builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 16,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.r,
                    mainAxisSpacing: 20.r,
                    mainAxisExtent: context.sw(size: .3547)),
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
                          ),
                        ),
                        6.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text('\n\n',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: FontPalette.black13Regular),
                        ),
                      ],
                    );
                  });
                },
              ),
            );
          }),
        ],
      ).addShimmer(),
    );
  }
}
