import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/widgets/cached_image_view.dart';

class HomeSingleBanner extends StatelessWidget {
  final String? imageUrl;
  final Function(BuildContext context) onTap;

  const HomeSingleBanner({Key? key, this.imageUrl, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: InkWell(
        onTap: () => onTap(context),
        child: CachedImageView(
          image: imageUrl ?? '',
          height: context.sw(size: 0.48),
          width: double.maxFinite,
        ),
      ),
    ).convertToSliver();
  }
}
