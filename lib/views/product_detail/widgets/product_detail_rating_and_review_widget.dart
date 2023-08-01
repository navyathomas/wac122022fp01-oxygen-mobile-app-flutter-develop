import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_outline_button.dart';
import 'package:provider/provider.dart';

class ProductDetailRatingAndReviewWidget extends StatelessWidget {
  const ProductDetailRatingAndReviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProductDetailProvider>();
    return LayoutBuilder(builder: (context, constraints) {
      return Selector<ProductDetailProvider, Reviews?>(
          selector: (context, provider) => provider.reviews,
          builder: (context, value, child) {
            return Container(
              color: Colors.white,
              width: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 18.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            Constants.ratingsAndReviews,
                            style: FontPalette.black16Medium,
                            maxLines: 1,
                          ),
                        ),
                        (value?.items?.isEmpty ?? true)
                            ? const SizedBox.shrink()
                            : GestureDetector(
                                onTap: () {
                                  NavRoutes.instance
                                      .navToProductDetailRatingsAndReviewsScreen(
                                          context,
                                          sku: model.selectedItem?.sku);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      Constants.viewAll,
                                      style: FontPalette.black16Regular,
                                    ),
                                    3.horizontalSpace,
                                    SizedBox(
                                      height: 12.r,
                                      width: 12.r,
                                      child: SvgPicture.asset(
                                          Assets.iconsRightArrow),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                    24.verticalSpace,
                    if (value?.items?.isEmpty ?? true)
                      Container(
                        color: HexColor("#F4F4F4"),
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 50.w),
                        child: Text(Constants.noReviewsYet,
                            textAlign: TextAlign.center,
                            style: FontPalette.black12Regular),
                      ),
                    if (value != null && (value.items?.isNotEmpty ?? false))
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.items?.length ?? 0,
                        itemBuilder: (context, index) {
                          final review = value.items?.elementAt(index);
                          return _BuildRow(
                            summary: review?.summary?.trim(),
                            text: review?.text?.trim(),
                            name: review?.name?.trim(),
                            createdAt: review?.createdAt?.trim(),
                            ratingValue: review?.ratingValue,
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          height: 40,
                          thickness: 1,
                          color: HexColor("#DBDBDB"),
                        ),
                      ),
                    20.verticalSpace,
                    CustomOutlineButton(
                      onPressed: () async {
                        final res = await Navigator.pushNamed(context,
                            RouteGenerator.routeSubmitRatingsAndReviewsScreen,
                            arguments: model.selectedItem);
                        if (res != null && res as bool) {
                          model.scrollController.animateTo(0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn);
                        }
                      },
                      title: Constants.rateYourProduct,
                    ),
                  ],
                ),
              ),
            );
          });
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
                summary ?? "",
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
          text ?? "",
          style: FontPalette.black14Regular,
        ),
        10.verticalSpace,
        Text(
          name ?? "",
          style: FontPalette.black14Medium,
        ),
        4.verticalSpace,
        Text(
          createdAt ?? "",
          style: FontPalette.f7E818C_12Regular,
        ),
      ],
    );
  }
}
