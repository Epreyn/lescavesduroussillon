import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lescavesduroussillon/features/custom_app_bar/view/custom_app_bar.dart';

import '../../../core/classes/unique_controllers.dart';
import '../../../core/models/winegrower.dart';
import '../../home_screen/widget/custom_infinite_carousel_item.dart';
import '../../home_screen/widget/hover_shrink_card.dart';
import '../controllers/winegrowers_list_screen_controller.dart';

class WinegrowersListScreen extends StatelessWidget {
  const WinegrowersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(WinegrowersListScreenController());

    return Scaffold(
      appBar: CustomAppBar(),
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          final cardWidth = UniquesControllers().data.carouselItemWidth.value + 16;
          int crossAxisCount = (constraints.maxWidth / cardWidth).floor();
          if (crossAxisCount < 2) crossAxisCount = 2;

          return Obx(() {
            final list = c.winegrowers;
            if (list.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return GridView.builder(
              padding: EdgeInsets.all(UniquesControllers().data.baseSpace),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: UniquesControllers().data.baseSpace,
                mainAxisSpacing: UniquesControllers().data.baseSpace,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final w = list[index];
                return _buildCard(w);
              },
            );
          });
        },
      ),
    );
  }

  Widget _buildCard(Winegrower winegrower) {
    return Hero(
      tag: winegrower.id,
      child: SizedBox(
        width: UniquesControllers().data.carouselItemWidth.value,
        height: UniquesControllers().data.carouselItemHeight.value,
        child: Material(
          type: MaterialType.transparency,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: HoverShrinkCard(
              onTap: () {
                final paramName = Uri.encodeComponent(winegrower.name);
                Get.toNamed('/winegrower/$paramName', arguments: winegrower);
              },
              child: CustomInfiniteCarouselItem(winegrower: winegrower, isCenterItem: false),
            ),
          ),
        ),
      ),
    );
  }
}
