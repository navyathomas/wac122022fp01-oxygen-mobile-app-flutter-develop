import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/latest_offers_data_model.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

class LatestOffersProductOffers extends StatelessWidget {
  const LatestOffersProductOffers({Key? key, this.content}) : super(key: key);

  final List<LatestOffersContent>? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 20.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6.w,
                mainAxisSpacing: 6.r,
                mainAxisExtent: constraints.maxWidth * 0.4747),
            itemCount: 4,
            itemBuilder: (context, index) {
              return CommonFadeInImage(
                image: content?[index].imageUrl,
                imageErrorWidget: Image.asset(
                  Assets.imagesErrorImageSqure,
                  height: double.maxFinite,
                  width: double.maxFinite,
                  fit: BoxFit.fill,
                ),
                height: double.maxFinite,
                width: double.maxFinite,
                fit: BoxFit.fill,
              );
            },
          );
        },
      ),
    ).convertToSliver();
  }
}
