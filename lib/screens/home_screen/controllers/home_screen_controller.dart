import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

import '../../../core/classes/controller_mixin.dart';
import '../../../core/classes/unique_controllers.dart';
import '../../../core/models/winegrower.dart';

class HomeScreenController extends GetxController
    with WidgetsBindingObserver, ControllerMixin {
  final scrollController = ScrollController();
  double _lastOffset = 0.0;

  RxDouble cardTop = 0.0.obs;
  RxDouble textCardAlpha = 1.0.obs;

  RxDouble pinnedCardWidth = 0.0.obs;
  RxDouble pinnedCardHeight = 0.0.obs;

  RxBool pinned = true.obs;

  double get finalCardWidth =>
      UniquesControllers().data.carouselItemWidth.value;

  double get finalCardHeight =>
      UniquesControllers().data.carouselItemHeight.value;

  RxDouble heightMultiplier = 2.0.obs;
  RxDouble sectionHeight = 0.0.obs;

  RxList<Winegrower> winegrowers = <Winegrower>[].obs;
  RxInt currentIndex = 0.obs;

  final InfiniteScrollController carouselController =
      InfiniteScrollController();
  bool isAnimating = false;
  final animDuration = Duration(milliseconds: 600);

  String originalText =
      """« Honorer les aînés, aider les jeunes, embellir la vie des amateurs, répandre la compréhension et l’amour de la peinture, quelle plus belle profession et comment ne pas essayer d’en être digne !

La direction d’une galerie est surtout « Présence », présence dans le choix, l’exposition, la vente. Présence tout simplement. Du plus grand au plus petit, tous doivent trouver un accueil attentif. Personne n’est à négliger qui de près ou de loin touche à la peinture.

Pour moi, une galerie n’est pas une banque, ni une administration, ni une société aux capitaux anonymes, avec des directeurs inaccessibles, mais bien plutôt une entreprise individuelle et familiale. »""";

  RxBool transformWords = false.obs;

  void toggleTransformWords() {
    transformWords.value = !transformWords.value;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    scrollController.addListener(() {
      _lastOffset = scrollController.offset;
      _applyPinnedLayout(_lastOffset);
    });

    _applyPinnedLayout(_lastOffset);
    _loadWinegrowers();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final savedOffset = _lastOffset;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        final max = scrollController.position.maxScrollExtent;
        scrollController.jumpTo(savedOffset.clamp(0.0, max));
      }

      _applyPinnedLayout(savedOffset);
    });
  }

  void _applyPinnedLayout(double offset) {
    final stillPinned = offset < pinnedStartOffset();
    pinned.value = stillPinned;

    if (stillPinned) {
      final t = (offset / pinnedStartOffset()).clamp(0.0, 1.0);
      final curved = Curves.easeOutCirc.transform(t);
      final rev = Curves.easeOutCirc.transform(t);

      cardTop.value = _lerp(initialCardTop(), pinnedCardTop(), curved);
      pinnedCardWidth.value = _lerp(
        pinnedCardWidthStart(),
        finalCardWidth,
        curved,
      );
      pinnedCardHeight.value = _lerp(
        pinnedCardHeightStart(),
        finalCardHeight,
        curved,
      );
      textCardAlpha.value = 1.0 - rev;
    } else {
      final extra = offset - pinnedStartOffset();
      cardTop.value = pinnedCardTop() - extra;

      pinnedCardWidth.value = finalCardWidth;
      pinnedCardHeight.value = finalCardHeight;
      textCardAlpha.value = 0.0;
    }
  }

  void _loadWinegrowers() {
    FirebaseFirestore.instance.collection('winegrowers').snapshots().listen((
      snapshot,
    ) {
      final docs =
          snapshot.docs.map((doc) => Winegrower.fromDocument(doc)).toList();

      docs.shuffle();

      winegrowers.value = docs;
    });
  }

  double pinnedCardWidthStart() => screenWidth() * 2 / 3;

  double pinnedCardHeightStart() => screenHeight() * 2 / 3;

  double pinnedStartOffset() {
    return screenHeight() / 2;
  }

  double pinnedCardTop() {
    return (screenHeight() / 2) - (finalCardHeight / 2);
  }

  double initialCardTop() {
    return (screenHeight() / 2) - (pinnedCardHeightStart() / 2) - 56 - 16;
  }

  double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  void _onScroll() {
    final offset = scrollController.offset;
    final stillPinned = offset < pinnedStartOffset();
    pinned.value = stillPinned;

    if (stillPinned) {
      final t = (offset / pinnedStartOffset()).clamp(0.0, 1.0);
      final curvedT = Curves.easeOutCirc.transform(t);
      final curvedTReverse = Curves.easeOutCirc.transform(t);

      cardTop.value = _lerp(initialCardTop(), pinnedCardTop(), curvedT);
      pinnedCardWidth.value = _lerp(
        pinnedCardWidthStart(),
        finalCardWidth,
        curvedT,
      );
      pinnedCardHeight.value = _lerp(
        pinnedCardHeightStart(),
        finalCardHeight,
        curvedT,
      );
      textCardAlpha.value = 1.0 - curvedTReverse;
    } else {
      final extra = offset - pinnedStartOffset();
      cardTop.value = pinnedCardTop() - extra;

      pinnedCardWidth.value = finalCardWidth;
      pinnedCardHeight.value = finalCardHeight;
      textCardAlpha.value = 0.0;
    }
  }

  void onCarouselIndexChanged(int idx) {
    currentIndex.value = idx;
  }

  Future<void> nextItem() async {
    if (isAnimating) return;
    isAnimating = true;
    carouselController.nextItem(
      duration: animDuration,
      curve: Curves.decelerate,
    );
    await Future.delayed(animDuration);
    isAnimating = false;
  }

  Future<void> previousItem() async {
    if (isAnimating) return;
    isAnimating = true;
    carouselController.previousItem(
      duration: animDuration,
      curve: Curves.decelerate,
    );
    await Future.delayed(animDuration);
    isAnimating = false;
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  TextSpan buildTextSpan(String text, bool transformWords) {
    final pattern = RegExp(
      r"(de la peinture|d’une galerie|à la peinture|une galerie)",
      caseSensitive: false, // ignore case
      unicode: true,
    );

    final spans = <InlineSpan>[];

    var replacedStyle = TextStyle(
      color: UniquesControllers().data.currentTheme.colorScheme.primary,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    );

    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        final matchStr = match[0]!;
        if (!transformWords) {
          spans.add(TextSpan(text: matchStr));
        } else {
          final lower = matchStr.toLowerCase();
          if (lower == 'de la peinture') {
            spans.add(TextSpan(text: 'du vin', style: replacedStyle));
          } else if (lower == 'd’une galerie') {
            spans.add(
              TextSpan(text: 'des Caves du Roussillon', style: replacedStyle),
            );
          } else if (lower == 'à la peinture') {
            spans.add(TextSpan(text: 'au vin', style: replacedStyle));
          } else if (lower == 'une galerie') {
            spans.add(
              TextSpan(text: 'les Caves du Roussillon', style: replacedStyle),
            );
          } else {
            spans.add(TextSpan(text: matchStr));
          }
        }
        return '';
      },
      onNonMatch: (String nonMatch) {
        if (nonMatch.isNotEmpty) {
          spans.add(TextSpan(text: nonMatch));
        }
        return '';
      },
    );

    return TextSpan(children: spans);
  }
}
