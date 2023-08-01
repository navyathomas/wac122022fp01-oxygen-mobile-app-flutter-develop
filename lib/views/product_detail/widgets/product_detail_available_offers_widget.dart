import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/bank_offers_model.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';

class ProductDetailAvailableOffersWidget extends StatelessWidget {
  const ProductDetailAvailableOffersWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProductDetailProvider, GetBankOffersByProductSku?>(
        selector: (context, provider) => provider.getBankOffersByProductSku,
        builder: (context, value, child) {
          return (value?.bankOfferDetail == null ||
                  (value?.bankOfferDetail?.isEmpty ?? true))
              ? const SizedBox.shrink()
              : LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    color: Colors.white,
                    width: double.maxFinite,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(
                              value?.title ?? "",
                              style: FontPalette.black16Medium,
                            ),
                          ),
                          14.verticalSpace,
                          SizedBox(
                            height: context.sh(size: .1425),
                            child: ListView.builder(
                              padding: EdgeInsets.only(left: 12.w),
                              scrollDirection: Axis.horizontal,
                              itemCount: value?.bankOfferDetail?.length ?? 0,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item =
                                    value?.bankOfferDetail?.elementAt(index);
                                return _OffersCard(
                                  onTap: () async {
                                    NavRoutes.instance
                                        .navToProductDetailTermsAndConditionsScreen(
                                            context,
                                            identifier: item?.identifier);
                                  },
                                  width: constraints.maxWidth * .48,
                                  title: item?.title,
                                  description: item?.description,
                                  linkLabel: item?.linkLabel,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
        });
  }
}

class _OffersCard extends StatelessWidget {
  final double width;
  final String? title;
  final String? description;
  final String? linkLabel;
  final void Function()? onTap;

  const _OffersCard({
    Key? key,
    required this.width,
    this.title,
    this.description,
    this.linkLabel,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(
          horizontal: 13.w,
          vertical: 17.83.h,
        ),
        height: double.maxFinite,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.r,
            color: HexColor("#DBDBDB"),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox.square(
              dimension: 13.45.r,
              child: SvgPicture.asset(Assets.iconsOfferTag),
            ),
            6.55.horizontalSpace,
            if (title != null && description != null)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "$title On $description"
                            .trim()
                            .replaceAll('', '\u200B'),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: FontPalette.black14Regular,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      linkLabel ?? "",
                      style: FontPalette.black14Regular,
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
