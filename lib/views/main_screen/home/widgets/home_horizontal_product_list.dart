import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/arguments/product_detail_arguments.dart';
import 'package:oxygen/models/local_products.dart';
import 'package:oxygen/services/hive_services.dart';

import '../../../../models/arguments/product_listing_arguments.dart';
import '../../../../models/home_data_model.dart';
import 'home_product_card.dart';
import 'home_title_tile.dart';

class HomeHorizontalProductList extends StatelessWidget {
  final String? title;
  final String? linkId;
  final List<HomeProducts>? products;

  const HomeHorizontalProductList(
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
          height: 295.h + (context.validateScale() * 40).h,
          width: double.maxFinite,
          child: ValueListenableBuilder<Box<LocalProducts>>(
              valueListenable:
                  Hive.box<LocalProducts>(HiveServices.instance.wishlistBoxName)
                      .listenable(),
              builder: (context, box, widget) {
                return ListView.separated(
                  padding: EdgeInsets.only(left: 12.w, right: 12.w),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    HomeProducts? product = products?[index];
                    return ProductHomeCardWidget(
                      sku: product?.sku ?? '',
                      box: box,
                      width: context.sw(size: .4453),
                      productName: product?.productName,
                      discountPrice: product?.price,
                      actualPrice: product?.regularPrice,
                      discount: product?.discount,
                      warningTag: product?.onlyFewProductsLeft,
                      image: product?.images?.mobile2x ?? '',
                      tag: product?.tag,
                      isWishListed:
                          box.get(product?.sku ?? '')?.isFavourite ?? false,
                      offerSticker: product?.productSticker?.imageUrl,
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteGenerator.routeProductDetailScreen,
                            arguments: ProductDetailsArguments(
                                sku: product?.sku ?? '',
                                isFromInitialState: true));
                      },
                      navPath: RouteGenerator.routeMainScreen,
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
