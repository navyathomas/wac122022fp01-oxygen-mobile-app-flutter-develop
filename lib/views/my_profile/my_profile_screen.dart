import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/common/validator.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/customer_profile_model.dart';
import 'package:oxygen/providers/my_profile_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/authentication/widgets/auth_text_field.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/three_bounce.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late final GlobalKey<FormState> _formKey;
  late MyProfileProvider profileProvider;
  late FocusNode firstNameFocusNode;

  ButtonStyle noSplashButonStyle = ButtonStyle(
    overlayColor: MaterialStateProperty.resolveWith(
      (states) {
        return states.contains(MaterialState.pressed)
            ? Colors.grey.shade100
            : Colors.grey.shade100;
      },
    ),
  );

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();

  Widget buildCustomTileWidget(
      {required String title,
      required String icon,
      void Function()? onClick,
      TextStyle? style,
      bool border = true}) {
    return InkWell(
      splashColor: HexColor('#F3F3F7'),
      highlightColor: Colors.transparent,
      onTap: onClick ?? () {},
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          border: border
              ? Border(
                  top: BorderSide(
                    width: 1.h,
                    color: HexColor('#E6E6E6'),
                  ),
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(icon),
                13.8.horizontalSpace,
                Text(
                  title,
                  style: style ?? FontPalette.f282C3F_16Medium,
                )
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: HexColor('#7B7E8E'),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMyProfileFields(
      {required LoaderState loaderState, required bool updating}) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Consumer<MyProfileProvider>(
                    builder: (_, v, __) => AbsorbPointer(
                      absorbing: !v.isEdit,
                      child: Column(
                        children: [
                          26.verticalSpace,
                          AuthTextField(
                            focusNode: firstNameFocusNode,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            labelText: Constants.firstName,
                            controller: firstNameController,
                            validator: (_) => Validator.validateName(
                                firstNameController.text),
                            onChanged: (_) => v.checkDataChange(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text),
                          ),
                          12.verticalSpace,
                          AuthTextField(
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            labelText: Constants.lastName,
                            controller: lastNameController,
                            validator: (_) => Validator.validateLastName(
                                lastNameController.text),
                            onChanged: (_) => v.checkDataChange(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text),
                          ),
                          12.verticalSpace,
                          // Form(
                          //   key: _emailFormKey,
                          //   child: CustomInputField(
                          //     textInputType: TextInputType.emailAddress,
                          //     textInputAction: TextInputAction.next,
                          //     labelText: Constants.emailAddress,
                          //     controller: emailController,
                          //     validator: (_) => Validator.validateEmail(
                          //         emailController.text),
                          //     onChanged: (value) {
                          //       _emailFormKey.currentState!.validate();
                          //       v.checkEmailIsChanged(value);
                          //     },
                          //     suffix: v.verifyEmail
                          //         ? Padding(
                          //             padding: const EdgeInsets.all(2.0),
                          //             child: TextButton(
                          //               style: noSplashButonStyle,
                          //               onPressed: () {
                          //                 if (_emailFormKey.currentState!
                          //                     .validate()) {
                          //                   // v.verifyOtp();
                          //                 }
                          //               },
                          //               child: Text('Verify'),
                          //             ),
                          //           )
                          //         : const SizedBox.shrink(),
                          //   ),
                          // ),
                          // 12.verticalSpace,
                          // CustomInputField(
                          //   textInputType: TextInputType.phone,
                          //   textInputAction: TextInputAction.done,
                          //   labelText: Constants.mobileNumber,
                          //   controller: mobileController,
                          //   validator: (_) => Validator.validateMobile(
                          //       mobileController.text),
                          //   onChanged: (value) =>
                          //       v.checkMobileIsChanged(value),
                          //   suffix: v.verifyMobile
                          //       ? TextButton(
                          //           style: noSplashButonStyle,
                          //           onPressed: () {},
                          //           child: Text('Verify'),
                          //         )
                          //       : const SizedBox.shrink(),
                          // ),
                          // 12.verticalSpace,
                          // CustomDropdown<String>(
                          //   onChange: (value) {
                          //     v.selectGender(value);
                          //     v.checkDataChange(
                          //         firstName: firstNameController.text,
                          //         lastName: lastNameController.text);
                          //   },
                          //   dropdownStyle: DropdownStyle(
                          //     color: Colors.white,
                          //     borderSide: BorderSide(
                          //       color: HexColor("#DBDBDB"),
                          //     ),
                          //   ),
                          //   dropdownButtonStyle: DropdownButtonStyle(
                          //     unselectedTextStyle:
                          //         FontPalette.f282C3F_15Regular,
                          //     textStyle: FontPalette.f282C3F_15Regular,
                          //     padding: EdgeInsets.only(
                          //         left: 14.w, right: 11.w),
                          //     decoration: BoxDecoration(
                          //       border: Border.all(
                          //         color: HexColor("#DBDBDB"),
                          //       ),
                          //     ),
                          //   ),
                          //   items: List.generate(
                          //     2,
                          //     (index) => DropdownItem(
                          //         value: v.genderList.elementAt(index),
                          //         child: Padding(
                          //           padding: EdgeInsets.symmetric(
                          //               vertical: 17.h,
                          //               horizontal: 14.w),
                          //           child: Column(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.center,
                          //             children: [
                          //               Text(
                          //                 v.genderList.elementAt(index),
                          //                 style: FontPalette
                          //                     .black14Regular,
                          //               ),
                          //             ],
                          //           ),
                          //         )),
                          //   ),
                          //   initialValue: v.profileModel?.gender != null
                          //       ? v.getGender(v.profileModel?.gender)
                          //       : Constants.selectGender,
                          // ),
                          // 12.verticalSpace,
                          InkWell(
                            onTap: () {
                              v.selectDateOfBirth(context,
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text);
                            },
                            child: Container(
                              height: 45.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: v.dobHasError
                                      ? ColorPalette.redColor
                                      : HexColor('#DBDBDB'),
                                ),
                              ),
                              child: Row(
                                children: [
                                  14.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      v.selectedDob != null
                                          ? v.selectedDob!
                                          : (v.profileModel?.dateOfBirth ??
                                              Constants.selectDob),
                                      style: FontPalette.f282C3F_15Regular,
                                    ),
                                  ),
                                  14.horizontalSpace,
                                  SvgPicture.asset(Assets.iconsCalendarSuffix),
                                  14.horizontalSpace
                                ],
                              ),
                            ),
                          ),
                          2.verticalSpace,
                          (v.dobHasError
                                  ? SizedBox(
                                      width: context.sw(),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 1.w),
                                        child: Text(
                                          Constants.invalidDobMsg,
                                          style: FontPalette.fE50019_12Regular,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink())
                              .animatedSwitch()
                        ],
                      ),
                    ),
                  ),
                  40.verticalSpace,
                  buildCustomTileWidget(
                    title: Constants.changeEmailAndMobile,
                    icon: Assets.iconsChange,
                    onClick: _navigateToUpdateContactScreen,
                    border: false,
                  ),
                  buildCustomTileWidget(
                    title: Constants.changePassword,
                    icon: Assets.iconsChangePassword,
                    onClick: _navigateToChangePasswordScreen,
                  ),
                  buildCustomTileWidget(
                    title: Constants.deleteMyAccount,
                    icon: Assets.iconsDeleteRed,
                    style: FontPalette.fE50019_16Medium,
                    onClick: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pushNamed(
                          context, RouteGenerator.routeDeleteMyAccount);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.myProfile,
        actionList: [
          Selector<MyProfileProvider,
              Tuple4<bool, bool, CustomerProfileModel?, bool>>(
            selector: (_, provider) => Tuple4(
                provider.isEdit,
                provider.dataIsChanged,
                provider.profileModel,
                provider.updating),
            builder: (_, data, __) => !data.item4
                ? ((data.item3 != null
                        ? TextButton(
                            onPressed: data.item2
                                ? (data.item1
                                    ? () {
                                        _onSave();
                                      }
                                    : () async {
                                        profileProvider.enableFeilds();
                                        firstNameFocusNode.requestFocus();
                                        profileProvider.checkDataChange(
                                            firstName: firstNameController.text,
                                            lastName: lastNameController.text);
                                      })
                                : null,
                            style: noSplashButonStyle,
                            child: data.item2
                                ? Text(
                                    data.item1
                                        ? Constants.save
                                        : Constants.edit,
                                    style: data.item1
                                        ? FontPalette.fE50019_16Medium
                                        : FontPalette.f282C3F_16Regular,
                                  )
                                : Text(
                                    data.item1
                                        ? Constants.save
                                        : Constants.edit,
                                    style: !data.item1
                                        ? FontPalette.f282C3F_16Regular
                                        : FontPalette.f282C3F_16Regular
                                            .copyWith(color: Colors.grey),
                                  ),
                          )
                        : const SizedBox.shrink())
                    .animatedSwitch())
                : SizedBox(
                    width: 60.w,
                    child: ThreeBounce(
                      size: 10.r,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
          ),
        ],
      ),
      body: Selector<MyProfileProvider, Tuple2<LoaderState, bool>>(
        selector: (_, provider) =>
            Tuple2(provider.loaderState, provider.updating),
        builder: (_, data, __) {
          switch (data.item1) {
            case LoaderState.loaded:
              return buildMyProfileFields(
                  loaderState: data.item1, updating: data.item2);
            case LoaderState.loading:
              return const CommonLinearProgress();
            case LoaderState.error:
              return ApiErrorScreens(loaderState: data.item1);
            case LoaderState.networkErr:
              return ApiErrorScreens(
                loaderState: data.item1,
                onTryAgain: () {
                  CommonFunctions.afterInit(_setProfile);
                },
              );
            case LoaderState.noData:
              return ApiErrorScreens(loaderState: data.item1);
            case LoaderState.noProducts:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    profileProvider = context.read<MyProfileProvider>();
    firstNameFocusNode = FocusNode();
    CommonFunctions.afterInit(_setProfile);
  }

  @override
  void dispose() {
    profileProvider.resetValues();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      await profileProvider.updateCustomerProfile(
        context,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
      );
    }
  }

  void _navigateToChangePasswordScreen() {
    FocusScope.of(context).unfocus();
    if (mounted) {
      Navigator.pushNamed(context, RouteGenerator.routeChangePasswordScreen);
    }
  }

  void _navigateToUpdateContactScreen() {
    FocusScope.of(context).unfocus();
    if (mounted) {
      Navigator.pushNamed(context, RouteGenerator.routeUpdateContacts,
          arguments: profileProvider.profileModel);
    }
  }

  void _setProfile() async {
    await context.read<MyProfileProvider>().getPersonalInfoData().then((_) {
      firstNameController.text = profileProvider.profileModel?.firstname ?? '';
      lastNameController.text = profileProvider.profileModel?.lastname ?? '';
      emailController.text = profileProvider.profileModel?.email ?? '';
      mobileController.text =
          (profileProvider.profileModel?.mobileNumber ?? '').substring(3);
    });
  }
}
