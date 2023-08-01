import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/providers/address_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/address/widgets/add_address_button.dart';
import 'package:oxygen/views/address/widgets/select_address_row_card_widget.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class SavedAddressScreen extends StatefulWidget {
  const SavedAddressScreen({Key? key}) : super(key: key);

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  AddressProvider? addressProvider;

  Widget _addressListView(BuildContext ctx) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Consumer<AddressProvider>(
              builder: (_, provider, __) =>
                  (provider.addressList ?? []).isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.addressList!.length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              SelectAddressRowCardWidget(
                                address: provider.addressList?[index],
                                index: index,
                                ctx: ctx,
                              ),
                              Divider(
                                height: 5.h,
                                thickness: 5.h,
                                color: HexColor("#F3F3F7"),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
            18.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: AddAddressButton(
                onTap: () => _reloadAddressList(),
              ),
            ),
            (addressProvider?.addressList ?? []).isEmpty
                ? SizedBox(
                    height: constraints.maxHeight - 81.h,
                    width: double.maxFinite,
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.iconsNoSavedAddress,
                              height: 94.h,
                              width: 86.w,
                            ),
                            41.verticalSpace,
                            Text(
                              Constants.noSavedAddress,
                              textAlign: TextAlign.center,
                              style: FontPalette.black18Medium,
                            ),
                            6.verticalSpace,
                            Text(
                              Constants.couldNotFindAnyAddress,
                              textAlign: TextAlign.center,
                              style: FontPalette.black14Regular,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            18.verticalSpace,
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.savedAddress,
        actionList: const [],
      ),
      body: SafeArea(
        child: Selector<AddressProvider, Tuple2<LoaderState, bool>>(
          selector: (_, provider) =>
              Tuple2(provider.loaderState, provider.btnLoaderState),
          builder: (_, data, __) {
            switch (data.item1) {
              case LoaderState.loaded:
                return _addressListView(context);
              case LoaderState.loading:
                return const CommonLinearProgress();
              case LoaderState.error:
                return ApiErrorScreens(
                  loaderState: data.item1,
                  btnLoader: data.item2,
                  onTryAgain: () => _loadCustomerAddresses(tryAgain: true),
                );
              case LoaderState.networkErr:
                return ApiErrorScreens(
                  loaderState: data.item1,
                  btnLoader: data.item2,
                  onTryAgain: () => _loadCustomerAddresses(tryAgain: true),
                );
              case LoaderState.noData:
                return const SizedBox.shrink();
              case LoaderState.noProducts:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    addressProvider = context.read<AddressProvider>();
    CommonFunctions.afterInit(_loadCustomerAddresses);
  }

  void _loadCustomerAddresses({bool tryAgain = false}) async {
    if (mounted) {
      await addressProvider!
          .getCustomerAddressList(context, tryAgain: tryAgain);
    }
  }

  void _reloadAddressList() {
    Navigator.pushNamed(context, RouteGenerator.routeAddAddressScreen);
  }
}
