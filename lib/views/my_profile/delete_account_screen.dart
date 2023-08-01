import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/arguments/delete_account_argument.dart';
import 'package:oxygen/providers/delete_confirmation_provider.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/terms_and_conditions/widgets/terms_widget.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:oxygen/widgets/custom_drop_down.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  late final DeleteAccountConfirmationProvider deleteProvider;
  TextEditingController additionalCommentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    deleteProvider = DeleteAccountConfirmationProvider();
    CommonFunctions.afterInit(() async {
      await deleteProvider.getReasonsForDeletion();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => deleteProvider,
      builder: (
        ctx,
        __,
      ) =>
          Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppBar(
          buildContext: context,
          pageTitle: Constants.deleteAccount,
          actionList: const [],
        ),
        body: Selector<DeleteAccountConfirmationProvider,
            Tuple2<LoaderState, bool>>(
          selector: (_, provider) =>
              Tuple2(provider.loaderState, provider.btnLoaderState),
          builder: (_, data, __) {
            switch (data.item1) {
              case LoaderState.loaded:
                return buildDeleteAccountView(context, btnLoading: data.item2);
              case LoaderState.loading:
                return const CommonLinearProgress();
              case LoaderState.error:
                return ApiErrorScreens(loaderState: data.item1);
              case LoaderState.networkErr:
                return ApiErrorScreens(loaderState: data.item1);
              case LoaderState.noData:
                return ApiErrorScreens(loaderState: data.item1);
              case LoaderState.noProducts:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  // buildDeleteAccountView(context),
  Widget buildDeleteAccountView(BuildContext context,
      {bool btnLoading = false}) {
    return CustomSlidingFadeAnimation(
      slideDuration: const Duration(milliseconds: 200),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: Column(
                  children: [
                    26.verticalSpace,
                    Selector<DeleteAccountConfirmationProvider, List<String>?>(
                      selector: (_, provider) => provider.reasonsForDeletion,
                      builder: (_, list, __) => CustomDropdown<String>(
                        onChange: (value) {
                          deleteProvider.selectReasonForDeletion(value);
                        },
                        dropdownStyle: DropdownStyle(
                          color: Colors.white,
                          borderSide: BorderSide(
                            color: HexColor("#DBDBDB"),
                          ),
                        ),
                        dropdownButtonStyle: DropdownButtonStyle(
                          unselectedTextStyle: FontPalette.f282C3F_15Regular,
                          textStyle: FontPalette.f282C3F_15Regular,
                          padding: EdgeInsets.only(left: 14.w, right: 11.w),
                          decoration: BoxDecoration(
                              border: Border.all(color: HexColor("#DBDBDB"))),
                        ),
                        items: List.generate(
                          (list ?? []).length,
                          (index) => DropdownItem(
                              value: (list ?? []).elementAt(index),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 17.h, horizontal: 14.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (list ?? []).elementAt(index),
                                      style: FontPalette.black14Regular,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        initialValue: Constants.reasonForDeletion,
                      ),
                    ),
                    12.verticalSpace,
                    Container(
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: HexColor('#DBDBDB'),
                        ),
                      ),
                      child: TextField(
                        maxLines: 4,
                        controller: additionalCommentsController,
                        onChanged: (val) {
                          deleteProvider.additionalCoomentForAccountDeletion =
                              val;
                        },
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: Constants.additionalComments,
                          hintStyle: FontPalette.f7B7E8E_15Regular,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 12.h),
                        ),
                      ),
                    ),
                    12.verticalSpace,
                    Container(
                      color: HexColor('#FFE8EA'),
                      width: context.sw(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 17, horizontal: 14.w),
                        child: Text(
                          Constants.accountDeleteWarning,
                          style: FontPalette.fE50019_14Regular
                              .copyWith(height: 1.3),
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    const TermsWidget(
                      text: Constants.accountDeleteMessageOne,
                    ),
                    const TermsWidget(
                      text: Constants.accountDeleteMessageTwo,
                    ),
                    const TermsWidget(
                        text: Constants.accountDeleteMessageThree),
                    const TermsWidget(
                      text: Constants.accountDeleteMessageFour,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: Consumer<DeleteAccountConfirmationProvider>(
              builder: (_, __, ___) => CustomButton(
                isLoading: btnLoading,
                title: Constants.confirmAndProceed,
                enabled:
                    deleteProvider.selectedReasonForAccountDeletion != null,
                onPressed: () => _navigateToVerifyOtp(),
              ),
            ),
          ),
          30.verticalSpace
        ],
      ),
    );
  }

  void _navigateToVerifyOtp() async {
    var userData = await HiveServices.instance.getUserData();
    var email = userData?.email;
    var isOtpSend =
        await deleteProvider.sendDeleteAccountOtp(email: email ?? '');
    if (isOtpSend == true) {
      if (mounted) {
        Navigator.pushNamed(
          context,
          RouteGenerator.routeProfileVerifyOtpScreen,
          arguments: DeleteCustomerAccountArguments(
            email: email ?? '',
            reason: deleteProvider.selectedReasonForAccountDeletion ?? '',
            additionalComments:
                deleteProvider.additionalCoomentForAccountDeletion,
          ),
        );
      }
    }
  }
}
