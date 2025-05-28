// controllers/login_screen_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/routes/app_routes.dart';

class LoginScreenController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _box = GetStorage();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rememberMe = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.text = _box.read('savedMail') ?? ''; // pré-remplit
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      Get.snackbar('Erreur', 'Renseignez email et mot de passe.');
      return;
    }
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: pass);

      rememberMe
              .value // sauve ou efface l’email
          ? _box.write('savedMail', email)
          : _box.remove('savedMail');

      Get.offAllNamed(RoutePaths.adminWinegrowers);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Échec', e.message ?? 'Connexion impossible');
    } finally {
      isLoading.value = false;
    }
  }
}
