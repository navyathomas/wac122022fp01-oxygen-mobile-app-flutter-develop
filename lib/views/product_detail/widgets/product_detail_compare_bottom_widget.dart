import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/compare_products_model.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/repositories/compare_repo.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

import '../../../utils/color_palette.dart';

class ProductDetailCompareBottomWidget extends StatefulWidget {
  final Item? item;

  const ProductDetailCompareBottomWidget({Key? key, this.item})
      : super(key: key);

  @override
  State<ProductDetailCompareBottomWidget> createState() =>
      _ProductDetailCompareBottomWidgetState();
}

class _ProductDetailCompareBottomWidgetState
    extends State<ProductDetailCompareBottomWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<CompareProducts>>(
      valueListenable:
          Hive.box<CompareProducts>(HiveServices.instance.compareProductBoxName)
              .listenable(),
      builder: (context, box, child) {
        return ColoredBox(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              10.verticalSpace,
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(Constants.removeOneProduct,
                        style: FontPalette.black18Medium),
                  )),
              2.verticalSpace,
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(Constants.youCanCompareThreeProducts,
                        style: FontPalette.f7E818C_12Regular),
                  )),
              20.verticalSpace,
              _CompareProductListView(
                compareProductsList: [...box.values],
                item: widget.item,
              ),
              10.verticalSpace,
            ],
          ),
        );
      },
    );
  }
}

class _CompareProductListView extends StatelessWidget {
  final Item? item;

  const _CompareProductListView(
      {Key? key, required this.compareProductsList, this.item})
      : super(key: key);
  final List<CompareProducts> compareProductsList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: index == 1
                          ? EdgeInsets.symmetric(horizontal: 51.w)
                          : EdgeInsets.zero,
                      child: (index + 1 <= compareProductsList.length
                              ? _CompareProductImage(
                                  onRemoveTap: () => _onRemoveTapped(
                                      context,
                                      compareProductsList[index].productId ??
                                          ''),
                                  imageUrl: compareProductsList[index].imageUrl,
                                  index: index,
                                  name: compareProductsList[index].name ?? '',
                                )
                              : _DottedContainer(
                                  index: index,
                                ))
                          .animatedSwitch()),
                  4.verticalSpace,
                ],
              ),
            );
          });
        },
      ),
    );
  }

  _onRemoveTapped(BuildContext context, String? id) {
    CompareRepo.removeProductFromCompare(id,
        onFailure: () =>
            Helpers.flushToast(context, msg: CompareRepo.errorMessage),
        onSuccess: () {
          Navigator.of(context).pop();
          CompareRepo.addProductToCompare(item);
        });
  }
}

class _DottedContainer extends StatelessWidget {
  const _DottedContainer({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DottedBorder(
          padding: EdgeInsets.zero,
          color: HexColor("#DBDBDB"),
          child: Container(
            height: 62.h,
            width: 82.w,
            color: HexColor('#F4F4F4'),
          ),
        ),
        4.verticalSpace,
        Text(
          'Product ${index + 1}',
          textAlign: TextAlign.center,
          style:
              FontPalette.black12Regular.copyWith(color: HexColor('#7E818C')),
        ).avoidOverFlow(maxLine: 1),
      ],
    );
  }
}

class _CompareProductImage extends StatelessWidget {
  const _CompareProductImage(
      {Key? key,
      this.imageUrl,
      required this.index,
      required this.name,
      this.onRemoveTap})
      : super(key: key);
  final String? imageUrl;
  final int index;
  final String name;
  final Function()? onRemoveTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82.h,
      width: 82.w,
      child: Stack(
        children: [
          Column(
            children: [
              CommonFadeInImage(
                image: imageUrl ?? '',
                height: 62.h,
                width: 82.w,
              ),
              4.verticalSpace,
              Text(
                name,
                textAlign: TextAlign.center,
                style: FontPalette.black12Regular
                    .copyWith(color: HexColor('#7E818C')),
              ).avoidOverFlow(maxLine: 1),
            ],
          ),
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: onRemoveTap,
                child: Container(
                  height: 18.r,
                  width: 18.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: HexColor('#BEC0CC'), shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    Assets.iconsClose,
                    color: Colors.white,
                    height: 9.r,
                    width: 9.r,
                    fit: BoxFit.fill,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
