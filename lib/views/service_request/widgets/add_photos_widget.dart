import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/providers/service_request_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';

class AddPhotosWidget extends StatelessWidget {
  const AddPhotosWidget({Key? key, required this.serviceRequestProvider})
      : super(key: key);
  final ServiceRequestProvider serviceRequestProvider;
  @override
  Widget build(BuildContext context) {
    return Selector<ServiceRequestProvider, List<List<int>>>(
      selector: (context, serviceRequestProvider) =>
          serviceRequestProvider.imageFilesList,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DottedBorder(
              padding: EdgeInsets.zero,
              color: HexColor("#DBDBDB"),
              child: InkWell(
                onTap: () => _showOptions(context, serviceRequestProvider),
                child: Container(
                  height: 51.h,
                  color: HexColor('#F4F4F4'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.iconsCamera),
                      8.horizontalSpace,
                      Text(
                        Constants.addPhotos,
                        style: FontPalette.black15Regular,
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (value.notEmpty) 12.verticalSpace,
            value.notEmpty
                ? Wrap(
                    runSpacing: 10.h,
                    children: List.generate(
                        value.length,
                        (index) => _ImageView(
                              imagePath: Uint8List.fromList(value[index]),
                              onRemoveTapped: () => serviceRequestProvider
                                  .removeImageFromList(index),
                            )),
                  )
                : const SizedBox.shrink()
          ],
        );
      },
    );
  }

  Future _showOptions(BuildContext context,
      ServiceRequestProvider serviceRequestProvider) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text(
              Constants.photoGallery,
              style: FontPalette.black15Regular,
            ),
            onPressed: () {
              Navigator.pop(context);
              serviceRequestProvider.getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text(Constants.camera, style: FontPalette.black15Regular),
            onPressed: () {
              Navigator.pop(context);
              serviceRequestProvider.getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }
}

class _ImageView extends StatelessWidget {
  const _ImageView(
      {Key? key, required this.imagePath, required this.onRemoveTapped})
      : super(key: key);
  final Uint8List imagePath;
  final Function()? onRemoveTapped;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: 58.h,
          width: 58.w,
          margin: EdgeInsets.only(right: 6.w),
          child: Image.memory(
            imagePath,
            fit: BoxFit.fill,
          ),
        ),
        InkWell(
            onTap: onRemoveTapped,
            child: Container(
                height: 16.h,
                width: 16.w,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(
                  Assets.iconsClose,
                  width: 7.w,
                  height: 7.h,
                  alignment: Alignment.center,
                  color: HexColor('#7B7E8E'),
                ))),
      ],
    );
  }
}
