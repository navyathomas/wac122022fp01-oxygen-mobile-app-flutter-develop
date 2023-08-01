import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class CartShippingDetailsTopWidget extends StatelessWidget {
  const CartShippingDetailsTopWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Ship to:",
                              style: FontPalette.black16Regular,
                            ),
                            WidgetSpan(child: 10.horizontalSpace),
                            TextSpan(
                              text: "Ranjith KR",
                              style: FontPalette.black16Medium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: HexColor("#E6E6E6"),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        Constants.home,
                        style: FontPalette.black12Medium,
                      ),
                    ),
                  ],
                ),
                6.verticalSpace,
                Text(
                  "Infopark, Koraty, Thrissur Chalakudy Kerala",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontPalette.f7E818C_13Regular,
                ),
              ],
            ),
          ),
          25.horizontalSpace,
          Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: Colors.grey.shade200,
              splashColor: Colors.grey.shade300,
              onTap: () {},
              child: Container(
                height: 30.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Center(
                  child: Text(
                    Constants.change.toUpperCase(),
                    style: FontPalette.black13Medium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
