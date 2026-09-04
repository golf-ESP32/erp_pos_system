// D:\erp_pos_system\apps\erp_pos_flutter\lib\features\shell\presentation\controllers\navigation_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationState {
  final int currentIndex;
  final bool isSidebarExpanded;
  final String currentRoute;

  NavigationState({
    this.currentIndex = 0,
    this.isSidebarExpanded = true,
    this.currentRoute = '/item-master',
  });

  NavigationState copyWith({
    int? currentIndex,
    bool? isSidebarExpanded,
    String? currentRoute,
  }) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      isSidebarExpanded: isSidebarExpanded ?? this.isSidebarExpanded,
      currentRoute: currentRoute ?? this.currentRoute,
    );
  }
}

class NavigationController extends Notifier<NavigationState> {
  @override
  NavigationState build() {
    return NavigationState();
  }

  void setIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void toggleSidebar() {
    state = state.copyWith(isSidebarExpanded: !state.isSidebarExpanded);
  }

  void setRoute(String route) {
    state = state.copyWith(currentRoute: route);
  }
}

final navigationControllerProvider =
    NotifierProvider<NavigationController, NavigationState>(
        NavigationController.new);