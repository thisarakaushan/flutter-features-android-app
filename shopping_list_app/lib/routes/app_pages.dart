// Packages
import 'package:get/get.dart';

// Pages
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/auth/forgot_password_page.dart';
import '../../presentation/pages/auth/verify_email_page.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';
import '../../presentation/pages/shopping_list/create_list_page.dart';
import '../../presentation/pages/shopping_list/join_list_page.dart';
import '../../presentation/pages/shopping_list/list_detail_page.dart';

// Routes
import 'app_routes.dart';

// Bindings
import '../../bindings/initial_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterPage(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.VERIFY_EMAIL,
      page: () => VerifyEmailPage(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => ForgotPasswordPage(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => DashboardPage(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.CREATE_LIST,
      page: () => CreateListPage(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.JOIN_LIST,
      page: () => JoinListPage(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.LIST_DETAIL,
      page: () => ListDetailPage(),
      binding: InitialBinding(),
    ),
  ];
}
