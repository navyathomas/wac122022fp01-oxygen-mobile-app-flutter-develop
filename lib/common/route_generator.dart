import 'package:flutter/material.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/arguments/category_detailed_arguments.dart';
import 'package:oxygen/models/arguments/delete_account_argument.dart';
import 'package:oxygen/models/arguments/filter_arguments.dart';
import 'package:oxygen/models/arguments/my_order_details_arguments.dart';
import 'package:oxygen/models/arguments/order_complete_arguments.dart';
import 'package:oxygen/models/arguments/payment_arguments.dart';
import 'package:oxygen/models/arguments/payment_web_view_arguments.dart';
import 'package:oxygen/models/arguments/product_detail_arguments.dart';
import 'package:oxygen/models/arguments/product_listing_arguments.dart';
import 'package:oxygen/models/arguments/search_filter_arguments.dart';
import 'package:oxygen/models/arguments/tracking_details_arguments.dart';
import 'package:oxygen/models/arguments/service_request_arguments.dart';
import 'package:oxygen/models/customer_profile_model.dart';
import 'package:oxygen/models/faq_list_model.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/select_address_provider.dart';
import 'package:oxygen/views/address/add_address_screen.dart';
import 'package:oxygen/views/address/saved_address_screen.dart';
import 'package:oxygen/views/authentication/auth_otp_screen.dart';
import 'package:oxygen/views/authentication/auth_screen.dart';
import 'package:oxygen/views/authentication/forgot_password_screen.dart';
import 'package:oxygen/views/authentication/registration_screen.dart';
import 'package:oxygen/views/authentication/reset_password_screen.dart';
import 'package:oxygen/views/bajaj_emi/bajaj_emi_details_screen.dart';
import 'package:oxygen/views/bajaj_emi/bajaj_emi_screen.dart';
import 'package:oxygen/views/category_detailed/category_detailed_screen.dart';
import 'package:oxygen/views/compare/compare_screen.dart';
import 'package:oxygen/views/contact_us_screen/contact_us_screen.dart';
import 'package:oxygen/views/emi_options/emi_options_screen.dart';
import 'package:oxygen/views/faq/faq_and_help_screen.dart';
import 'package:oxygen/views/faq/faq_detail_view.dart';
import 'package:oxygen/views/feedback_screen/feedback_screen.dart';
import 'package:oxygen/views/filter/filter_screen.dart';
import 'package:oxygen/views/job_tracking/track_jobs_detail/track_jobs_detail_screen.dart';
import 'package:oxygen/views/job_tracking/track_jobs/track_jobs_screen.dart';
import 'package:oxygen/views/latest_offers/latest_offers_screen.dart';
import 'package:oxygen/views/loyalty/loyalty_screen.dart';
import 'package:oxygen/views/main_screen/main_screen.dart';
import 'package:oxygen/views/my_orders/my_orders_screen.dart';
import 'package:oxygen/views/my_orders/tracking_details_screen.dart';
import 'package:oxygen/views/my_profile/change_password_screen.dart';
import 'package:oxygen/views/my_profile/delete_account_screen.dart';
import 'package:oxygen/views/my_profile/my_profile_screen.dart';
import 'package:oxygen/views/my_profile/update_contacts_screen.dart';
import 'package:oxygen/views/my_profile/verify_otp_screen.dart';
import 'package:oxygen/views/notification/notification_screen.dart';
import 'package:oxygen/views/order_complete/order_complete_screen.dart';
import 'package:oxygen/views/order_detail/order_detail_screen.dart';
import 'package:oxygen/views/payment/payment_screen.dart';
import 'package:oxygen/views/payment/payment_web_view.dart';
import 'package:oxygen/views/product_detail/product_detail_screen.dart';
import 'package:oxygen/views/product_detail/product_detail_terms_and_conditions_screen.dart';
import 'package:oxygen/views/product_listing/product_listing_filter_screen.dart';
import 'package:oxygen/views/product_listing/product_listing_screen.dart';
import 'package:oxygen/views/ratings_and_review/ratings_and_reviews_screen.dart';
import 'package:oxygen/views/ratings_and_review/submit_rating_and_review_screen.dart';
import 'package:oxygen/views/search/search_product.dart';
import 'package:oxygen/views/service_request/service_request_screen.dart';
import 'package:oxygen/views/store/store_screen.dart';
import 'package:oxygen/views/terms_and_conditions/privacy_policy_screen.dart';
import 'package:oxygen/views/terms_and_conditions/terms_and_conditions_screen.dart';
import 'package:oxygen/widgets/common_appbar.dart';

import '../models/arguments/main_screen_arguments.dart';
import '../views/address/select_address_screen.dart';
import '../views/authentication/auth_password_screen.dart';
import '../views/payment/payment_failure_screen.dart';
import '../views/product_listing/search_product_listing_screen.dart';
import '../views/splash/splash_screen.dart';

class RouteGenerator {
  static RouteGenerator? _instance;

  static RouteGenerator get instance {
    _instance ??= RouteGenerator();
    return _instance!;
  }

  static const String routeInitial = "/";
  static const String routeAuthScreen = "/authScreen";
  static const String routeRegistrationScreen = "/registrationScreen";
  static const String routeMainScreen = "/mainScreen";
  static const String routeMainScreenSlide = "/mainScreenSlide";
  static const String routeError = "/error";
  static const String routeSignUp = "/signup";
  static const String routeAuthOTPVerification = "/authOTPVerification";
  static const String routeAuthPasswordScreen = "/authPasswordScreen";
  static const String routeForgotPassword = "/forgotPassword";
  static const String routeResetPassword = "/resetPassword";
  static const String routeAccountScreen = '/accountScreen';
  static const String routeMyProfileScreen = '/myProfileScreen';
  static const String routeChangePasswordScreen = '/changePasswordScreen';
  static const String routeNotificationScreen = '/notificationScreen';
  static const String routeFaqAndHelpScreen = '/faqAndHelpScreen';
  static const String routeFaqDetailedView = '/faqDetailedView';
  static const String routeProfileVerifyOtpScreen = '/profileVerifyOtpScreen';
  static const String routeMyOrdersScreen = '/myOrdersScreen';
  static const String routeSavedAddressScreen = '/addressScreen';
  static const String routeContactUsScreen = '/contactUsScreen';
  static const String routeLeaveFeedbackSceen = '/leaveFeedbackScreen';
  static const String routeTrackJobScreen = '/trackJobScreen';
  static const String routeTrackJobsDetailScreen = '/trackJobsDetailScreen';
  static const String routeTrackingDetailScreen = '/trackingDetailScreen';
  static const String routeTermsAndConditionScreen = '/termsAndConditionScreen';
  static const String routeSearchScreen = '/searchScreen';
  static const String routeSearchProductListing = '/searchProductListingScreen';
  static const String routePaymentScreen = '/paymentScreen';
  static const String routeDeleteMyAccount = '/deleteMyAccount';
  static const String routeLatestOffersScreen = '/latestOffersScreen';
  static const String routeStoresScreen = '/storesScreen';
  static const String routeProductDetailScreen = '/productDetailScreen';
  static const String routeProductEmiPlansScreen = '/productEmiPlansScreen';
  static const String routeAddAddressScreen = '/addAddressScreen';
  static const String routeOrderDetailScreen = '/orderDetailScreen';
  static const String routeRatingsAndReviewsScreen = '/ratingsAndReviewsScreen';
  static const String routeProductDetailTermsAndConditionScreen =
      '/productDetailTermsAndConditionScreen';
  static const String routeFilterScreen = '/filterScreen';
  static const String routePrivacyPolicyScreen = '/privacyPolicyScreen';

  static const String routeProductListingScreen = '/productListingScreen';
  static const String routeProductListingFilterScreen =
      '/productListingFilterScreen';
  static const String routeCategoryDetailedScreen = '/categoryDetailedScreen';
  static const String routeSelectAddressScreen = '/selectAddressScreen';
  static const String routeSubmitRatingsAndReviewsScreen =
      '/submitRatingsAndReviewsScreen';
  static const String routeOrderCompleteScreen = '/orderCompleteScreen';
  static const String routePaymentWebView = '/paymentWebView';
  static const String routeUpdateContacts = '/updateContacts';
  static const String routeCompareScreen = '/routeCompare';
  static const String routeBajajEmi = '/routeBajajEmi';
  static const String routePaymentError = '/routePaymentError';
  static const String routeBajajEmiDetailsScreen = '/bajajEmiDetails';
  static const String routeLoyaltyScreen = '/routeLoyaltyScreen';

  static const String routeServiceRequest = '/serviceRequest';
  Route generateRoute(RouteSettings settings, {var routeBuilders}) {
    var args = settings.arguments;
    switch (settings.name) {
      case routeInitial:
        return _buildRoute(routeInitial, const SplashScreen());
      case routeAuthScreen:
        bool fromGuestUser = args != null && args is bool ? args : false;

        return fromGuestUser
            ? ScaleRoute(
                page: AuthScreen(
                  fromGuestUser: fromGuestUser,
                ),
                route: routeAuthScreen)
            : _buildRoute(routeAuthScreen, const AuthScreen());
      case routeAuthOTPVerification:
        NavFrom? navFrom = args != null && args is NavFrom ? args : null;
        return _buildRoute(
            routeAuthOTPVerification,
            AuthOtpScreen(
              navFrom: navFrom,
            ));
      case routeAuthPasswordScreen:
        return _buildRoute(routeAuthPasswordScreen, const AuthPasswordScreen());
      case routeRegistrationScreen:
        return _buildRoute(routeRegistrationScreen, const RegistrationScreen());
      case routeMainScreenSlide:
        int pageInt = args != null ? args as int : 0;
        return SlideRightRoute(
            route: routeMainScreenSlide,
            page: MainScreen(
              mainScreenArguments: MainScreenArguments(tabIndex: pageInt),
            ));
      case routeMainScreen:
        MainScreenArguments mainArgs =
            args != null ? args as MainScreenArguments : MainScreenArguments();
        return _buildRoute(
            routeMainScreen,
            MainScreen(
              mainScreenArguments: mainArgs,
            ));

      case routeMyProfileScreen:
        return _buildRoute(routeMyProfileScreen, const MyProfileScreen());
      case routeChangePasswordScreen:
        return _buildRoute(
            routeChangePasswordScreen, const ChangePasswordScreen());
      case routeNotificationScreen:
        return _buildRoute(routeNotificationScreen, const NotificationScreen());
      case routeFaqAndHelpScreen:
        return _buildRoute(routeFaqAndHelpScreen, const FaqAndHelpScreen());
      case routeFaqDetailedView:
        FaQs? faq;
        if (args != null) {
          faq = args as FaQs;
        }
        return _buildRoute(
            routeFaqDetailedView,
            FaqDetailView(
              faq: faq,
            ));
      case routeMyOrdersScreen:
        return _buildRoute(routeMyOrdersScreen, const MyOrdersScreen());
      case routeSavedAddressScreen:
        return _buildRoute(routeSavedAddressScreen, const SavedAddressScreen());
      case routeContactUsScreen:
        return _buildRoute(routeContactUsScreen, const ContactUsScreen());
      case routeLeaveFeedbackSceen:
        return _buildRoute(
            routeLeaveFeedbackSceen, const LeaveFeedbackScreen());
      case routeTermsAndConditionScreen:
        return _buildRoute(
            routeTermsAndConditionScreen, TermsAndConditionsScreen());
      case routeSearchScreen:
        return _buildRoute(routeSearchScreen, const SearchProductScreen());
      case routeBajajEmi:
        return _buildRoute(
            routeSearchScreen,
            BajajEmiScreen(
              selectAddressProvider: args as SelectAddressProvider,
            ));
      case routeSearchProductListing:
        ProductListingArguments? routeArgs;
        if (args != null) {
          routeArgs = args as ProductListingArguments;
        }
        return _buildRoute(
            routeSearchProductListing,
            SearchProductListingScreen(
              isFromSearch: routeArgs?.isFromSearch ?? false,
              title: routeArgs?.title ?? '',
              searchProvider: routeArgs?.searchProvider,
            ));
      case routeProductListingScreen:
        ProductListingArguments? routeArgs;
        if (args != null) {
          routeArgs = args as ProductListingArguments;
        }
        return _buildRoute(
            routeProductListingScreen,
            ProductListingScreen(
              categoryId: routeArgs?.categoryId ?? '',
              title: routeArgs?.title ?? '',
              filterPrice: routeArgs?.filterPrice,
              searchProvider: routeArgs?.searchProvider,
              attributeType: routeArgs?.attributeType ?? '',
              attribute: routeArgs?.attribute,
              filterType: routeArgs?.filterType,
            ));
      case routePaymentScreen:
        PaymentArguments arguments = args as PaymentArguments;
        return _buildRoute(
            routePaymentScreen,
            PaymentScreen(
              paymentArguments: arguments,
            ));
      case routeDeleteMyAccount:
        return _buildRoute(routeDeleteMyAccount, const DeleteAccountScreen());
      case routeLatestOffersScreen:
        return _buildRoute(routeLatestOffersScreen, const LatestOffersScreen());
      case routeStoresScreen:
        return _buildRoute(routeStoresScreen, const StoresScreen());
      case routeForgotPassword:
        return _buildRoute(routeForgotPassword, const ForgotPasswordScreen());
      case routeResetPassword:
        return _buildRoute(routeResetPassword, const ResetPasswordScreen());
      case routeProductDetailScreen:
        ProductDetailsArguments arguments = args as ProductDetailsArguments;
        return _buildRoute(
            routeProductDetailScreen,
            ProductDetailScreen(
              sku: arguments.sku,
              isFromSearch: arguments.isFromSearch,
              item: arguments.item,
              isFromInitialState: arguments.isFromInitialState,
              searchProvider: arguments.searchProvider,
            ));
      case routeProductEmiPlansScreen:
        ProductDetailsArguments arguments = args as ProductDetailsArguments;
        return _buildRoute(
            routeProductEmiPlansScreen,
            EmiOptionsScreen(
                item: arguments.item,
                emiPlans: arguments.emiPlans,
                onRefresh: arguments.onRefresh!));
      case routeAddAddressScreen:
        return _buildRoute(routeAddAddressScreen, const AddAddressScreen());
      case routeFilterScreen:
        SearchFilterArguments? routeArgs;
        if (args != null) {
          routeArgs = args as SearchFilterArguments;
        }
        return _buildRoute(
            routeFilterScreen,
            FilterScreen(
              scrollController: routeArgs!.scrollController,
              searchProductListingProvider:
                  routeArgs.searchProductListingProvider,
              searchProvider: routeArgs.searchProvider,
            ));
      case routeProductListingFilterScreen:
        FilterArguments? routeArgs;
        if (args != null) {
          routeArgs = args as FilterArguments;
        }
        return _buildRoute(
            routeProductListingFilterScreen,
            ProductListingFilterScreen(
              productListingProvider: routeArgs!.productListingProvider,
              categoryId: routeArgs.categoryId,
              scrollController: routeArgs.scrollController,
            ));
      case routeRatingsAndReviewsScreen:
        ProductDetailsArguments arguments = args as ProductDetailsArguments;
        return _buildRoute(routeRatingsAndReviewsScreen,
            RatingsAndReviewsScreen(sku: arguments.sku));
      case routeOrderDetailScreen:
        MyOrderDetailsArguments arguments = args as MyOrderDetailsArguments;
        return _buildRoute(
            routeOrderDetailScreen,
            OrderDetailScreen(
              myOrderDetailsArguments: arguments,
            ));
      case routeProductDetailTermsAndConditionScreen:
        ProductDetailsArguments arguments = args as ProductDetailsArguments;
        return _buildRoute(
            routeProductDetailTermsAndConditionScreen,
            ProductDetailTermsAndConditionsScreen(
                identifier: arguments.identifier));
      case routePrivacyPolicyScreen:
        return _buildRoute(routePrivacyPolicyScreen, PrivacyPolicyScreen());
      case routeCategoryDetailedScreen:
        CategoryDetailedArguments arguments = args as CategoryDetailedArguments;
        return _buildRoute(
            routeCategoryDetailedScreen,
            CategoryDetailedScreen(
                type: arguments.type, title: arguments.pageTitle));
      case routeProfileVerifyOtpScreen:
        DeleteCustomerAccountArguments arguments =
            args as DeleteCustomerAccountArguments;
        return _buildRoute(routeProfileVerifyOtpScreen,
            MyProfileVerifyOtpScreen(arguments: arguments));
      case routeSelectAddressScreen:
        return _buildRoute(
            routeSelectAddressScreen, const SelectAddressScreen());
      case routeSubmitRatingsAndReviewsScreen:
        return _buildRoute(routeSubmitRatingsAndReviewsScreen,
            SubmitRatingAndReviewScreen(item: args as Item));
      case routeOrderCompleteScreen:
        OrderCompleteArguments arguments = args as OrderCompleteArguments;
        return _buildRoute(
            routeOrderCompleteScreen,
            OrderCompleteScreen(
              paymentProvider: arguments.paymentProvider,
            ));
      case routePaymentWebView:
        PaymentWebViewArguments arguments = args as PaymentWebViewArguments;
        return _buildRoute(
            routePaymentWebView,
            PaymentWebView(
              actionUrl: arguments.actionUrl ?? '',
              paymentProvider: arguments.paymentProvider,
            ));
      case routeUpdateContacts:
        CustomerProfileModel? routeArgs = args as CustomerProfileModel;
        return _buildRoute(
            routeUpdateContacts, UpdateContactScreen(profileModel: routeArgs));
      case routeCompareScreen:
        return _buildRoute(routeCompareScreen, const CompareScreen());
      case routePaymentError:
        return _buildRoute(routePaymentError, const PaymentFailureScreen(),
            enableFullScreen: true);
      case routeBajajEmiDetailsScreen:
        ProductDetailsArguments arguments = args as ProductDetailsArguments;
        return _buildRoute(
            routeBajajEmiDetailsScreen,
            BajajEmiDetailsScreen(
              bajajEmiDetails: arguments.bajajEmiDetails,
            ));
      case routeLoyaltyScreen:
        return _buildRoute(routeLoyaltyScreen, const LoyaltyScreen());
      case routeTrackJobScreen:
        return _buildRoute(
            routeTrackJobScreen, TrackJobScreen(initialIndex: args as int?));
      case routeTrackJobsDetailScreen:
        return _buildRoute(
            routeTrackJobsDetailScreen,
            TrackJobsDetailScreen(
              jobId: args as String?,
            ));
      case routeTrackingDetailScreen:
        TrackingDetailsArguments arguments = args as TrackingDetailsArguments;
        return _buildRoute(
            routeTrackingDetailScreen,
            TrackingDetailScreen(
              trackDeliveryStatus: arguments.trackDeliveryStatus,
              customerDeliveryDetails: arguments.customerDeliveryDetails,
            ));

      case routeServiceRequest:
        ServiceRequestArguments? routeArgs;
        if (args != null) {
          routeArgs = args as ServiceRequestArguments;
        }
        return _buildRoute(
            routeServiceRequest,
            ServiceRequestScreen(
              orderId: routeArgs?.orderId ?? '',
              itemId: routeArgs?.itemId ?? '',
              isDemoRequest: routeArgs?.isDemoRequest ?? false,
            ));
      default:
        return _buildRoute(routeError, const ErrorView());
    }
  }

  Route _buildRoute(String route, Widget widget,
      {bool enableFullScreen = false}) {
    return MaterialPageRoute(
        fullscreenDialog: enableFullScreen,
        settings: RouteSettings(name: route),
        builder: (_) => widget);
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(buildContext: context, pageTitle: Constants.error),
        body: const Center(child: Text('Page Not Found!')));
  }
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  final String route;

  ScaleRoute({required this.page, this.route = ''})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          settings: RouteSettings(name: route),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          ),
        );
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  final String route;

  SlideRightRoute({required this.page, this.route = ''})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
