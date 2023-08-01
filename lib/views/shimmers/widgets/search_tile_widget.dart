import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTileWidget extends StatelessWidget {
  const SearchTileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: 20.h,
                        width: constraints.maxWidth * .90,
                        color: Colors.white),
                    Container(
                        height: 20.h,
                        width: constraints.maxWidth * .05,
                        color: Colors.white),
                  ],
                ),
                15.verticalSpace
              ],
            );
          },
          shrinkWrap: true,
        );
      },
    );
  }
}
