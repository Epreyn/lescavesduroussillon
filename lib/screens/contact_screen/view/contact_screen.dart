import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/classes/smooth_scroll_wrapper.dart';
import '../../../core/classes/unique_controllers.dart';
import '../../../features/custom_animation/view/custom_animation.dart';
import '../../../features/custom_app_bar/controllers/custom_app_bar_controller.dart';
import '../../../features/custom_app_bar/view/custom_app_bar.dart';
import '../../../features/custom_space/view/custom_space.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  // wrapper générique d’ouverture de lien
  Future<void> _launch(Uri uri) async {
    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webViewConfiguration: const WebViewConfiguration(
        enableDomStorage: false,
        enableJavaScript: false,
      ),
    );
    if (!ok) Get.snackbar('Erreur', "Impossible d'ouvrir ${uri.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    /* ─ controllers partagés (AppBar / drawer) ─ */
    final appBarCtrl = Get.put(
      CustomAppBarController(),
      tag: 'custom-app-bar-controller',
      permanent: true,
    );

    /* ─ helpers de mise en page ─ */
    final theme = UniquesControllers().data.currentTheme;
    final base = UniquesControllers().data.baseSpace;
    final isMobile = (MediaQuery.of(context).size.width < 600).obs;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    /* ─ scaffold ─ */
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(isMobile: isMobile, scaffoldKey: scaffoldKey),
      drawer: appBarCtrl.buildDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(base * 4),
            child: CustomAnimation(
              fixedTag: 'contact-card',
              yStartPosition: base * 2,
              isOpacity: true,
              duration: UniquesControllers().data.baseDurationWithMultiplier(2),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Card(
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: EdgeInsets.all(base * 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact',
                          style: theme.textTheme.headlineLarge!.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const CustomSpace(heightMultiplier: 2),
                        /* email */
                        _ContactTile(
                          icon: Icons.email_rounded,
                          label: 'contact@lescavesduroussillon.com',
                          onTap:
                              () => _launch(
                                Uri(
                                  scheme: 'mailto',
                                  path: 'contact@lescavesduroussillon.com',
                                ),
                              ),
                        ),
                        const CustomSpace(heightMultiplier: 1.5),
                        /* tél. */
                        _ContactTile(
                          icon: Icons.phone_rounded,
                          label: '+33 4 68 54 40 04',
                          onTap:
                              () => _launch(
                                Uri(scheme: 'tel', path: '+33468544004'),
                              ),
                        ),
                        const CustomSpace(heightMultiplier: 1.5),
                        /* adresse */
                        _ContactTile(
                          icon: Icons.location_on_rounded,
                          label:
                              '1085 Avenue Julien Panchot\n66000 Perpignan – France',
                          onTap:
                              () => _launch(
                                Uri.parse(
                                  'https://www.google.com/maps/place/Les+Caves+du+Roussillon/@42.6880493,2.8732736,16z/data=!3m1!4b1!4m6!3m5!1s0x12b06e121c38b1f7:0x6fd7c79248d7c891!8m2!3d42.6880493!4d2.8758485!16s%2Fg%2F11csp77zr9?entry=ttu&g_ep=EgoyMDI1MDUxMy4xIKXMDSoASAFQAw%3D%3D',
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ──────────────────────────────────────────────────────────
   TUILE DE CONTACT RÉUTILISABLE
─────────────────────────────────────────────────────────── */
class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final base = UniquesControllers().data.baseSpace;
    final theme = UniquesControllers().data.currentTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(base),
      child: Padding(
        padding: EdgeInsets.all(base),
        child: Row(
          children: [
            Icon(icon, size: base * 3, color: theme.colorScheme.secondary),
            SizedBox(width: base * 2),
            Expanded(child: Text(label, style: TextStyle(fontSize: base * 2))),
            Icon(
              Icons.launch_rounded,
              size: base * 2.5,
              color: theme.colorScheme.tertiary,
            ),
          ],
        ),
      ),
    );
  }
}
