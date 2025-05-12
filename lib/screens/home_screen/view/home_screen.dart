import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/classes/custom_data.dart';
import '../../../core/classes/smooth_scroll_wrapper.dart';
import '../../../core/classes/unique_controllers.dart';
import '../../../core/routes/app_routes.dart';
import '../../../features/custom_animated_text/view/custom_animated_text.dart';
import '../../../features/custom_animation/view/custom_animation.dart';
import '../../../features/custom_app_bar/controllers/custom_app_bar_controller.dart';
import '../../../features/custom_app_bar/view/custom_app_bar.dart';
import '../../../features/custom_space/view/custom_space.dart';
import '../controllers/home_screen_controller.dart';
import '../widget/custom_infinite_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialisation des contrôleurs
    Get.put(
      CustomAppBarController(),
      tag: 'custom-app-bar-controller',
      permanent: true,
    );
    HomeScreenController cc = Get.put(HomeScreenController(), permanent: true);

    final screenHeight = MediaQuery.of(context).size.height;
    cc.sectionHeight.value = screenHeight * cc.heightMultiplier.value;
    final isMobileScreen = (MediaQuery.of(context).size.width < 600).obs;

    // Clé globale pour le Scaffold
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(isMobile: isMobileScreen, scaffoldKey: scaffoldKey),
      drawer: _buildDrawer(),
      body: _buildBody(cc),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Vignerons'),
            onTap: () => Get.offNamed(Routes.winegrowersList),
          ),
          ListTile(title: Text('Home'), onTap: () => Get.offNamed(Routes.home)),
        ],
      ),
    );
  }

  Widget _buildBody(HomeScreenController cc) {
    return Stack(
      children: [
        SmoothScrollWrapper(
          controller: cc.scrollController,
          child: SingleChildScrollView(
            controller: cc.scrollController,
            //physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height:
                      cc.sectionHeight.value / 2 -
                      UniquesControllers().data.carouselItemHeight / 2,
                ),
                SizedBox(
                  height: UniquesControllers().data.carouselItemHeight.value,
                  child: CustomInfiniteCarousel(homeScreenController: cc),
                ),
                _buildAnimatedTextSection(cc),
              ],
            ),
          ),
        ),
        _buildPinnedCard(cc),
      ],
    );
  }

  Widget _buildAnimatedTextSection(HomeScreenController cc) {
    return Obx(() {
      final idx = cc.currentIndex.value;
      final list = cc.winegrowers;
      final name = (idx < list.length) ? list[idx].name : '';

      return SizedBox(
        height: cc.sectionHeight.value / 6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomSpace(heightMultiplier: 6),
            !cc.pinned.value
                ? CustomAnimation(
                  duration: cc.animDuration,
                  isOpacity: true,
                  yStartPosition: UniquesControllers().data.baseSpace * 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left_rounded,
                          size: UniquesControllers().data.baseSpace * 5,
                        ),
                        onPressed: () => cc.previousItem(),
                      ),
                      SizedBox(
                        width:
                            UniquesControllers().data.carouselItemWidth.value,
                        child: Center(
                          child: CustomAnimatedText(
                            key: UniqueKey(),
                            text: name,
                            direction: Direction.left,
                            baseDelay:
                                (UniquesControllers().data.baseSpace * 3)
                                    .toInt(),
                            duration:
                                (UniquesControllers().data.baseSpace * 75)
                                    .toInt(),
                            style: TextStyle(
                              fontSize: UniquesControllers().data.baseSpace * 3,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          size: UniquesControllers().data.baseSpace * 5,
                        ),
                        onPressed: () => cc.nextItem(),
                      ),
                    ],
                  ),
                )
                : const SizedBox.shrink(),
          ],
        ),
      );
    });
  }

  Widget _buildPinnedCard(HomeScreenController cc) {
    return Obx(() {
      final pinnedVal = cc.pinned.value;
      if (!pinnedVal) return const SizedBox.shrink();

      final idx = cc.currentIndex.value;
      final list = cc.winegrowers;
      if (idx >= list.length || list.isEmpty) {
        return const SizedBox.shrink();
      }

      final winegrower = list[idx];

      return Positioned(
        top: cc.cardTop.value,
        left: 0,
        right: 0,
        child: Center(
          child: SizedBox(
            width: cc.pinnedCardWidth.value,
            height: cc.pinnedCardHeight.value,
            child: Stack(
              children: [
                IgnorePointer(
                  ignoring: true,
                  child: Stack(
                    children: [
                      Card(
                        clipBehavior: Clip.antiAlias,
                        child: AnimatedScale(
                          scale: 1.05,
                          duration: const Duration(milliseconds: 400),
                          child: Image.network(
                            winegrower.imageURL,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder:
                                (ctx, _, __) => const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Obx(
                        () => Opacity(
                          opacity: cc.textCardAlpha.value,
                          child: Card(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            cc.pinnedCardWidth.value /
                                            UniquesControllers()
                                                .data
                                                .baseSpace /
                                            2,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Obx(
                                          () => AutoSizeText(
                                            'Distributeur de vins d’artistes-vignerons du Roussillon',
                                            textAlign: TextAlign.left,
                                            minFontSize: 1,
                                            style:
                                                UniquesControllers()
                                                    .data
                                                    .currentTheme
                                                    .textTheme
                                                    .headlineMedium,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Obx(() {
                                            final transform =
                                                cc.transformWords.value;

                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    cc.pinnedCardWidth.value /
                                                    UniquesControllers()
                                                        .data
                                                        .baseSpace /
                                                    2,
                                              ),
                                              child: AutoSizeText.rich(
                                                cc.buildTextSpan(
                                                  cc.originalText,
                                                  transform,
                                                ),
                                                minFontSize: 1,
                                                style: TextStyle(
                                                  fontSize:
                                                      UniquesControllers()
                                                          .data
                                                          .baseSpace *
                                                      3,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    cc.pinnedCardWidth.value /
                                                    UniquesControllers()
                                                        .data
                                                        .baseSpace /
                                                    2,
                                              ),
                                              child: AutoSizeText(
                                                'Katia Granoff Histoire d’une Galerie\nChez l’Auteur, 13 quai de Conti, Paris VI, 1949',
                                                textAlign: TextAlign.start,
                                                minFontSize: 1,
                                                style: TextStyle(
                                                  fontSize:
                                                      UniquesControllers()
                                                          .data
                                                          .baseSpace *
                                                      2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Positioned(
                    top: UniquesControllers().data.baseSpace * 2,
                    right: UniquesControllers().data.baseSpace * 2,
                    child: Opacity(
                      opacity: cc.textCardAlpha.value,
                      child: Switch(
                        value: cc.transformWords.value,
                        onChanged: (value) {
                          cc.transformWords.value = value;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
