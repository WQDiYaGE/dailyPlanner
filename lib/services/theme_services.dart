import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:daily_planner/services/user_detail_service.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }

  static Color getBGClr(int no) {
    switch (no) {
      case 0:
        return const Color(0xFFfd7f6f);
      case 1:
        return const Color(0xFF7eb0d5);
      case 2:
        return const Color(0xFFb2e061);
      case 3:
        return const Color(0xFFbd7ebe);
      case 4:
        return const Color(0xFFffb55a);
      case 5:
        return const Color(0xFFffee65);
      case 6:
        return const Color(0xFFbeb9db);
      case 7:
        return const Color(0xFFfdcce5);
      case 8:
        return const Color(0xFF8bd3c7);
      case 9:
        return const Color(0xFFF5D6B1);
      default:
        return const Color(0xFF6cd4c5);
    }
  }

  static Color getAppPrimaryClr(int no) {
    switch (no) {
      case 0:
        return const Color.fromARGB(255, 120, 64, 217);
      case 1:
        return const Color.fromARGB(255, 215, 102, 22);
      case 2:
        return const Color.fromARGB(255, 25, 156, 173);
      case 3:
        return const Color.fromARGB(255, 191, 8, 208);
      case 4:
        return const Color.fromARGB(255, 85, 124, 16);
      case 5:
        return const Color(0xFF007FFF);
      default:
        return const Color.fromARGB(255, 120, 64, 217);
    }
  }

  static getBoardIcon(String boardName) {
    switch (boardName) {
      case "Work":
        return const Icon(
          Icons.work,
          size: 45,
          color: Color(0xFF454545),
        );
      case "Self care":
        return const Icon(
          Icons.self_improvement,
          size: 45,
          color: Color(0xFF454545),
        );
      case "Fitness":
        return const Icon(
          Icons.fitness_center,
          size: 45,
          color: Color(0xFF454545),
        );
      case "Learn":
        return const Icon(
          Icons.book,
          size: 45,
          color: Color(0xFF454545),
        );
      case "Errand":
        return const Icon(
          Icons.route_outlined,
          size: 45,
          color: Color(0xFF454545),
        );
      default:
        return const Icon(
          Icons.category,
          size: 45,
          color: Color(0xFF454545),
        );
    }
  }

  static getBoardIconForDetail(String boardName) {
    switch (boardName) {
      case "Work":
        return Icon(Icons.work, size: 30, color: ColorConstants.iconColor);
      case "Self care":
        return Icon(Icons.self_improvement,
            size: 30, color: ColorConstants.iconColor);
      case "Fitness":
        return Icon(Icons.fitness_center,
            size: 30, color: ColorConstants.iconColor);
      case "Learn":
        return Icon(Icons.book, size: 30, color: ColorConstants.iconColor);
      case "Errand":
        return Icon(Icons.route_outlined,
            size: 30, color: ColorConstants.iconColor);
      default:
        return Icon(Icons.category, size: 30, color: ColorConstants.iconColor);
    }
  }
}

class ColorConstants {
  static var iconColor = ThemeService.getAppPrimaryClr(
      UserDetailService().selectedPrimaryColorIndex);
  static var buttonColor = ThemeService.getAppPrimaryClr(
      UserDetailService().selectedPrimaryColorIndex);

  static const headingColor = Colors.black87;
  static const headingColorLight = Colors.white;

  static const subHeadingColor = Colors.black;
  static const subHeadingColorLight = Colors.white70;

  static const textColor = Colors.black87;
  static const textColorLight = Colors.black87;
  static const textColorWhite = Colors.white;

  static const alertLightBg = Colors.white;
  static const alertDarkBg = Colors.black87;

  static const progressColor = Color.fromARGB(221, 63, 216, 69);

  static updatePrimaryColorCode(Color color) {
    buttonColor = color;
    iconColor = color;
  }
}
