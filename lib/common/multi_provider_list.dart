import 'package:oxygen/providers/address_provider.dart';
import 'package:oxygen/providers/auth_provider.dart';
import 'package:oxygen/providers/category_provider.dart';
import 'package:oxygen/providers/faq_provider.dart';
import 'package:oxygen/providers/home_provider.dart';
import 'package:oxygen/providers/latest_offers_provider.dart';
import 'package:oxygen/providers/my_orders_provider.dart';
import 'package:oxygen/providers/my_profile_provider.dart';
import 'package:oxygen/providers/notification_list_provider.dart';
import 'package:oxygen/providers/stores_provider.dart';
import 'package:oxygen/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../providers/app_data_provider.dart';
import '../providers/cart_provider.dart';

class MultiProviderList {
  static List<SingleChildWidget> providerList = [
    ChangeNotifierProvider(create: (_) => AppDataProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => MyProfileProvider()),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => WishListProvider()),
    ChangeNotifierProvider(create: (_) => StoresProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => AddressProvider()),
    ChangeNotifierProvider(create: (_) => FaqProvider()),
    ChangeNotifierProvider(create: (_) => LatestOffersProvider()),
    ChangeNotifierProvider(create: (_) => NotificationListProvider()),
  ];
}
