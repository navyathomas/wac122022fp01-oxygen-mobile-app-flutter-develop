import 'package:flutter/cupertino.dart';

class MainScreenHandler {
  static MainScreenHandler? _instance;

  static MainScreenHandler get instance {
    _instance ??= MainScreenHandler();
    return _instance!;
  }

  ValueNotifier<int>? selectedIndex;
  DateTime? currentBackPressTime;
  PageController? pageController;
  bool isTappedFromMain = false;

  void initialize({int? index}) {
    selectedIndex = ValueNotifier(index ?? 0);
    pageController = PageController(initialPage: index ?? 0, keepPage: true);
  }

  void updateSelectedIndex(int index) {
    selectedIndex ??= ValueNotifier(0);
    selectedIndex!.value = index;
    jumpToNext(index);
  }

  void disposeSelectedIndex() {
    selectedIndex ??= ValueNotifier(0);
    selectedIndex!.dispose();
  }

  void jumpToNext(int index) {
    if (pageController != null) pageController!.jumpToPage(index);
  }

  void scrollHomeToTop(ScrollController homeController) {
    if (selectedIndex?.value != 0) {
      updateSelectedIndex(0);
    } else {
      if (homeController.position.pixels !=
          homeController.initialScrollOffset) {
        homeController.animateTo(0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn);
      }
    }
  }

  Future<bool> onWillPop(int index, ScrollController homeController) async {
    if (!isTappedFromMain) return true;
    if (index != 0) {
      updateSelectedIndex(0);
      return false;
    } else {
      if (homeController.position.pixels !=
          homeController.initialScrollOffset) {
        homeController.animateTo(0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn);
        return false;
      } else {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          return Future.value(false);
        } else {
          return true;
        }
      }
    }
  }
}
