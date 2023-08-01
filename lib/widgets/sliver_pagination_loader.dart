import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/widgets/custom_circular_progress_indicator.dart';

class SliverPaginationLoader extends StatelessWidget {
  final bool async;

  const SliverPaginationLoader({Key? key, required this.async})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AnimatedSwitcher(
        duration: const Duration(microseconds: 300),
        child: async
            ? SizedBox(
                height: 70.h,
                child: const CustomCircularProgressIndicator(),
              )
            : const SizedBox(),
      ),
    );
  }
}
