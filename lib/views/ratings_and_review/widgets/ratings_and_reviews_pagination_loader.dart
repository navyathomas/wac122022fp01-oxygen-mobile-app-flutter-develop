import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/providers/ratings_and_reviews_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:provider/provider.dart';

class RatingsAndReviewsPaginationLoader extends StatelessWidget {
  const RatingsAndReviewsPaginationLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<RatingsAndReviewsProvider, bool>(
        selector: (context, provider) => provider.reviewsPaginationEnabled,
        builder: (context, value, child) {
          return SliverToBoxAdapter(
              child: value
                  ? Center(
                      child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: SizedBox(
                        height: 30.r,
                        width: 30.r,
                        child: CircularProgressIndicator(
                            color: ColorPalette.primaryColor),
                      ),
                    ))
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: SizedBox(
                        height: 30.r,
                        width: 30.r,
                      ),
                    ));
        });
  }
}
