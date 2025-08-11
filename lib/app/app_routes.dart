import 'package:flutter/material.dart';

import '../views/authentication/ebill_register.dart';
import '../views/authentication/register_screen.dart';
import '../views/authentication/security_authentication.dart';
import '../views/authentication/signin_screen.dart';
import '../views/bills/billing_overview.dart';
import '../shared/pages/page_alert.dart';
import '../views/products/product_center.dart';
import '../views/intro.dart';
import '../views/app_home.dart';
import '../views/home/home_screen.dart';
import '../views/notifications/notifications.dart';
import '../views/offers/offers_screen.dart';
import '../views/points/points_redeem.dart';
import '../views/products/product_details.dart';
import '../views/points/points_screen.dart';
import '../views/promotions/promotion_center.dart';
import '../views/promotions/promotion_details.dart';
import '../views/products/review_details.dart';
import '../views/search.dart';

import '../views/test/color_page.dart';
import '../views/test/test_route.dart';
import '../views/vouchers/voucher_center.dart';
import '../views/walk_through.dart';
import '../views/products/ratings_and_reviews.dart';
import '../views/products/create_product_review.dart';

import '../views/settings/settings.dart';
import '../views/settings/preferences.dart';
import '../views/settings/app_lock.dart';
import '../views/settings/linked_devices.dart';
import '../views/settings/permissions.dart';
import '../views/settings/about_us.dart';
import '../views/settings/account_info.dart';
import '../views/settings/feedback.dart';
import '../views/settings/help_center.dart';
import '../views/settings/privacy_policy.dart';
import '../views/settings/report_problem.dart';
import '../views/settings/terms_of_service.dart';


class AppRoutes {
  // Singleton instance
  AppRoutes._internal();
  static final AppRoutes instance = AppRoutes._internal();

  // base
  static const String walkThrough = "/walk_through";
  static const String intro = "/intro";
  static const String appHome = "/app_home";
  static const String home = "/home";

  // Points
  static const String points = "/points";
  static const String pointsRedeem = "/points_redeem";

  static const String billingOverview = "/bill_history";
  static const String offers = "/offers";
  // static const String account = "/profile";
  // static const String accountSettings = "/account_settings";
  static const String settings = "/settings";
  static const String preferences = "/preferences";

  static const String notifications = "/notifications";
  static const String voucherCenter = "/voucher_center";

  static const String productCenter = "/product_center";
  static const String productDetails = "/product_details?wrapAppBarIcons=true";
  static const String promotionCenter = "/promotion_center";
  static const String promotionDetails = "/promotion_details";


  // Auth
  static const String signin = "/signin";
  // static const String signinVerification = "/signin_verification";
  static const String otpVerification = "/otp_verification";
  static const String register = "/register";
  static const String securityAuthentication = "/security_authentication";
  static const String eBillRegister = "/ebill_register";

  // Test and profile
  static const String colorPage = "/color_page";
  static const String yourProfile = "/your_profile";
  static const String updateProfile = "/update_profile";


  static const String ratingsAndReviews = "/ratings_and_reviews";
  static const String reviewDetails = "/review_details";
  static const String createProductReview = "/share_your_feedback?wrapAppBarIcons=true";

  // settings
  static const String permissions = "/permissions";
  static const String appLock = "/app_lock";
  static const String linkedDevices = "/linker_devices";




  static const String search = "/search";

  static const String aboutUs = "/about_us";
  static const String accountInfo= "/account_information";
  static const String feedback = "/feedback";
  static const String helpCenter = "/help_center";
  static const String privacyPolicy = "/privacy_policy";
  static const String reportProblem = "/report_problem";
  static const String termsOfService = "/terms_of_service";

  // Initial route
  // static String initialRoute = appHome;
  // static String initialRoute = register;
  static String initialRoute = intro;
  static String testRoute = "/test_route";
  // static String initialRoute = otpVerification;

  // Route generator
  static final Map<String, WidgetBuilder> generate = {
    /// Start
    intro: (context) => const Intro(),
    walkThrough: (context) => const WalkThrough(),

    /// Authentication
    signin: (context) => const SignInView(),
    register: (context) => const RegisterScreen(),
    securityAuthentication: (context) => const SecurityAuthenticationView(),
    eBillRegister: (context) => const EBillRegisterView(),

    /// App Home
    appHome: (context) => const AppHome(),
    home: (context) => const HomeScreen(),
    points: (context) => const PointsScreen(),
    pointsRedeem: (context) => const PointsRedeem(),
    billingOverview: (context) => const BillingOverview(),
    offers: (context) => const OffersScreen(),

    // account: (context) => const AccountScreen(),
    // account: (context) => const SettingsAndPrivacy(),
    // accountSettings: (context) => const MenuView(),


    notifications: (context) => const NotificationsView(),
    productCenter: (context) => const ProductCenterView(),
    productDetails: (context) {
      final wrapAppBarIcons = RouteUtils.queryParamBool(context, 'wrapAppBarIcons');
      return ProductDetailsView(wrapAppBarIcons: wrapAppBarIcons);
    },
    voucherCenter: (context) => const VoucherCenter(),
    promotionCenter: (context) => const PromotionCenter(),
    promotionDetails: (context) => const PromotionDetails(),

    colorPage: (context) => const ColorPage(),
    ratingsAndReviews: (context) => const RatingsAndReviewsView(),
    reviewDetails: (context) => const ReviewDetailsView(),
    // shareYourFeedback: (context) => const CreateProductFeedbackView(),
    createProductReview: (context) {
      final wrapAppBarIcons = RouteUtils.queryParamBool(context, 'wrapAppBarIcons');
      return CreateProductReview(wrapAppBarIcons: wrapAppBarIcons);
    },

    // settings
    settings: (context) => const SettingsView(),
    preferences: (context) => const PreferencesView(),
    permissions: (context) => const PermissionsView(),
    appLock: (context) => const AppLockView(),
    linkedDevices: (context) => const LinkedDevicesView(),
    aboutUs: (context) => const AboutUsView(),
    accountInfo: (context) => const AccountInfoView(),
    feedback: (context) => const FeedbackView(),
    helpCenter: (context) => const HelpCenterView(),
    privacyPolicy: (context) => const PrivacyPolicyView(),
    reportProblem: (context) => const ReportProblemView(),
    termsOfService: (context) => const TermsOfServiceView(),

    search: (context) => SearchView(),
    testRoute: (context) => TestRoute(),

  };

  static Route unknown(RouteSettings settings) => MaterialPageRoute(builder: (context) => PageAlert(key: Key("notFound")));
}

class RouteUtils {
  /// Returns `true` if the query parameter [key] is not explicitly set to 'false'.
  static bool queryParamBool(BuildContext context, String key, {bool defaultValue = false}) {
    final routeName = ModalRoute.of(context)?.settings.name;
    if (routeName == null) return defaultValue;

    final uri = Uri.tryParse(routeName);
    final value = uri?.queryParameters[key]?.toLowerCase();

    if (value == 'false') return false;
    if (value == 'true') return true;

    return defaultValue;
  }
}

// class AppRoutes {
//   static final AppRoutes _instance = AppRoutes._internal();
//
//   factory AppRoutes() {
//     return _instance;
//   }
//
//   AppRoutes._internal();
//
//   ///***************************************************************************
//   /// all named routes
//   ///
//   static const String walkThrough = "/walk_through";
//   static const String intro = "/intro";
//   static const String appHome = "/app_main";
//   static const String home = "/home";
//
//   /// points
//   static const String points = "/points";
//   static const String pointsRedeem = "/points_redeem";
//
//   static const String billHistory = "/bill_history";
//   static const String offers = "/offers";
//   static const String events = "/events";
//   static const String account = "/profile";
//   static const String notifications = "/notifications";
//   static const String voucherCenter = "/voucher_center";
//
//   static const String discountCenter = "/discount_center";
//   static const String productDescription = "/discount_item_description";
//
//   static const String promotionCenter = "/promotion_center";
//
//   static const String signin = "/signin";
//   static const String otpVerification = "/otp_verification";
//   static const String register = "/register";
//
//   /// other
//   static const String aboutUs = "/about_us";
//   static const String feedback = "/feedback";
//   static const String helpAndSupport = "/help_and_support";
//   static const String settingsAndPrivacy = "/settings_and_privacy";
//
//   // test
//   static const String colorPage = "/color_page";
//
//   /// profile
//   static const String yourProfile = "/your_profile";
//   static const String updateProfile = "/update_profile";
//
//   ///***************************************************************************
//   ///***************************************************************************
//   ///***************************************************************************
//   ///
//   /// initial route of application
//   static String initialRoute = appHome;
//
//   /// route builder function
//   static Map<String, Widget Function(BuildContext)> generate = {
//     intro: (context)=> const Intro(),
//     walkThrough: (context)=> const WalkThrough(),
//     appHome: (context)=> const AppHome(),
//     home: (context)=> const HomeScreen(),
//
//     /// points
//     points: (context)=> const PointsScreen(),
//     pointsRedeem: (context)=> const PointsRedeem(),
//
//     billHistory: (context)=> const BillHistoryScreen(),
//     offers: (context)=> const OffersScreen(),
//     events: (context)=> const EventsScreen(),
//     account: (context)=> const AccountScreen(),
//     notifications: (context)=> const NotificationsScreen(),
//     discountCenter: (context)=> const DiscountCenter(),
//     productDescription: (context)=> const ProductDescription(),
//     voucherCenter: (context)=> const VoucherCenter(),
//     promotionCenter: (context)=> const PromotionCenter(),
//
//     signin: (context)=> const SigninScreen(),
//     otpVerification: (context)=> const OtpVerificationScreen(),
//     register: (context)=> const RegisterScreen(),
//
//     /// other
//     aboutUs: (context)=> const AboutUs(),
//     feedback: (context)=> const FeedbackScreen(),
//     helpAndSupport: (context)=> const HelpAndSupport(),
//     settingsAndPrivacy: (context)=> const SettingsAndPrivacy(),
//     // test
//     colorPage: (context)=> const ColorPage(),
//
//     /// profile
//     yourProfile: (context)=> const YourProfile(),
//     updateProfile: (context)=> const UpdateProfile(),
//   };
//
//   // Future<void> routeConfigure () async {
//   //   const bool authorized = false;
//   //   const bool firstAttempt = true;
//   //
//   //   if(firstAttempt) {
//   //     initialRoute = RouteNames.walkThrough;
//   //   } else if (authorized){
//   //     initialRoute = RouteNames.appMain;
//   //   } else {
//   //     initialRoute = RouteNames.intro;
//   //   }
//   // }
// }




