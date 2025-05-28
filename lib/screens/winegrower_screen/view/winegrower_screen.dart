import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/classes/smooth_scroll_wrapper.dart';
import '../../../core/models/winegrower.dart';
import '../controllers/winegrower_screen_controller.dart';

class WinegrowerScreen extends StatelessWidget {
  final Winegrower winegrower;
  const WinegrowerScreen({super.key, required this.winegrower});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(WinegrowerScreenController());

    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          /* ----------------------------------------------------------------
             1) PHOTO plein-écran + chips (inchangé)
          ----------------------------------------------------------------- */
          SingleChildScrollView(
            controller: c.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: h,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SizedBox(
                        height: h,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              winegrower.imageURL,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => const Icon(Icons.error),
                            ),
                            Positioned(
                              top: c.base * 2,
                              right: c.base * 2,
                              child: c.chip(
                                winegrower.terroirName,
                                alignLeft: false,
                                delay: Duration(),
                              ),
                            ),
                            Positioned(
                              bottom: c.base * 2,
                              right: c.base * 2,
                              child: c.chip(
                                winegrower.domainName,
                                big: true,
                                alignLeft: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /* ----------------------------------------------------------
                     2) CARTES : Row desktop  |  Column mobile
                  ----------------------------------------------------------- */
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: c.base * 4),
                  child:
                      c.mobile
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              c.historyCard(),
                              SizedBox(height: c.base * 4),
                              c.cuveesCard(),
                            ],
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [c.historyCard(), c.cuveesCard()],
                          ),
                ),

                SizedBox(height: c.base * 8),
              ],
            ),
          ),

          /* ----------------------------------------------------------------
             3) Bouton retour (pinned) – inchangé
          ----------------------------------------------------------------- */
          Positioned(
            top: c.base * 2,
            left: c.base * 2,
            child: Material(
              color: c.theme.colorScheme.primary,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                iconSize: c.base * 4,
                splashRadius: c.base * 3.5,
                color: c.theme.colorScheme.onPrimary,
                onPressed: Get.back,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
