import 'package:flutter/material.dart';
import 'package:oxygen/utils/color_palette.dart';

class OrderTracker extends StatefulWidget {
  final MyOrderStatus? status;

  final Color? activeColor;

  final Color? inActiveColor;

  const OrderTracker({
    Key? key,
    required this.status,
    this.activeColor,
    this.inActiveColor,
  }) : super(key: key);

  @override
  State<OrderTracker> createState() => _OrderTrackerState();
}

class _OrderTrackerState extends State<OrderTracker>
    with TickerProviderStateMixin {
  AnimationController? controller;

  AnimationController? controller2;

  AnimationController? controller3;

  bool isFirst = false;
  bool isSecond = false;
  bool isThird = false;

  final Duration _duration = const Duration(seconds: 2);

  @override
  void initState() {
    if (widget.status?.name == MyOrderStatus.ordered.name) {
      controller = AnimationController(
        vsync: this,
        duration: _duration,
      )..addListener(() {
          if (controller?.value != null && controller!.value > 0) {
            controller?.stop();
          }
          setState(() {});
        });
    } else if (widget.status?.name == MyOrderStatus.shipped.name) {
      controller = AnimationController(
        vsync: this,
        duration: _duration,
      )..addListener(() {
          if (controller?.value != null && controller!.value > 0.99) {
            controller?.stop();
            controller2?.stop();
            isFirst = true;
            controller2?.forward(from: 0.0);
          }
          setState(() {});
        });

      controller2 = AnimationController(
        vsync: this,
        duration: _duration,
      )..addListener(() {
          if (controller2?.value != null && controller2!.value > 0) {
            controller2?.stop();
            controller3?.stop();
            isSecond = true;
            controller3?.forward(from: 0.0);
          }
          setState(() {});
        });
    } else if (widget.status?.name == MyOrderStatus.outForDelivery.name) {
      controller = AnimationController(
        vsync: this,
        duration: _duration,
      )..addListener(() {
          if (controller?.value != null && controller!.value > 0.99) {
            controller?.stop();
            controller2?.stop();
            controller3?.stop();
            isFirst = true;
            controller2?.forward(from: 0.0);
          }
          setState(() {});
        });

      controller2 = AnimationController(
        vsync: this,
        duration: _duration,
      )..addListener(() {
          if (controller2?.value != null && controller2!.value > 0.99) {
            controller2?.stop();
            controller3?.stop();
            isSecond = true;
            controller3?.forward(from: 0.0);
          }
          setState(() {});
        });

      controller3 = AnimationController(
        vsync: this,
        duration: _duration,
      )..addListener(() {
          if (controller3?.value != null && controller3!.value > 0.01) {
            controller3?.stop();
            isThird = true;
          }
          setState(() {});
        });
    }

    controller?.repeat(reverse: false);
    controller2?.repeat(reverse: false);
    controller3?.repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    controller2?.dispose();
    controller3?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.status == MyOrderStatus.canceled ||
            widget.status == MyOrderStatus.paymentFailed
        ? Column(
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Container(
                width: 1,
                height: 34,
                color: Colors.red,
              ),
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          )
        : Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: HexColor('#179614'),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 3.6),
                        child: SizedBox(
                          width: 1,
                          height: 30,
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: LinearProgressIndicator(
                              value: controller?.value ?? 0.0,
                              backgroundColor: HexColor('#7B7E8E'),
                              color: HexColor('#179614'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: (widget.status?.name ==
                                          MyOrderStatus.shipped.name ||
                                      widget.status?.name ==
                                          MyOrderStatus.outForDelivery.name) &&
                                  isFirst == true
                              ? HexColor('#179614')
                              : HexColor('#7B7E8E'),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 3.6),
                        child: SizedBox(
                          width: 1,
                          height: 30,
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: LinearProgressIndicator(
                              value: controller2?.value ?? 0.0,
                              backgroundColor: HexColor('#7B7E8E'),
                              color: isFirst == true
                                  ? HexColor('#179614')
                                  : HexColor('#7B7E8E'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: (widget.status?.name ==
                                      MyOrderStatus.outForDelivery.name) &&
                                  isSecond == true
                              ? HexColor('#179614')
                              : HexColor('#7B7E8E'),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
  }
}

enum MyOrderStatus { ordered, shipped, outForDelivery, canceled, paymentFailed }
