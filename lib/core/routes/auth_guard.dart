import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final logged = FirebaseAuth.instance.currentUser != null;
    return logged ? null : const RouteSettings(name: RoutePaths.login);
  }
}
