import 'package:complaints/presentation/pages/about_page.dart';
import 'package:complaints/presentation/pages/contact_us_page.dart';
import 'package:complaints/presentation/pages/freequently_asked_quest_page.dart';
import 'package:complaints/presentation/pages/privacy_policy_page.dart';
import 'package:complaints/presentation/pages/report_bug_page.dart';
import 'package:complaints/presentation/pages/terms_of_service_page.dart';
import 'package:complaints/presentation/screens/admin/admin_home_screen.dart';
import 'package:complaints/presentation/screens/admin/admin_login_screen.dart';
import 'package:complaints/presentation/screens/admin/admin_profile_page.dart';
import 'package:complaints/presentation/screens/decide_screen.dart';
import 'package:complaints/presentation/screens/spalsh_screen.dart';
import 'package:complaints/presentation/screens/user/ai_chat_help_screen.dart';
import 'package:complaints/presentation/screens/user/complaint_form_screen.dart';
import 'package:complaints/presentation/screens/user/notificaitons_screen.dart';
import 'package:complaints/presentation/screens/user/user_home_screen.dart';
import 'package:complaints/presentation/screens/user/user_login_screen.dart';
import 'package:complaints/presentation/screens/user/user_profile_page.dart';
import 'package:complaints/routes/fade_trasnsition_route.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:go_router/go_router.dart';

GoRouter appRoutes = GoRouter(
  initialLocation: '/',
  routes: [
    // Splash and initial screens with fade transition
    customTransitionRoute(
        RouterNames.splash, const SplashScreen(), PageTransitionType.fade),
    customTransitionRoute(
        RouterNames.initial, const DecideScreen(), PageTransitionType.fade),

    // Authentication screens with scale transition
    customTransitionRoute(RouterNames.userLogin, const UserLoginScreen(),
        PageTransitionType.scale),
    customTransitionRoute(RouterNames.adminLogin, const AdminLoginScreen(),
        PageTransitionType.scale),

    // Main screens with slide transition
    customTransitionRoute(
        RouterNames.userHome, const UserHomeScreen(), PageTransitionType.slide),
    customTransitionRoute(RouterNames.adminHome, const AdminHomeScreen(),
        PageTransitionType.slide),
    customTransitionRoute(RouterNames.complaintScreen,
        const ComplaintFormScreen(), PageTransitionType.slide),
    customTransitionRoute(RouterNames.aiChatScreen, const AiChatScreen(),
        PageTransitionType.slide),

    // Profile and notification screens with rotation transition
    customTransitionRoute(RouterNames.userProfile, const UserProfilePage(),
        PageTransitionType.rotation),
    customTransitionRoute(RouterNames.adminProfile, const AdminProfilePage(),
        PageTransitionType.rotation),
    customTransitionRoute(RouterNames.notificationScreen,
        const NotificationScreen(), PageTransitionType.rotation),

    // Information pages with fade transition
    customTransitionRoute(
        RouterNames.aboutPage, const AboutAppPage(), PageTransitionType.fade),
    customTransitionRoute(
        RouterNames.contactUs, const ContactUsPage(), PageTransitionType.fade),
    customTransitionRoute(
        RouterNames.faqpage, const FAQPage(), PageTransitionType.fade),
    customTransitionRoute(RouterNames.privacyPolicy, const PrivacyPolicyPage(),
        PageTransitionType.fade),
    customTransitionRoute(RouterNames.reportBugPage, const ReportBugPage(),
        PageTransitionType.fade),
    customTransitionRoute(RouterNames.termsOfService,
        const TermsOfServicePage(), PageTransitionType.fade),
  ],
);
