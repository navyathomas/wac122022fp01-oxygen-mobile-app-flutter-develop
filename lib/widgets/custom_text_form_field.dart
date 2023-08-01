import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxDecoration? decoration;
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final InputDecoration? inputDecoration;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool? autofocus;
  final bool? readOnly;
  final ToolbarOptions? toolbarOptions;
  final bool? showCursor;
  final String? obscuringCharacter;
  final bool? obscureText;
  final bool? autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool? enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? minLines;
  final bool? expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double? cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets? scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;
  final String? restorationId;
  final bool? enableIMEPersonalizedLearning;
  final MouseCursor? mouseCursor;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final int? maxLines;
  const CustomTextFormField(
      {Key? key,
      this.height,
      this.width,
      this.decoration,
      this.controller,
      this.initialValue,
      this.focusNode,
      this.inputDecoration,
      this.keyboardType,
      this.textCapitalization,
      this.textInputAction,
      this.style,
      this.strutStyle,
      this.textDirection,
      this.textAlign,
      this.textAlignVertical,
      this.autofocus,
      this.readOnly,
      this.toolbarOptions,
      this.showCursor,
      this.obscuringCharacter,
      this.obscureText,
      this.autocorrect,
      this.smartDashesType,
      this.smartQuotesType,
      this.enableSuggestions,
      this.maxLengthEnforcement,
      this.minLines,
      this.expands,
      this.maxLength,
      this.onChanged,
      this.onTap,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.onSaved,
      this.validator,
      this.inputFormatters,
      this.enabled,
      this.cursorWidth,
      this.cursorHeight,
      this.cursorRadius,
      this.cursorColor,
      this.keyboardAppearance,
      this.scrollPadding,
      this.enableInteractiveSelection,
      this.selectionControls,
      this.buildCounter,
      this.scrollPhysics,
      this.autofillHints,
      this.autovalidateMode,
      this.scrollController,
      this.restorationId,
      this.enableIMEPersonalizedLearning,
      this.mouseCursor,
      this.prefixWidget,
      this.suffixWidget,
      this.hintText,
      this.contentPadding,
      this.hintStyle,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          height: height ?? 45.h,
          width: width ?? double.maxFinite,
          decoration: decoration ??
              BoxDecoration(
                border: Border.all(
                  width: 1.r,
                  color: Colors.black,
                ),
              ),
        ),
        Row(
          children: [
            prefixWidget ?? const SizedBox.shrink(),
            Expanded(
              child: TextFormField(
                controller: controller,
                initialValue: initialValue,
                focusNode: focusNode,
                decoration: inputDecoration ??
                    InputDecoration(
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: hintText,
                        hintStyle: hintStyle,
                        contentPadding: contentPadding ??
                            const EdgeInsets.symmetric(horizontal: 10)),
                keyboardType: keyboardType,
                textCapitalization:
                    textCapitalization ?? TextCapitalization.none,
                textInputAction: textInputAction,
                style: style,
                strutStyle: strutStyle,
                textDirection: textDirection,
                textAlign: textAlign ?? TextAlign.start,
                textAlignVertical: textAlignVertical,
                autofocus: autofocus ?? false,
                readOnly: readOnly ?? false,
                toolbarOptions: toolbarOptions,
                showCursor: showCursor,
                obscuringCharacter: obscuringCharacter ?? '•',
                obscureText: obscureText ?? false,
                autocorrect: autocorrect ?? true,
                smartDashesType: smartDashesType,
                smartQuotesType: smartQuotesType,
                enableSuggestions: enableSuggestions ?? true,
                maxLengthEnforcement: maxLengthEnforcement,
                minLines: minLines,
                maxLines: maxLines,
                expands: expands ?? false,
                maxLength: maxLength,
                onChanged: onChanged,
                onTap: onTap,
                onEditingComplete: onEditingComplete,
                onFieldSubmitted: onFieldSubmitted,
                onSaved: onSaved,
                validator: validator,
                inputFormatters: inputFormatters,
                enabled: enabled,
                cursorWidth: cursorWidth ?? 2.0,
                cursorHeight: cursorHeight,
                cursorRadius: cursorRadius,
                cursorColor: cursorColor,
                keyboardAppearance: keyboardAppearance,
                scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
                enableInteractiveSelection: enableInteractiveSelection,
                selectionControls: selectionControls,
                buildCounter: buildCounter,
                scrollPhysics: scrollPhysics,
                autofillHints: autofillHints,
                autovalidateMode: autovalidateMode,
                scrollController: scrollController,
                restorationId: restorationId,
                enableIMEPersonalizedLearning:
                    enableIMEPersonalizedLearning ?? true,
                mouseCursor: mouseCursor,
              ),
            ),
            suffixWidget ?? const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
