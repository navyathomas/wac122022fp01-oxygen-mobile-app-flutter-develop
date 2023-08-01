import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/local_products.dart';
import '../services/hive_services.dart';
import '../utils/color_palette.dart';
import '../utils/font_palette.dart';

class CartCountWidget extends StatelessWidget {
  final Offset? offset;

  const CartCountWidget({Key? key, this.offset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<LocalProducts>>(
        valueListenable:
            Hive.box<LocalProducts>(HiveServices.instance.cartBoxName)
                .listenable(),
        builder: (context, box, _) {
          if (box.keys.isEmpty) return const SizedBox.shrink();
          return Positioned(
            top: 0,
            right: 0,
            child: Transform.translate(
              offset: offset ?? Offset(4.w, -4.h),
              child: Container(
                height: 17.r,
                width: 17.r,
                decoration: BoxDecoration(
                    color: ColorPalette.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white, strokeAlign: StrokeAlign.outside)),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      "${box.keys.length}",
                      style: FontPalette.white11Medium,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
