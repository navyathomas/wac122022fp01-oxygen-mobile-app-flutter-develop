import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/category_detailed_model.dart';
import 'package:oxygen/models/local_products.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/dynamic_category_product_widget.dart';

import '../../../common/constants.dart';
import '../../../generated/assets.dart';
import '../../../models/arguments/product_listing_arguments.dart';

class CategoryDetailedOwlCarouselProducts extends StatelessWidget {
  final String? title;
  final String? titleColor;
  final List<Product?>? products;
  final String? linkId;

  const CategoryDetailedOwlCarouselProducts(
      {Key? key, this.title, this.titleColor, this.products, this.linkId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidth = context.sw(size: .4453);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title ?? "",
                  style: FontPalette.black20Medium
                      .copyWith(color: HexColor(titleColor ?? "#000000")),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                      context, RouteGenerator.routeProductListingScreen,
                      arguments: ProductListingArguments(
                          categoryId: linkId!, title: title ?? ''));
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
                  child: Row(
                    children: [
                      Text(
                        linkId != null ? Constants.viewAll : '',
                        style: FontPalette.black16Regular,
                      ),
                      5.horizontalSpace,
                      linkId != null
                          ? SvgPicture.asset(
                              Assets.iconsRightArrow,
                              height: 12.h,
                              width: 6.w,
                            )
                          : 12.verticalSpace
                    ],
                  ),
                ),
              ).removeSplash(),
            ],
          ),
        ),
        SizedBox(
          height: 295.h + (context.validateScale() * 40).h,
          width: double.maxFinite,
          child: ValueListenableBuilder<Box<LocalProducts>>(
              valueListenable:
                  Hive.box<LocalProducts>(HiveServices.instance.wishlistBoxName)
                      .listenable(),
              builder: (context, box, child) {
                return ListView.separated(
                  itemCount: products?.length ?? 0,
                  padding: EdgeInsets.only(left: 12.w, right: 12.w),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = products?.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        NavRoutes.instance.navToProductDetailScreen(context,
                            sku: item?.sku, isFromInitialState: true);
                      },
                      child: DynamicCategoryProductWidget(
                        width: cardWidth,
                        sku: item?.sku ?? "",
                        isWishListed:
                            ((box.get(item?.sku ?? '')?.isFavourite ?? false)),
                        productName: item?.productName,
                        shortNote: item?.shortNote,
                        discountPrice: item?.regularPrice,
                        actualPrice: item?.price,
                        discount: item?.discount,
                        image: item?.image,
                        warningTag: item?.onlyFewProductsLeft,
                        offerSticker: item?.productSticker?.imageUrl,
                        onFavouritesPressed: () {
                          HiveServices.instance.saveNavPath(
                              RouteGenerator.routeCategoryDetailedScreen);
                          CommonFunctions.addToWishList(context,
                              box: box,
                              sku: item?.sku ?? '',
                              name: item?.productName);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => 6.horizontalSpace,
                );
              }),
        ),
        18.verticalSpace,
      ],
    ).convertToSliver();
  }
}
