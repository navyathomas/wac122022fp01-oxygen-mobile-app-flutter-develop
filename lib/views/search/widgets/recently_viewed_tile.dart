import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/models/recently_viewed_list_response.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

class RecentlyViewedTile extends StatelessWidget {
  List<GetRecentlyviewedProducts> getRecentlyViewedProductsList;

  RecentlyViewedTile({Key? key, required this.getRecentlyViewedProductsList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          18.verticalSpace,
          Text(
            Constants.recentlyViewed,
            style: FontPalette.black16Medium,
          ),
          12.verticalSpace,
          SizedBox(
            height: 120.h,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: getRecentlyViewedProductsList.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => NavRoutes.instance.navToProductDetailScreen(
                      context,
                      sku: getRecentlyViewedProductsList[index].sku ?? '',
                      isFromInitialState: true),
                  child: Container(
                    width: 83.w,
                    margin: EdgeInsets.only(right: 5.w),
                    decoration: BoxDecoration(
                        border: Border.all(color: HexColor('#E6E6E6'))),
                    child: Column(
                      children: [
                        Expanded(
                          child: CommonFadeInImage(
                              image: getRecentlyViewedProductsList[index]
                                      .smallImage
                                      ?.url ??
                                  ''),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.5.w),
                          child: Text(
                            getRecentlyViewedProductsList[index].name ?? '',
                            style: FontPalette.black12Regular,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ).avoidOverFlow(maxLine: 2),
                        ),
                        11.verticalSpace,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
