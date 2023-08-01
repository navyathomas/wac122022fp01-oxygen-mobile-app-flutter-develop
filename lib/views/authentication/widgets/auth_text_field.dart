import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/font_palette.dart';

import '../../../utils/color_palette.dart';

class AuthTextField extends StatefulWidget {
  final double? height;
  final Widget? prefix;
  final String? labelText;
  final String? hintText;
  final int? maxLength;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? textInputFormatter;
  final bool enableObscure;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool? isEditable;
  final bool? enabled;
  final Widget? suffix;
  final TextCapitalization? textCapitalization;
  final bool? autofocus;
  final Color? borderColor;

  const AuthTextField(
      {Key? key,
      this.height,
      this.prefix,
      this.labelText,
      this.hintText,
      this.maxLength,
      this.validator,
      this.onFieldSubmitted,
      this.onChanged,
      this.textInputFormatter,
      this.enableObscure = false,
      this.controller,
      this.textInputType,
      this.textInputAction,
      this.isEditable,
      this.enabled,
      this.focusNode,
      this.suffix,
      this.textCapitalization,
      this.autofocus,
      this.borderColor})
      : super(key: key);

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late final FocusNode focusNode;
  bool obscureStat = false;

  OutlineInputBorder borderColor(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      );

  Widget _obscureBtn() {
    return IconButton(
      icon: SvgPicture.asset(
          obscureStat ? Assets.iconsObscure : Assets.iconsObscureHide),
      splashColor: Colors.transparent,
      onPressed: () {
        setState(() {
          obscureStat = !obscureStat;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomForm(
      controller: widget.controller,
      focusNode: focusNode,
      style: FontPalette.black15Regular,
      height: widget.height ?? 50.h,
      focusedBorder: borderColor(HexColor('#282C3F')),
      enabledBorder: borderColor(HexColor('#DBDBDB')),
      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      validator: widget.validator,
      labelStyle: FontPalette.f7B7E8E_15Regular,
      expandedLabelStyle: FontPalette.f282C3F_12Regular,
      labelText: widget.labelText,
      onChanged:
          widget.onChanged != null ? (val) => widget.onChanged!(val) : null,
      onFieldSubmitted: widget.onFieldSubmitted,
      prefix: widget.prefix,
      maxLength: widget.maxLength,
      suffixIcon:
          widget.suffix ?? (widget.enableObscure ? _obscureBtn() : null),
      inputFormatters: widget.textInputFormatter,
      obscureStat: obscureStat,
      textInputType: widget.textInputType,
      textInputAction: widget.textInputAction,
      hasFocus: focusNode.hasFocus,
      isEditable: widget.isEditable ?? true,
      isEnabled: widget.enabled ?? true,
      textCaps: widget.textCapitalization,
      autofocus: widget.autofocus,
    );
  }

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    obscureStat = widget.enableObscure;
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }
}

class CustomForm extends FormField<String> {
  final double? height;
  final TextEditingController? controller;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? enabledBorder;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final int? maxLength;
  final Widget? prefix;
  final Widget? suffixIcon;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? expandedLabelStyle;
  final TextStyle? hintStyle;
  final String? labelText;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? textInputType;
  final EdgeInsets? contentPadding;
  final Function(String)? onFieldSubmitted;
  final String initValue;
  final bool obscureStat;
  final bool hasFocus;
  final bool isEditable;
  final bool isEnabled;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCaps;
  final bool? autofocus;

  CustomForm({
    Key? key,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    this.height,
    this.controller,
    this.focusedBorder,
    this.enabledBorder,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.maxLength,
    this.prefix,
    this.suffixIcon,
    this.style,
    this.labelStyle,
    this.expandedLabelStyle,
    this.hintStyle,
    this.labelText,
    this.hintText,
    this.inputFormatters,
    this.textInputType,
    this.contentPadding,
    this.onFieldSubmitted,
    this.initValue = '',
    this.obscureStat = false,
    this.hasFocus = false,
    this.isEditable = true,
    this.isEnabled = true,
    this.textInputAction,
    this.textCaps,
    this.autofocus,
  }) : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initValue,
            autovalidateMode: AutovalidateMode.disabled,
            builder: (FormFieldState<String> state) {
              OutlineInputBorder border = OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                      color: state.hasError
                          ? HexColor("E50019")
                          : HexColor('#DBDBDB'),
                      width: 1.r));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height ?? 45.h,
                    child: TextFormField(
                      focusNode: focusNode,
                      controller: controller,
                      autofocus: autofocus ?? false,
                      textCapitalization: textCaps ?? TextCapitalization.none,
                      style: style,
                      onTap: onTap,
                      obscureText: obscureStat,
                      inputFormatters: inputFormatters,
                      keyboardType: textInputType,
                      textInputAction: textInputAction,
                      maxLength: maxLength,
                      readOnly: !isEditable,
                      enabled: isEnabled,
                      onChanged: (val) {
                        state.reset();
                        state.didChange(val);
                        if (onChanged != null) onChanged(val);
                      },
                      onFieldSubmitted: onFieldSubmitted,
                      decoration: InputDecoration(
                          border: state.hasError ? border : enabledBorder,
                          prefix: prefix,
                          suffixIcon: suffixIcon,
                          counterText: '',
                          focusedBorder:
                              state.hasError ? border : focusedBorder,
                          enabledBorder: state.hasError
                              ? border
                              : hasFocus
                                  ? focusedBorder
                                  : enabledBorder,
                          contentPadding: contentPadding,
                          errorBorder: border,
                          labelText: labelText,
                          hintText: hintText,
                          labelStyle: (focusNode?.hasFocus ?? false) ||
                                  (state.value ?? '').isNotEmpty
                              ? state.hasError
                                  ? expandedLabelStyle?.copyWith(
                                      color: HexColor("E50019"))
                                  : expandedLabelStyle
                              : state.hasError
                                  ? labelStyle?.copyWith(
                                      color: HexColor("E50019"))
                                  : labelStyle,
                          hintStyle: hintStyle,
                          floatingLabelBehavior: state.hasError
                              ? FloatingLabelBehavior.always
                              : hasFocus
                                  ? FloatingLabelBehavior.auto
                                  : FloatingLabelBehavior.never),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: state.hasError
                        ? Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Text(
                              state.errorText ?? '',
                              style: FontPalette.fE50019_12Regular,
                            ),
                          )
                        : const SizedBox.shrink(),
                  )
                ],
              );
            });
}
