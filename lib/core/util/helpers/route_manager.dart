import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

Route<dynamic>? onGenerateRoute(RouteSettings settings) => null;

class RouteManager {
  static BuildContext get currentContext => navigatorKey.currentContext!;

  static Future<dynamic> navigateTo(Widget page) =>
      navigatorKey.currentState!.push(_customPageRoute(page));

  static Future<dynamic> navigateAndPopAll(Widget page) =>
      navigatorKey.currentState!.pushAndRemoveUntil(
        _customPageRoute(page),
            (_) => false,
      );

  static Future<dynamic> pushReplacement(Widget page) =>
      navigatorKey.currentState!.pushReplacement(_customPageRoute(page));

  static Future<dynamic> navigateAndPopUntilFirstPage(Widget page) =>
      navigatorKey.currentState!.pushAndRemoveUntil(
        _customPageRoute(page),
            (route) => route.isFirst,
      );

  static void backToFirstPage() =>
      navigatorKey.currentState!.popUntil((route) => route.isFirst);

  static void pop([Object? result]) =>
      navigatorKey.currentState!.pop(result);

  static void maybePop([Object? result]) =>
      navigatorKey.currentState!.maybePop(result);

  /// 🔹 Custom transition (slide from right with fade)
  static Route<dynamic> _customPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, animation, secondaryAnimation) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // from right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}

