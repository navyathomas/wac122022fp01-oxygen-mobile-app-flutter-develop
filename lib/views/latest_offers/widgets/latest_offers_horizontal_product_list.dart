import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/models/arguments/product_listing_arguments.dart';
import 'package:oxygen/models/latest_offers_data_model.dart';
import 'package:oxygen/models/local_products.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/views/main_screen/home/widgets/home_product_card.dart';
import 'package:oxygen/views/main_screen/home/widgets/home_title_tile.dart';

import '../../../common/route_generator.dart';

class LatestOffersHorizontalProductList extends StatelessWidget {
  final String? title;
  final String? linkId;
  final List<LatestOffersProducts>? products;

  const LatestOffersHorizontalProductList(
      {Key? key, this.title, this.products, this.linkId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeTitleTile(
          title: title,
          onTap: linkId.notEmpty
              ? () {
                  Navigator.pushNamed(
                      context, RouteGenerator.routeProductListingScreen,
                      arguments: ProductListingArguments(
                          categoryId: linkId!, title: title ?? ''));
                }
              : null,
        ),
        SizedBox(
          height: 300.h + (context.validateScale() * 40).h,
          width: double.maxFinite,
          child: ValueListenableBuilder<Box<LocalProducts>>(
              valueListenable:
                  Hive.box<LocalProducts>(HiveServices.instance.wishlistBoxName)
                      .listenable(),
              builder: (context, box, widget) {
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    LatestOffersProducts? product = products?[index];
                    return GestureDetector(
                      onTap: () {
                        NavRoutes.instance.navToProductDetailScreen(context,
                            sku: products?[index].sku,
                            isFromInitialState: true);
                      },
                      child: ProductHomeCardWidget(
                        sku: product?.sku ?? '',
                        box: box,
                        width: context.sw(size: .4453),
                        productName: product?.productName,
                        discountPrice: product?.price,
                        actualPrice: product?.regularPrice,
                        discount: product?.discount.toString(),
                        warningTag: product?.onlyFewProductsLeft,
                        image: product?.images?.mobile2x ?? '',
                        tag: product?.tag,
                        isWishListed:
                            box.get(product?.sku ?? '')?.isFavourite ?? false,
                        offerSticker: product?.productSticker?.imageUrl,
                        navPath: RouteGenerator.routeLatestOffersScreen,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => 6.horizontalSpace,
                  itemCount: products?.length ?? 0,
                );
              }),
        )
      ],
    ).convertToSliver();
  }
}
