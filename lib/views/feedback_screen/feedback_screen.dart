import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/repositories/leave_feedback_repo.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';

import 'star_rating/rating_bar.dart';

class LeaveFeedbackScreen extends StatefulWidget {
  const LeaveFeedbackScreen({super.key});

  @override
  State<LeaveFeedbackScreen> createState() => _LeaveFeedbackScreenState();
}

class _LeaveFeedbackScreenState extends State<LeaveFeedbackScreen> {
  LeaveFeedbackRepo repo = LeaveFeedbackRepo();
  TextEditingController feedbackController = TextEditingController();

  @override
  void dispose() {
    repo.isLoading.dispose();
    repo.ratingValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          const WhatsappChatWidget().bottomPadding(padding: 75),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.leaveFeedback,
        actionList: const [],
      ),
      body: SafeArea(
        child: SizedBox(
          width: context.sw(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        18.verticalSpace,
                        Text(
                          Constants.rateYourExperience,
                          style: FontPalette.black22Medium,
                        ),
                        4.verticalSpace,
                        Text(
                          Constants.howWouldYouRateOxygen,
                          style: FontPalette.f282C3F_16Regular,
                        ),
                        18.verticalSpace,
                        Container(
                          width: context.sw(),
                          height: 229.h,
                          color: HexColor('#F4F4F4'),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.w),
                            child: Column(
                              children: [
                                20.verticalSpace,
                                SizedBox(
                                  height: 35,
                                  child: Row(
                                    children: [
                                      ValueListenableBuilder<double>(
                                        valueListenable: repo.ratingValue,
                                        builder: (_, data, __) =>
                                            RatingBar.builder(
                                          initialRating: data,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          unratedColor: HexColor('#CACBD0'),
                                          itemCount: 5,
                                          itemPadding:
                                              const EdgeInsets.only(right: 6),
                                          itemBuilder: (context, _) =>
                                              Container(
                                            width: 35.r,
                                            height: 35.r,
                                            decoration: BoxDecoration(
                                                color: HexColor('#E50019'),
                                                shape: BoxShape.circle),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                  Assets.iconsRatingStar),
                                            ),
                                          ),
                                          onRatingUpdate: (value) {
                                            repo.ratingValue.value = value;
                                          },
                                          updateOnDrag: false,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox.shrink()),
                                      Container(
                                        width: 27.r,
                                        height: 27.r,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: ValueListenableBuilder(
                                          valueListenable: repo.ratingValue,
                                          builder: (_, data, __) => Image.asset(
                                            data <= 2
                                                ? Assets.imagesSmileySad
                                                : data == 3
                                                    ? Assets.imagesSmileyGood
                                                    : Assets
                                                        .imagesSmileyAwesome,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      6.horizontalSpace,
                                      ValueListenableBuilder(
                                        valueListenable: repo.ratingValue,
                                        builder: (_, data, __) => Text(
                                          data <= 2
                                              ? Constants.sad
                                              : data == 3
                                                  ? Constants.good
                                                  : Constants.awesome,
                                          style: FontPalette.black14Medium
                                              .copyWith(fontSize: 13.sp),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                40.07.verticalSpace,
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 1,
                                        color: HexColor('#DBDBDB'),
                                      ),
                                    ),
                                    child: TextField(
                                      maxLines: 6,
                                      onChanged: (v) {
                                        repo.feedback.value = v;
                                      },
                                      controller: feedbackController,
                                      decoration: InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        hintText: Constants.howCanWeImproveYou,
                                        hintStyle:
                                            FontPalette.f7B7E8E_15Regular,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 18.w, vertical: 12.h),
                                      ),
                                    ),
                                  ),
                                ),
                                15.verticalSpace,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 13.w, right: 13.w, bottom: 30.5.h, top: 10.5.h),
                child: ValueListenableBuilder(
                  valueListenable: MultiValueListenables(
                      [repo.isLoading, repo.ratingValue, repo.feedback]),
                  builder: (_, __, ___) => CustomButton(
                    enabled: repo.ratingValue.value > 0,
                    title: Constants.submitFeedback,
                    onPressed: () async {
                      await repo
                          .postFeedback(feedbackController.text)
                          .then((value) {
                        if (value != null && value == true) {
                          Navigator.pop(context);
                        }
                      });
                    },
                    isLoading: repo.isLoading.value,
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

class MultiValueListenables implements ValueListenable<bool> {
  final List<ValueListenable> valueListenables;
  late final Listenable listenable;
  bool val = false;

  MultiValueListenables(this.valueListenables) {
    listenable = Listenable.merge(valueListenables);
    listenable.addListener(onNotified);
  }

  @override
  void addListener(VoidCallback listener) {
    listenable.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    listenable.removeListener(listener);
  }

  @override
  bool get value => val;

  void onNotified() {
    val = !val;
  }
}
