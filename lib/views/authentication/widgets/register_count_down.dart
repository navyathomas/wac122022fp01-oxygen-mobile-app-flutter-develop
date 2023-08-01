import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/auth_provider.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/widgets/three_bounce.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../utils/font_palette.dart';

class AuthCountdown extends StatefulWidget {
  final int seconds;
  final bool? resendState;
  final Duration interval;
  final bool isFromResetPassword;

  const AuthCountdown(
      {Key? key,
      required this.seconds,
      this.resendState = false,
      this.interval = const Duration(seconds: 1),
      this.isFromResetPassword = false})
      : super(key: key);

  @override
  AuthCountdownState createState() => AuthCountdownState();
}

class AuthCountdownState extends State<AuthCountdown> {
  final int _secondsFactor = 1000000;
  late ValueNotifier<int> _currentMicroSeconds;

  // Timer
  Timer? _timer;

  bool _onFinishedExecuted = false;

  @override
  void initState() {
    _currentMicroSeconds = ValueNotifier(widget.seconds * _secondsFactor);
    _startTimer();
    super.initState();
  }

  @override
  void didUpdateWidget(AuthCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seconds != widget.seconds) {
      _currentMicroSeconds.value = widget.seconds * _secondsFactor;
    }
  }

  @override
  void dispose() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: _currentMicroSeconds,
        builder: (context, value, _) {
          print("-------------------------- ${widget.resendState!}");
          int count = value ~/ _secondsFactor;
          return (count != 0 && !widget.resendState!
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Selector<AuthProvider, bool>(
                          selector: (context, provider) =>
                              provider.btnLoaderState,
                          builder: (context, value, child) {
                            return Container(
                              height: double.maxFinite,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 13.w),
                              child: count < 10
                                  ? Text(
                                      "0:${count.toString().padLeft(2, '0')}",
                                      style: FontPalette.fE50019_16Medium)
                                  : Text(
                                      "0:${count.toString().padLeft(2, '0')}",
                                      style: FontPalette.f7B7E8E_16Medium),
                            );
                          },
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () async {
                        final bool = widget.isFromResetPassword
                            ? await context
                                .read<AuthProvider>()
                                .requestForgotPasswordOtp(resend: true)
                            : await context
                                .read<AuthProvider>()
                                .requestRegistrationOtp(context, resend: true);
                        if (bool) {
                          CommonFunctions.afterInit(() => Helpers.flushToast(
                              context,
                              msg: Constants.otpSuccessMsg));
                          _onTimerRestart();
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Selector<AuthProvider, bool>(
                            selector: (context, provider) =>
                                provider.btnLoaderState,
                            builder: (context, value, child) {
                              return Container(
                                height: double.maxFinite,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 13.w),
                                child: value
                                    ? ThreeBounce(
                                        size: 20,
                                        color: ColorPalette.primaryColor,
                                      )
                                    : Text(
                                        Constants.resend,
                                        style: FontPalette.fE50019_16Medium,
                                      ),
                              );
                            },
                          ),
                        ],
                      ),
                    ))
              .animatedSwitch();
        });
  }

  void _onTimerRestart() {
    _onFinishedExecuted = false;
    _currentMicroSeconds.value = widget.seconds * _secondsFactor;
    _startTimer();
  }

  void _startTimer() {
    if (_timer?.isActive == true) {
      _timer!.cancel();
    }

    if (_currentMicroSeconds.value != 0) {
      _timer = Timer.periodic(
        widget.interval,
        (Timer timer) {
          if (_currentMicroSeconds.value <= 0) {
            timer.cancel();
            _onFinishedExecuted = true;
          } else {
            _currentMicroSeconds.value =
                _currentMicroSeconds.value - widget.interval.inMicroseconds;
          }
        },
      );
    } else if (!_onFinishedExecuted) {
      _onFinishedExecuted = true;
    }
  }
}
