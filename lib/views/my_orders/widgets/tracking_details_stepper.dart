import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/models/my_orders_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class TrackingDetailsStepper extends StatelessWidget {
  final double? size;
  final List<Status?>? steps;
  const TrackingDetailsStepper({
    Key? key,
    this.size,
    this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: List.generate(
              steps?.length ?? 0,
              (index) => Column(
                children: [
                  _BuildDots(
                      size: size,
                      colorCode: steps?.elementAt(index)?.colorCode),
                  (index == (steps?.length ?? 0) - 1)
                      ? const SizedBox.shrink()
                      : _BuildVerticalLines(
                          size: size,
                          colorCode: steps?.elementAt(index)?.colorCode),
                ],
              ),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(steps?.length ?? 0, (index) {
                final isActive = steps?.elementAt(index)?.isActive;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      steps?.elementAt(index)?.statusLabel ?? "",
                      style: FontPalette.black16Regular.copyWith(
                          height: 0.9,
                          color: (isActive ?? false)
                              ? Colors.black
                              : HexColor("#BABABA")),
                      maxLines: 1,
                    ),
                    4.verticalSpace,
                    (steps?.elementAt(index)?.lastUpdated == null ||
                            (steps?.elementAt(index)?.lastUpdated?.isEmpty ??
                                true))
                        ? const SizedBox.shrink()
                        : Text(
                            steps?.elementAt(index)?.lastUpdated ?? "",
                            style: FontPalette.f7B7E8E_14Regular
                                .copyWith(height: 0.9),
                            maxLines: 1,
                          ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildVerticalLines extends StatelessWidget {
  final String? colorCode;
  const _BuildVerticalLines({Key? key, required this.size, this.colorCode})
      : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 50,
      color: HexColor("#189614"),
    );
  }
}

class _BuildDots extends StatelessWidget {
  final String? colorCode;
  const _BuildDots({Key? key, required this.size, this.colorCode})
      : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 12.r,
      width: size ?? 12.r,
      decoration: BoxDecoration(
          color: HexColor(colorCode ?? "#F3F3F7"), shape: BoxShape.circle),
    );
  }
}
