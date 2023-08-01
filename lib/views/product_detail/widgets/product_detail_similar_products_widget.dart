import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/local_products.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/dynamic_product_card_widget.dart';
import 'package:provider/provider.dart';

class ProductDetailSimilarProductsWidget extends StatelessWidget {
  const ProductDetailSimilarProductsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProductDetailProvider, List<Item?>?>(
        selector: (context, provider) => provider.relatedProducts,
        builder: (context, value, child) {
          return LayoutBuilder(builder: (context, constraints) {
            return (value == null || (value.isEmpty))
                ? const SizedBox.shrink()
                : Container(
                    width: double.maxFinite,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 18.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                            ),
                            child: Text(
                              Constants.similarProducts,
                              style: FontPalette.black18Medium,
                            ),
                          ),
                          11.verticalSpace,
                          SizedBox(
                            height: 300.h +
                                (context.validateScale(defaultVal: 0.0) * 40).h,
                            width: double.maxFinite,
                            child: ValueListenableBuilder<Box<LocalProducts>>(
                                valueListenable: Hive.box<LocalProducts>(
                                        HiveServices.instance.wishlistBoxName)
                                    .listenable(),
                                builder: (context, box, child) {
                                  return ListView.separated(
                                    itemCount: value.length,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final similarItem =
                                          value.elementAt(index);
                                      return GestureDetector(
                                        onTap: () {
                                          NavRoutes.instance
                                              .navToProductDetailScreen(context,
                                                  sku: similarItem?.sku,
                                                  item: similarItem);
                                        },
                                        child: DynamicProductCardWidget(
                                          width: constraints.maxWidth * .4453,
                                          sku: similarItem?.sku ?? "",
                                          box: box,
                                          isWishListed: ((box
                                                  .get(similarItem?.sku ?? '')
                                                  ?.isFavourite ??
                                              false)),
                                          productName: similarItem?.name,
                                          shortNote: similarItem?.highlight,
                                          discountPrice: similarItem?.priceRange
                                              ?.maximumPrice?.finalPrice?.value
                                              ?.toString(),
                                          actualPrice: similarItem
                                              ?.priceRange
                                              ?.maximumPrice
                                              ?.regularPrice
                                              ?.value
                                              ?.toString(),
                                          discount: similarItem
                                              ?.priceRange
                                              ?.maximumPrice
                                              ?.discount
                                              ?.percentOff
                                              ?.round()
                                              .toString(),
                                          warningTag:
                                              similarItem?.qtyLeftInStock,
                                          image: similarItem?.smallImage?.url,
                                          onFavouritesPressed: () {
                                            HiveServices.instance.saveNavPath(
                                                RouteGenerator
                                                    .routeProductDetailScreen);
                                            CommonFunctions.addToWishList(
                                                context,
                                                box: box,
                                                sku: similarItem?.sku ?? '',
                                                name: similarItem?.name);
                                          },
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        6.horizontalSpace,
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  );
          });
        });
  }
}
