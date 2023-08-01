import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/validator.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/repositories/product_detail_repo.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_btn.dart';

class ShowNotifyDialogue extends StatefulWidget {
  final int id;

  const ShowNotifyDialogue({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ShowNotifyDialogue> createState() => _ShowNotifyDialogueState();
}

class _ShowNotifyDialogueState extends State<ShowNotifyDialogue> {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<bool> showLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    showLoading.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> unFocus() async {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 28.w),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 27.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  16.verticalSpace,
                  Padding(
                    padding: EdgeInsets.only(right: 13.w),
                    child: Text(
                      Constants.getNotifiedProductAvailable,
                      textAlign: TextAlign.start,
                      style: FontPalette.black14Regular,
                    ),
                  ),
                  23.verticalSpace,
                  Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: HexColor('#DBDBDB'),
                      ),
                    ),
                    child: Center(
                      child: TextField(
                        maxLines: 1,
                        controller: controller,
                        textAlignVertical: TextAlignVertical.center,
                        style: FontPalette.black15Regular,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: Constants.enterYourEmailId,
                          hintStyle: FontPalette.f7B7E8E_15Regular,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.w),
                        ).copyWith(isDense: true),
                      ),
                    ),
                  ),
                  21.verticalSpace,
                  ValueListenableBuilder<bool>(
                      valueListenable: showLoading,
                      builder: (context, value, child) {
                        return CustomButton(
                          title: Constants.submit,
                          isLoading: value,
                          onPressed: () async {
                            if (Validator.validateIsEmail(controller.text)) {
                              showLoading.value = true;
                              final result =
                                  await ProductDetailRepo.getStockNotification(
                                context,
                                id: widget.id,
                                email: controller.text,
                              );
                              await unFocus().then((value) {
                                showLoading.value = false;
                                if (result != null) {
                                  if (!mounted) return;
                                  Navigator.of(context).pop();
                                  Helpers.flushToast(context, msg: result);
                                }
                              });
                            } else {
                              Helpers.successToast(
                                  Constants.emailValidationMsg);
                            }
                          },
                        );
                      }),
                ],
              ),
            ),
            Positioned(
              top: 5.h,
              right: 5.w,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox.square(
                    dimension: 40.r,
                    child: Center(
                      child: SizedBox.square(
                        dimension: 16.r,
                        child: SvgPicture.asset(Assets.iconsCloseGrey),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
