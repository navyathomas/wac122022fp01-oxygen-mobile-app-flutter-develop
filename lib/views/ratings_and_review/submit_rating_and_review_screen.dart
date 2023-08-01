import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/common_styles.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/repositories/product_detail_repo.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:oxygen/widgets/custom_outline_button.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';

class SubmitRatingAndReviewScreen extends StatefulWidget {
  final Item? item;

  const SubmitRatingAndReviewScreen({Key? key, this.item}) : super(key: key);

  @override
  State<SubmitRatingAndReviewScreen> createState() =>
      _SubmitRatingAndReviewScreenState();
}

class _SubmitRatingAndReviewScreenState
    extends State<SubmitRatingAndReviewScreen> {
  final ValueNotifier<int> ratingValue = ValueNotifier<int>(1);
  final ValueNotifier<bool> showSubmit = ValueNotifier<bool>(false);
  final TextEditingController titleController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    reviewController.dispose();
    ratingValue.dispose();
    showSubmit.dispose();
    super.dispose();
  }

  void showSuccessDialogue() {
    showGeneralDialog(
      barrierDismissible: true,
      context: context,
      useRootNavigator: false,
      routeSettings: const RouteSettings(name: "/submitReviewPopUp"),
      barrierLabel: "",
      pageBuilder: (_, __, ___) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (_, animation, __, ___) {
        var curve = Curves.easeInOut.transform(animation.value);
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Transform.scale(
            scale: curve,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.white,
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(horizontal: 48.w),
                    child: Column(
                      children: [
                        70.verticalSpace,
                        SizedBox.square(
                          dimension: context.sw(size: .1547),
                          child: SvgPicture.asset(Assets.iconsSuccess),
                        ),
                        24.verticalSpace,
                        Text(Constants.yourReviewSubmitted,
                            style: FontPalette.black18Medium),
                        10.verticalSpace,
                        Text(Constants.thankForYourTime,
                            style: FontPalette.black14Regular),
                        70.verticalSpace,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    ).timeout(const Duration(seconds: 2), onTimeout: () {
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.of(context).pop();
      Navigator.of(context).pop(true);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          const WhatsappChatWidget().bottomPadding(padding: 75),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.rateAndReviewProduct,
        actionList: const [],
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 18.h, horizontal: 12.w),
                        child: Row(
                          children: [
                            SizedBox(
                              height: context.sw(size: .1968),
                              width: context.sw(size: .1968),
                              child: CommonFadeInImage(
                                image: widget.item?.mediaGallery?.first?.url,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Text(widget.item?.name ?? "",
                                    style: FontPalette.black14Regular),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 5.h,
                        thickness: 5.h,
                        color: HexColor("#F3F3F7"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 22.h, horizontal: 12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Constants.rateThisProduct,
                                style: FontPalette.black18Medium),
                            20.verticalSpace,
                            ValueListenableBuilder<int>(
                              valueListenable: ratingValue,
                              builder: (context, value, child) {
                                return RatingBar.builder(
                                  ignoreGestures: false,
                                  initialRating: value.toDouble(),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  glow: false,
                                  itemCount: 5,
                                  itemSize: context.sw(size: .0853),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: HexColor("#179614"),
                                  ),
                                  onRatingUpdate: (double updatedValue) {
                                    ratingValue.value = updatedValue.toInt();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 5.h,
                        thickness: 5.h,
                        color: HexColor("#F3F3F7"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 22.h, horizontal: 12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Constants.writeReview,
                                style: FontPalette.black18Medium),
                            20.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: HexColor('#DBDBDB'),
                                ),
                              ),
                              child: TextField(
                                maxLines: 1,
                                controller: titleController,
                                style: FontPalette.black15Regular,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    showSubmit.value = true;
                                  } else {
                                    showSubmit.value = false;
                                  }
                                },
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  hintText: Constants.title,
                                  hintStyle: FontPalette.f7B7E8E_15Regular,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 18.w, vertical: 12.h),
                                ),
                              ),
                            ),
                            18.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: HexColor('#DBDBDB'),
                                ),
                              ),
                              child: TextField(
                                maxLines: 4,
                                controller: reviewController,
                                style: FontPalette.black15Regular,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  hintText: Constants.plsEnterComments,
                                  hintStyle: FontPalette.f7B7E8E_15Regular,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 18.w, vertical: 12.h),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 73.h,
                decoration: CommonStyles.bottomDecoration,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomOutlineButton(
                          title: Constants.cancel,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                            valueListenable: showSubmit,
                            builder: (context, value, child) {
                              return CustomButton(
                                title: Constants.submit,
                                enabled: value,
                                onPressed: () async {
                                  final authCustomerData =
                                      await HiveServices.instance.getUserData();
                                  if (!mounted) return;
                                  final result =
                                      await ProductDetailRepo.submitReview(
                                    context,
                                    sku: widget.item?.sku ?? "",
                                    summary: titleController.text,
                                    text: reviewController.text,
                                    ratingValue: ratingValue.value,
                                    nickName:
                                        "${authCustomerData?.firstname ?? ""} ${authCustomerData?.lastname ?? ""}",
                                  );
                                  if (result) {
                                    showSuccessDialogue();
                                  }
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
