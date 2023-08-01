import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';

class ProductDetailEarnPointsWidget extends StatelessWidget {
  const ProductDetailEarnPointsWidget({
    Key? key,
  }) : super(key: key);

  void showBottomSheet(BuildContext context, {String? rewardPointsText}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        width: double.maxFinite,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Constants.aboutLoyaltyPoints,
                    style: FontPalette.black16Medium,
                  ),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox.square(
                            dimension: 17.25.r,
                            child: SvgPicture.asset(Assets.iconsCloseGrey)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 1.h,
              thickness: 1.h,
              color: HexColor("#E6E6E6"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
              child: Text(
                rewardPointsText ?? "",
                style: FontPalette.f282C3F_14Regular,
              ),
            ),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ProductDetailProvider, Item?>(
        selector: (context, provider) => provider.selectedItem,
        builder: (context, value, child) {
          return ((value?.rewardPoints ?? 0) <= 0 ||
                  value?.rewardPointsText == null)
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.white,
                  width: double.maxFinite,
                  padding:
                      EdgeInsets.symmetric(vertical: 18.h, horizontal: 14.w),
                  margin: EdgeInsets.only(bottom: 5.h),
                  child: Row(
                    children: [
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: Constants.youWillEarn,
                                style: FontPalette.black14Regular,
                              ),
                              WidgetSpan(child: 6.horizontalSpace),
                              WidgetSpan(
                                child: SizedBox.square(
                                        dimension: 15.27.r,
                                        child: SvgPicture.asset(
                                            Assets.iconsEarnPoints))
                                    .translateWidgetVertically(value: -1.2),
                              ),
                              WidgetSpan(child: 6.horizontalSpace),
                              TextSpan(
                                text:
                                    "${value?.rewardPoints ?? ""} ${Constants.points}",
                                style: FontPalette.black14Medium,
                              ),
                              WidgetSpan(child: 6.horizontalSpace),
                              TextSpan(
                                text: Constants.onThisOrder,
                                style: FontPalette.black14Regular,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            showBottomSheet(context,
                                rewardPointsText: value?.rewardPointsText);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox.square(
                                dimension: 12.27.r,
                                child:
                                    SvgPicture.asset(Assets.iconsDisclaimer)),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        });
  }
}
