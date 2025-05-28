import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/classes/unique_controllers.dart';
import '../../../core/models/winegrower.dart';
import '../../../features/custom_animation/view/custom_animation.dart';
import '../../../features/custom_app_bar/controllers/custom_app_bar_controller.dart';
import '../../../features/custom_app_bar/view/custom_app_bar.dart';
import '../../../features/custom_text_button/view/custom_text_button.dart';
import '../../home_screen/widget/custom_infinite_carousel_item.dart';
import '../../home_screen/widget/hover_shrink_card.dart';
import '../controllers/winegrowers_list_screen_controller.dart';

class WinegrowersListScreen extends StatelessWidget {
  const WinegrowersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarCtrl = Get.put(
      CustomAppBarController(),
      tag: 'custom-app-bar-controller',
      permanent: true,
    );
    final c = Get.put(WinegrowersListScreenController());

    final isMobile = (MediaQuery.of(context).size.width < 600).obs;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(isMobile: isMobile, scaffoldKey: scaffoldKey),
        drawer: appBarCtrl.buildDrawer(),
        body: Column(
          children: [
            _tabBar(),
            Expanded(child: TabBarView(children: [_gridView(c), _listView(c)])),
          ],
        ),
      ),
    );
  }

  // ——————————— TAB BAR ———————————

  Widget _tabBar() => Material(
    color: Colors.transparent,
    child: TabBar(
      labelPadding: EdgeInsets.symmetric(
        horizontal: UniquesControllers().data.baseSpace * 4,
      ),
      indicatorColor:
          UniquesControllers().data.currentTheme.colorScheme.primary,
      tabs: const [Tab(text: 'Grille'), Tab(text: 'Liste')],
    ),
  );

  // ——————————— GRID ———————————

  Widget _gridView(WinegrowersListScreenController c) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final cardW = UniquesControllers().data.carouselItemWidth.value + 16;
        int count = (constraints.maxWidth / cardW).floor();
        if (count < 2) count = 2;

        return Obx(
          () => GridView.builder(
            key: const ValueKey('grid'),
            padding: EdgeInsets.all(UniquesControllers().data.baseSpace),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: count,
              crossAxisSpacing: UniquesControllers().data.baseSpace,
              mainAxisSpacing: UniquesControllers().data.baseSpace,
            ),
            itemCount: c.winegrowers.length,
            itemBuilder: (_, i) => _card(c.winegrowers[i], i),
          ),
        );
      },
    );
  }

  Widget _card(Winegrower w, int index) => CustomAnimation(
    fixedTag: w.id,
    isOpacity: true,
    yStartPosition: UniquesControllers().data.baseSpace * 2,
    delay: UniquesControllers().data.baseDelayWithMultiplier(index.toDouble()),
    duration: UniquesControllers().data.baseDurationWithMultiplier(2),
    child: SizedBox(
      width: UniquesControllers().data.carouselItemWidth.value,
      height: UniquesControllers().data.carouselItemHeight.value,
      child: Material(
        type: MaterialType.transparency,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: HoverShrinkCard(
            onTap: () {
              final name = Uri.encodeComponent(w.domainName);
              Get.toNamed('/vigneron/$name', arguments: w);
            },
            child: CustomInfiniteCarouselItem(
              winegrower: w,
              isCenterItem: false,
            ),
          ),
        ),
      ),
    ),
  );

  // ——————————— LIST ———————————

  Widget _listView(WinegrowersListScreenController c) => Obx(() {
    final list = c.winegrowers;
    final base = UniquesControllers().data.baseSpace;
    final theme = UniquesControllers().data.currentTheme;

    final widgets = <Widget>[];
    String? currentLetter;

    for (final w in list) {
      final l = w.domainName.characters.first.toUpperCase();

      if (l != currentLetter) {
        currentLetter = l;

        widgets.add(
          Padding(
            padding: EdgeInsets.fromLTRB(
              base * 2,
              widgets.isEmpty ? 0 : base * 2,
              0,
              0,
            ),
            child: Row(
              children: [
                Text(
                  l,
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: base * 2),
                Flexible(
                  child: FractionallySizedBox(
                    widthFactor: 0.975,
                    child: const Divider(thickness: 1),
                  ),
                ),
              ],
            ),
          ),
        );

        widgets.add(SizedBox(height: base));
      }

      widgets.add(
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: base * 6),
            child: CustomTextButton(
              text: w.domainName,
              onPressed: () {
                final name = Uri.encodeComponent(w.domainName);
                Get.toNamed('/vigneron/$name', arguments: w);
              },
              textStyle: TextStyle(fontSize: base * 2),
            ),
          ),
        ),
      );
    }

    return ListView(
      key: const ValueKey('list'),
      padding: EdgeInsets.all(base * 2),
      children: widgets,
    );
  });
}
