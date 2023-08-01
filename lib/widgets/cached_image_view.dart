import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/utils/color_palette.dart';

class CachedImageView extends StatelessWidget {
  final String image;
  final double? height;
  final bool isCircular;
  final BoxFit? boxFit;
  final bool enableLoader;
  final Color? errorColor;
  final double? width;

  const CachedImageView(
      {Key? key,
      required this.image,
      this.height,
      this.width,
      this.enableLoader = true,
      this.boxFit,
      this.errorColor,
      this.isCircular = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      alignment: Alignment.center,
      placeholder: (context, _) => Container(
        height: height ?? double.maxFinite,
        width: width ?? double.maxFinite,
        decoration: enableLoader
            ? BoxDecoration(
                color: ColorPalette.shimmerBaseColor,
              )
            : null,
      ),
      errorWidget: (context, _, __) => Container(
        height: height ?? double.maxFinite,
        width: width ?? double.maxFinite,
        decoration: enableLoader
            ? BoxDecoration(
                color: ColorPalette.shimmerBaseColor,
              )
            : null,
      ),
      fit: boxFit ?? BoxFit.contain,
      height: height,
      width: width,
    );
  }
}
