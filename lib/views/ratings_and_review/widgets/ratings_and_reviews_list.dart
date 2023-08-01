import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/models/reviews_model.dart';
import 'package:oxygen/providers/ratings_and_reviews_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';

class RatingsAndReviewsList extends StatelessWidget {
  const RatingsAndReviewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<RatingsAndReviewsProvider, List<ProductReviewsItem?>?>(
        selector: (context, provider) => provider.reviewList,
        builder: (context, value, child) {
          return SliverList(
              delegate: SliverChildBuilderDelegate(
            childCount: value?.length,
            (context, index) {
              final item = value?.elementAt(index);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: Column(
                  children: [
                    _BuildRow(
                      ratingValue: item?.ratingValue,
                      summary: item?.summary,
                      text: item?.text,
                      name: item?.nickname,
                      createdAt: item?.createdAt,
                    ),
                    if (index != (value?.length ?? -1) - 1)
                      Divider(
                        height: 25.h,
                        thickness: 1.h,
                        color: HexColor("#DBDBDB"),
                      )
                  ],
                ),
              );
            },
          ));
        });
  }
}

class _BuildRow extends StatelessWidget {
  final String? summary;
  final String? text;
  final String? name;
  final String? createdAt;
  final double? ratingValue;

  const _BuildRow({
    Key? key,
    this.summary,
    this.text,
    this.name,
    this.createdAt,
    this.ratingValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                summary?.trim() ?? "",
                maxLines: 1,
                style: FontPalette.black15Medium,
              ),
            ),
            6.5.horizontalSpace,
            RatingBar.builder(
              ignoreGestures: true,
              initialRating: ratingValue ?? 0.0,
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
            )
          ],
        ),
        12.verticalSpace,
        Text(
          text?.trim() ?? "",
          style: FontPalette.black14Regular,
        ),
        10.verticalSpace,
        Text(
          name?.trim() ?? "",
          style: FontPalette.black14Medium,
        ),
        4.verticalSpace,
        Text(
          createdAt?.trim() ?? "",
          style: FontPalette.f7E818C_12Regular,
        ),
      ],
    );
  }
}
