import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/reviews_model.dart';
import 'package:oxygen/providers/ratings_and_reviews_provider.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';

class RatingsAndReviewsTopWidget extends StatelessWidget {
  const RatingsAndReviewsTopWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<RatingsAndReviewsProvider, ProductsItem?>(
        selector: (context, provider) => provider.reviewsProductItem,
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            child: Row(
              children: [
                Row(
                  children: [
                    28.horizontalSpace,
                    Column(
                      children: [
                        Text(
                          value?.ratingAggregationValue?.toString() ?? "0.0",
                          style: FontPalette.black26Medium,
                        ),
                        4.verticalSpace,
                        RatingBar.builder(
                          ignoreGestures: true,
                          initialRating: value?.ratingAggregationValue ?? 0.0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          glow: false,
                          itemCount: 5,
                          itemSize: 16.r,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: HexColor("#179614"),
                          ),
                          onRatingUpdate: (double value) {},
                        ),
                        9.verticalSpace,
                        if (value?.productReviewCount != null)
                          Text(
                            "${value?.productReviewCount ?? " "} Ratings",
                            style: FontPalette.f7E818C_14Regular,
                          )
                      ],
                    ),
                    40.horizontalSpace,
                    Container(
                      height: 77.5,
                      width: 1.r,
                      color: HexColor("#DBDBDB"),
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 31.5.w, right: 25.w),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value?.ratingSummaryData?.length ?? 0,
                      itemBuilder: (context, index) {
                        final summaryItem =
                            value?.ratingSummaryData?.elementAt(index);
                        return Row(
                          children: [
                            Text(
                              summaryItem?.ratingValue?.toInt().toString() ??
                                  "",
                              style: FontPalette.f7E818C_11Regular,
                            ),
                            10.horizontalSpace,
                            Expanded(
                              child: Container(
                                height: 4.r,
                                color: HexColor("#E6E6E6"),
                                alignment: Alignment.centerLeft,
                                child: RatingFraction(
                                    summaryItem: summaryItem, value: value),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ).convertToSliver();
        });
  }
}

class RatingFraction extends StatefulWidget {
  const RatingFraction({
    Key? key,
    required this.summaryItem,
    required this.value,
  }) : super(key: key);

  final RatingSummaryDatum? summaryItem;
  final ProductsItem? value;

  @override
  State<RatingFraction> createState() => _RatingFractionState();
}

class _RatingFractionState extends State<RatingFraction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late Animation<double> expandingAnimation;

  @override
  void initState() {
    super.initState();
    expandingAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: expandingAnimation,
        builder: (_, __) {
          return FractionallySizedBox(
            widthFactor: ((widget.summaryItem?.ratingCount ?? 0) *
                    expandingAnimation.value) /
                Helpers.convertToDouble(widget.value?.productReviewCount),
            child: Container(
              height: 4.r,
              color: HexColor("#179614"),
            ),
          );
        });
  }
}
