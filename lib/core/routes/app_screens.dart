import 'package:get/get.dart';
import 'package:lescavesduroussillon/screens/contact_screen/view/contact_screen.dart';
import 'package:lescavesduroussillon/screens/winegrowers_list_screen/view/winegrowers_list_screen.dart';

import '../../screens/home_screen/view/home_screen.dart';
import '../../screens/login_screen/view/login_screen.dart';
import '../../screens/admin_winegrowers_screen/view/admin_winegrowers_screen.dart';
import '../../screens/winegrower_screen/view/winegrower_screen_from_param.dart';
import 'app_routes.dart';
import 'auth_guard.dart';

class AppScreens {
  AppScreens._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(name: RoutePaths.home, page: () => const HomeScreen()),
    GetPage(
      name: '${RoutePaths.winegrower}/:winegrowerName',
      page: () => WinegrowerScreenFromParam(),
    ),
    GetPage(
      name: RoutePaths.winegrowersList,
      page: () => const WinegrowersListScreen(),
    ),
    GetPage(name: RoutePaths.contact, page: () => const ContactScreen()),
    GetPage(name: RoutePaths.login, page: () => const LoginScreen()),
    GetPage(
      name: RoutePaths.adminWinegrowers,
      page: () => AdminWinegrowersScreen(),
      middlewares: [AuthGuard()],
    ),
  ];
}
