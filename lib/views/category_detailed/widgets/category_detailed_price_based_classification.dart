import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/category_detailed_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class CategoryDetailedPriceBasedClassification extends StatelessWidget {
  final String? title;
  final String? titleColor;
  final List<DetailContent?>? content;

  const CategoryDetailedPriceBasedClassification({
    Key? key,
    this.title,
    this.titleColor,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            title ?? "",
            style: FontPalette.black20Medium
                .copyWith(color: HexColor(titleColor ?? "#000000")),
          ),
        ),
        12.verticalSpace,
        Column(
          children: List.generate(
            content?.length ?? 0,
            (index) {
              final item = content?.elementAt(index);
              return InkWell(
                onTap: () {
                  NavRoutes.instance.navByType(
                      context, item?.linkType, item?.linkId, item?.categoryPage,
                      filterPrice: item?.filterPrice);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      _BuildRow(collection: item?.label?.toUpperCase()),
                      const _BuildDivider(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).convertToSliver();
  }
}

class _BuildDivider extends StatelessWidget {
  const _BuildDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 5.h,
      thickness: 5.h,
      color: HexColor("#F3F3F7"),
    );
  }
}

class _BuildRow extends StatelessWidget {
  final String? collection;

  const _BuildRow({
    Key? key,
    this.collection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            collection ?? "",
            style: FontPalette.black18Regular,
          ),
          SizedBox(
            height: 12.r,
            width: 12.r,
            child: SvgPicture.asset(
              Assets.iconsRightArrow,
              color: HexColor("#7B7E8E"),
            ),
          )
        ],
      ),
    );
  }
}
