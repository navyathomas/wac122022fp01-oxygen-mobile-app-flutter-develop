import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsGridViewShimmer extends StatelessWidget {
  const ProductsGridViewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6.r,
        mainAxisSpacing: 6.r,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(color: Colors.white);
      },
    );
  }
}
