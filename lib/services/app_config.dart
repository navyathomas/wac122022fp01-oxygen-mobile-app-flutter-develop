class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() => _instance;

  AppConfig._internal();

  static String baseUrl = "https://oxygen-test.webc.in/";
  static String appLocale = 'en';
  static String? accessToken;
  static String firebaseToken = '';
  static String? cartId;
  static int? wishListId;
  static String currency = "";
  static String navFrom = "";
  static bool enableRating = false;
  static bool enableGoogleSignIn = false;
  static bool enableFacebookSignIn = false;
  static bool enableAppleSignIn = false;
  static bool enableForceButton = false;
  static String buildNumber = "";
  static String apiKey = "AIzaSyBGydm4NNPvoiRJnAQqahkr8Y9IKbS2OAQ";

  static bool get isAuthorized => (AppConfig.accessToken ?? '').isNotEmpty;
}
