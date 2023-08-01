import 'package:flutter/material.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/notification_list_data_model.dart';
import 'package:oxygen/providers/notification_list_provider.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/notification/no_notification_screen.dart';
import 'package:oxygen/views/notification/widgets/notification_tile.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final NotificationListProvider notificationListProvider;

  @override
  void initState() {
    notificationListProvider = NotificationListProvider();
    super.initState();
    CommonFunctions.afterInit(() async {
      await notificationListProvider.getNotificationList();
      await notificationListProvider.clearNotificationCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => notificationListProvider,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: const WhatsappChatWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        appBar: CommonAppBar(
          buildContext: context,
          pageTitle: Constants.notifications,
          actionList: const [],
        ),
        body: Selector<NotificationListProvider,
            Tuple3<LoaderState, bool, NotificationListDataModel?>>(
          selector: (_, provider) => Tuple3(provider.loaderState,
              provider.btnLoaderState, provider.notificationListDataModel),
          builder: (_, data, __) {
            switch (data.item1) {
              case LoaderState.loaded:
                return CustomSlidingFadeAnimation(
                  slideDuration: const Duration(milliseconds: 250),
                  child: RefreshIndicator(
                    onRefresh: () async => await notificationListProvider
                        .getNotificationList(retry: true),
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return NotificationTile(
                          item: data.item3?.items?[index],
                        );
                      },
                      itemCount: data.item3?.items?.length ?? 0,
                    ),
                  ),
                );
              case LoaderState.loading:
                return const CommonLinearProgress();
              case LoaderState.error:
                return CustomSlidingFadeAnimation(
                  slideDuration: const Duration(milliseconds: 250),
                  child: ApiErrorScreens(
                    loaderState: data.item1,
                    btnLoader: data.item2,
                    onTryAgain: () =>
                        notificationListProvider.getNotificationList(
                      retry: true,
                    ),
                  ),
                );
              case LoaderState.networkErr:
                return CustomSlidingFadeAnimation(
                  slideDuration: const Duration(milliseconds: 250),
                  child: ApiErrorScreens(
                      loaderState: data.item1,
                      btnLoader: data.item2,
                      onTryAgain: () => notificationListProvider
                          .getNotificationList(retry: true)),
                );
              case LoaderState.noData:
                return const NoNotificationScreen();
              case LoaderState.noProducts:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
