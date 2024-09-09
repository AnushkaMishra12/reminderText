import 'package:get/get_navigation/src/routes/get_route.dart';
import '../screen/dashboard/view/dashboard_screen.dart';
import 'app_route.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.dash,
      page: () => const DashboardScreen(),
      // binding: DashBoardBinding(),
    ),
  ];
}
