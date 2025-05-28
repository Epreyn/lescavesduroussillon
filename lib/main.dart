import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/classes/unique_controllers.dart';
import 'core/routes/app_screens.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(UniquesControllers(), permanent: true);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    UniquesControllers().data.initWithContext(context);

    return Obx(
      () => GetMaterialApp(
        title: 'Les Caves du Roussillon',
        theme: UniquesControllers().data.currentTheme,
        initialRoute: AppScreens.initial,
        getPages: AppScreens.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
