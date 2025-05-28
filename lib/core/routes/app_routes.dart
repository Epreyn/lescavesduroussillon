abstract class Routes {
  Routes._();

  static const home = RoutePaths.home;
  static const winegrower = RoutePaths.winegrower;
  static const winegrowersList = RoutePaths.winegrowersList;
  static const contact = RoutePaths.contact;

  static const login = RoutePaths.login;
  static const adminWinegrowers = RoutePaths.adminWinegrowers;
}

abstract class RoutePaths {
  RoutePaths._();

  static const home = '/accueil';
  static const winegrower = '/vigneron';
  static const winegrowersList = '/vignerons';
  static const contact = '/contact';
  static const login = '/login';
  static const adminWinegrowers = '/admin/vignerons';
}
