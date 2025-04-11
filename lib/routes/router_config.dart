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
    fadeTransitionRoute(RouterNames.splash, const SplashScreen()),
    fadeTransitionRoute(RouterNames.initial, const DecideScreen()),
    fadeTransitionRoute(RouterNames.userLogin, const UserLoginScreen()),
    fadeTransitionRoute(RouterNames.adminLogin, const AdminLoginScreen()),
    fadeTransitionRoute(RouterNames.userHome, const UserHomeScreen()),
    fadeTransitionRoute(RouterNames.adminHome, const AdminHomeScreen()),
    fadeTransitionRoute(RouterNames.userProfile, const UserProfilePage()),
    fadeTransitionRoute(
        RouterNames.complaintScreen, const ComplaintFormScreen()),
    fadeTransitionRoute(RouterNames.adminProfile, const AdminProfilePage()),
    fadeTransitionRoute(RouterNames.aboutPage, const AboutAppPage()),
    fadeTransitionRoute(RouterNames.contactUs, const ContactUsPage()),
    fadeTransitionRoute(RouterNames.faqpage, const FAQPage()),
    fadeTransitionRoute(RouterNames.privacyPolicy, const PrivacyPolicyPage()),
    fadeTransitionRoute(RouterNames.reportBugPage, const ReportBugPage()),
    fadeTransitionRoute(RouterNames.termsOfService, const TermsOfServicePage()),
    fadeTransitionRoute(
        RouterNames.notificationScreen, const NotificationScreen()),
  ],
);
