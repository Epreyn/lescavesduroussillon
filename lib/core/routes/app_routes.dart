abstract class Routes {
  Routes._();

  static const home = RoutePaths.home;
  static const winegrower = RoutePaths.winegrower;
  static const winegrowersList = RoutePaths.winegrowersList;
}

abstract class RoutePaths {
  RoutePaths._();

  static const home = '/home';
  static const winegrower = '/winegrower';
  static const winegrowersList = '/winegrowers-list';
}
