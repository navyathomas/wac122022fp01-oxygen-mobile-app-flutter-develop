import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/validator.dart';
import 'package:oxygen/models/customer_address_model.dart';
import 'package:oxygen/providers/address_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/authentication/widgets/auth_text_field.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/custom_action_chip.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:oxygen/widgets/custom_check_box.dart';
import 'package:oxygen/widgets/custom_drop_down.dart';
import 'package:oxygen/widgets/custom_switch.dart';
import 'package:provider/provider.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key, this.update = false, this.addresses})
      : super(key: key);

  final bool? update;
  final Addresses? addresses;

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  late final GlobalKey<FormState> _formKey;
  AddressProvider? addressProvider;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final pincodeController = TextEditingController();
  final localityOrTownController = TextEditingController();
  final streetController = TextEditingController();

  FocusNode pincodeFocusNode = FocusNode();
  FocusNode localityFocusNode = FocusNode();
  FocusNode firstNameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.addAddress,
        actionList: const [],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  18.verticalSpace,
                  Text(Constants.contactInformation,
                      style: FontPalette.black16Medium),
                  8.verticalSpace,
                  AuthTextField(
                    focusNode: firstNameFocusNode,
                    controller: firstNameController,
                    labelText: Constants.firstName,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (_) =>
                        Validator.validateName(firstNameController.text),
                    onChanged: (v) =>
                        addressProvider?.updateFieldValidationValues(1, v),
                  ),
                  12.verticalSpace,
                  AuthTextField(
                    controller: lastNameController,
                    labelText: Constants.lastName,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (_) =>
                        Validator.validateLastName(lastNameController.text),
                    onChanged: (v) =>
                        addressProvider?.updateFieldValidationValues(2, v),
                  ),
                  12.verticalSpace,
                  AuthTextField(
                    controller: contactNumberController,
                    labelText: Constants.mobile,
                    textInputType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    maxLength: 10,
                    onChanged: (v) {
                      addressProvider?.updateFieldValidationValues(3, v);
                      if (contactNumberController.text.length == 10) {
                        addressProvider?.updateFieldValidationValues(1, v);
                        FocusScope.of(context).requestFocus(pincodeFocusNode);
                      }
                    },
                    validator: (_) =>
                        _validateContactNumber(contactNumberController.text),
                    textInputFormatter:
                        Validator.inputFormatter(InputFormatType.phoneNumber),
                  ),
                  18.verticalSpace,
                  Text(Constants.address, style: FontPalette.black16Medium),
                  8.verticalSpace,
                  AuthTextField(
                    focusNode: pincodeFocusNode,
                    controller: pincodeController,
                    textInputType: TextInputType.number,
                    labelText: Constants.pinCode,
                    maxLength: 6,
                    onChanged: (v) {
                      addressProvider?.updateFieldValidationValues(4, v);
                      if (pincodeController.text.length == 6) {
                        FocusScope.of(context).requestFocus(localityFocusNode);
                      }
                    },
                    validator: (_) => _validateOtherTextFields(
                        pincodeController.text,
                        hint: Constants.pinCode.toLowerCase()),
                    textInputFormatter:
                        Validator.inputFormatter(InputFormatType.phoneNumber),
                  ),
                  12.verticalSpace,
                  AuthTextField(
                    focusNode: localityFocusNode,
                    controller: localityOrTownController,
                    labelText: Constants.localityOrTown,
                    validator: (_) => _validateOtherTextFields(
                        localityOrTownController.text,
                        hint: Constants.localityOrTown.toLowerCase()),
                    onChanged: (v) =>
                        addressProvider?.updateFieldValidationValues(5, v),
                  ),
                  12.verticalSpace,
                  AuthTextField(
                    controller: streetController,
                    labelText: Constants.houseNoAndBuilding,
                    validator: (_) => _validateOtherTextFields(
                        streetController.text,
                        hint: Constants.address.toLowerCase()),
                    onChanged: (v) =>
                        addressProvider?.updateFieldValidationValues(6, v),
                  ),
                  12.verticalSpace,
                  Consumer<AddressProvider>(
                    builder: (_, provider, __) => CustomDropdown<String>(
                      initialTextStyle:
                          widget.update! ? FontPalette.black14Regular : null,
                      onChange: (value) {
                        provider.updateFieldValidationValues(7, value);
                        addressProvider!.selectedDistrict = value;
                        addressProvider!.checkDistrictDropdown();
                      },
                      dropdownStyle: DropdownStyle(
                        color: Colors.white,
                        borderSide: BorderSide(
                          color: HexColor("#DBDBDB"),
                        ),
                      ),
                      dropdownButtonStyle: DropdownButtonStyle(
                        unselectedTextStyle: FontPalette.f7B7E8E_14Regular,
                        textStyle: FontPalette.black14Regular,
                        padding: EdgeInsets.only(left: 14.w, right: 4.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: provider.districtDropdownHasError
                                ? ColorPalette.redColor
                                : HexColor("#DBDBDB"),
                          ),
                        ),
                      ),
                      items: List.generate(
                        provider.availableDistricts.length,
                        (index) => DropdownItem(
                          value: provider.availableDistricts.elementAt(index),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 17.h, horizontal: 14.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  provider.availableDistricts.elementAt(index),
                                  style: FontPalette.black14Regular,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      initialValue: addressProvider?.selectedDistrict ??
                          Constants.cityOrDistrict,
                    ),
                  ),
                  12.verticalSpace,
                  addressProvider?.availableStates.length == 1 ||
                          (addressProvider?.availableStates.length ?? 0) < 1
                      ? Container(
                          alignment: AlignmentDirectional.centerStart,
                          width: context.sw(),
                          height: 45.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: HexColor('#DBDBDB'),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 14.w),
                            child: Text(
                              Constants.kerala,
                              style: FontPalette.black14Regular,
                            ),
                          ),
                        )
                      : Consumer<AddressProvider>(
                          builder: (_, provider, __) => CustomDropdown<Region>(
                            initialTextStyle: widget.update! ||
                                    addressProvider?.availableStates.length == 1
                                ? FontPalette.black14Regular
                                : null,
                            onChange: (value) {
                              addressProvider!.selectedState = value;

                              addressProvider!.checkStateDropdown();
                            },
                            dropdownStyle: DropdownStyle(
                              color: Colors.white,
                              borderSide: BorderSide(
                                color: HexColor("#DBDBDB"),
                              ),
                            ),
                            dropdownButtonStyle: DropdownButtonStyle(
                              unselectedTextStyle:
                                  FontPalette.f7B7E8E_14Regular,
                              textStyle: FontPalette.black14Regular,
                              padding: EdgeInsets.only(left: 14.w, right: 4.w),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: provider.stateDropdownHasError
                                    ? ColorPalette.redColor
                                    : HexColor("#DBDBDB"),
                              )),
                            ),
                            items: List.generate(
                              provider.availableStates.length,
                              (index) => DropdownItem(
                                  value: addressProvider!.selectedState ??
                                      provider.availableStates.elementAt(index),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 17.h, horizontal: 14.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          provider.availableStates
                                                  .elementAt(index)
                                                  .region ??
                                              '',
                                          style: FontPalette.black14Regular,
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            initialValue: addressProvider
                                    ?.selectedState?.region ??
                                (addressProvider?.availableStates.length == 1
                                    ? Constants.kerala
                                    : Constants.state),
                          ),
                        ),
                  20.verticalSpace,
                  Text(Constants.saveAddressAs,
                      style: FontPalette.black16Medium),
                  16.verticalSpace,
                  Consumer<AddressProvider>(
                    builder: (_, provider, __) => Column(
                      children: [
                        Row(
                          children: [
                            ...provider.addressTypes.map(
                              (e) => Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: InkWell(
                                  onTap: () =>
                                      addressProvider!.updateAddressType(e.id),
                                  child: CustomActionChip(
                                    text: e.type,
                                    isSelected: e.isSelected!,
                                  ),
                                ).removeSplash(),
                              ),
                            )
                          ],
                        ),
                        20.verticalSpace,
                        if (provider.selectedAddressTypeId == 1)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomCheckBox(
                                size: 15.r,
                                isSelected: provider.openOnSaturday,
                                onTap: () => provider
                                    .updateWeekendAddressStatusAndDefaultAddress(
                                        0),
                              ),
                              6.horizontalSpace,
                              Flexible(
                                  child: InkWell(
                                onTap: () => provider
                                    .updateWeekendAddressStatusAndDefaultAddress(
                                        0),
                                child: Text(Constants.openOnSaturday,
                                    style: FontPalette.black14Regular),
                              ).removeSplash()),
                            ],
                          )
                        else
                          const SizedBox.shrink(),
                        provider.selectedAddressTypeId == 1
                            ? 14.verticalSpace
                            : const SizedBox.shrink(),
                        if (provider.selectedAddressTypeId == 1)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomCheckBox(
                                size: 15.r,
                                isSelected: provider.openOnSunday,
                                onTap: () => provider
                                    .updateWeekendAddressStatusAndDefaultAddress(
                                        1),
                              ),
                              6.horizontalSpace,
                              Flexible(
                                  child: InkWell(
                                onTap: () => provider
                                    .updateWeekendAddressStatusAndDefaultAddress(
                                        1),
                                child: Text(Constants.openOnSunday,
                                    style: FontPalette.black14Regular),
                              ).removeSplash()),
                            ],
                          )
                        else
                          const SizedBox.shrink(),
                        provider.selectedAddressTypeId == 1
                            ? 28.verticalSpace
                            : const SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(Constants.makeThisDefaultAddress,
                                  style: FontPalette.black16Medium),
                            ),
                            25.horizontalSpace,
                            CustomSwitch(
                              isSelected: provider.makeThisMyDefaultAddress,
                              onTap: () => provider
                                  .updateWeekendAddressStatusAndDefaultAddress(
                                      2),
                            ),
                          ],
                        ),
                        32.verticalSpace,
                        Selector<AddressProvider, LoaderState>(
                          selector: (_, p) => p.loaderState,
                          builder: (_, value, __) => CustomButton(
                            enabled: widget.update == true
                                ? true
                                : !provider.firstNameIsEmpty &&
                                    !provider.lastNameIsEmpty &&
                                    !provider.mobileNumberIsEmpty &&
                                    !provider.pincodeIsEmpty &&
                                    !provider.localityOrTownIsEmpty &&
                                    !provider.addressIsEmpty &&
                                    !provider.districtIsEmpty,
                            title: Constants.saveAndContinue,
                            isLoading: value == LoaderState.loading,
                            onPressed: () {
                              widget.update!
                                  ? _continueToUpdateAddress()
                                  : _continueToAddAddress();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  30.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    addressProvider = context.read<AddressProvider>();
    CommonFunctions.afterInit(_loadAvailableRegions);
    presetUpdateValues();
    _formKey = GlobalKey<FormState>();
    CommonFunctions.afterInit(() {
      FocusScope.of(context).requestFocus(firstNameFocusNode);
    });
  }

  @override
  void dispose() {
    CommonFunctions.afterInit(_resetValues);
    super.dispose();
  }

  void _loadAvailableRegions() async {
    addressProvider!.setStatesAndDistricts(context);
  }

  void _resetValues() {
    addressProvider!.pageDispose();
  }

  String? _validateContactNumber(String value) {
    String pattern = r"^[0-9]+$";
    RegExp regExp = RegExp(pattern);
    if (contactNumberController.text.isEmpty) {
      return Constants.emptyStringMsg;
    } else if (!regExp.hasMatch(contactNumberController.text) ||
        contactNumberController.text.length < 10) {
      return Constants.invalidContactMessage;
    }
    return null;
  }

  String? _validateOtherTextFields(String value, {String? hint}) {
    if (value == '') {
      return Constants.emptyStringMsg;
    } else if (value.length < 3) {
      return 'Please enter a valid ${hint ?? Constants.value}';
    }
    return null;
  }

  void presetUpdateValues() {
    Addresses? address = widget.addresses;
    if (widget.update! && address != null) {
      firstNameController.text = address.firstname ?? '';
      lastNameController.text = address.lastname ?? '';
      contactNumberController.text = address.telephone?.substring(3) ?? '';
      pincodeController.text = address.postcode ?? '';
      localityOrTownController.text = address.street!.last;
      streetController.text = address.street![0];
      addressProvider!.selectedDistrict = address.city;
      addressProvider!.selectedState = address.region;
      addressProvider!.setWorkAddressOpenStatus(address.workdays);
      if (address.addresstype == '0') {
        addressProvider!.selectedAddressTypeId = 0;
        addressProvider!.addressTypes[0].isSelected = true;
        addressProvider!.addressTypes[1].isSelected = false;
      } else if (address.addresstype == '1') {
        addressProvider?.selectedAddressTypeId = 1;
        addressProvider!.addressTypes[1].isSelected = true;
        addressProvider!.addressTypes[0].isSelected = false;
      }
      addressProvider!.makeThisMyDefaultAddress =
          address.defaultShipping ?? false;
      addressProvider!.setWorkAddressOpenStatus(address.workdays);
    }
  }

  void _continueToAddAddress() {
    bool valueOne = addressProvider!.checkDistrictDropdown();
    bool valueTwo = addressProvider!.checkStateDropdown();
    log(valueTwo.toString());
    if (_formKey.currentState!.validate() && valueOne && valueTwo) {
      addressProvider!
          .saveAddress(context,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              contactNumber: contactNumberController.text,
              pincode: pincodeController.text,
              localityOrTown: localityOrTownController.text,
              street: streetController.text)
          .then((value) {
        if (value == true) Navigator.pop(context, value);
      });
    }
  }

  void _continueToUpdateAddress() {
    bool valueOne = addressProvider!.checkDistrictDropdown();
    bool valueTwo = addressProvider!.checkStateDropdown();
    if (_formKey.currentState!.validate() && valueOne && valueTwo) {
      addressProvider!
          .updateAddress(context, widget.addresses!.id!,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              contactNumber: contactNumberController.text,
              pincode: pincodeController.text,
              localityOrTown: localityOrTownController.text,
              street: streetController.text)
          .then((value) {
        if (value == true) {
          Navigator.pop(context);
        }
      });
    }
  }
}
