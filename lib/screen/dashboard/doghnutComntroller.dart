import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DoughnutGraphController extends GetxController {
  var categoryData = <String, Map<String, double>>{
    "Water": {"Bad": 2, "Good": 18, "Excellent": 50, "Average": 30, "Value": 50.0},
    "Sleep": {"Bad": 10, "Good": 30, "Excellent": 40, "Average": 20, "Value": 30.0},
    "Walk": {"Bad": 5, "Good": 45, "Excellent": 30, "Average": 20, "Value": 70.0},
    "Study": {"Bad": 15, "Good": 25, "Excellent": 40, "Average": 20, "Value": 40.0},
    "Bills": {"Bad": 20, "Good": 20, "Excellent": 50, "Average": 10, "Value": 20.0},
  }.obs;

  void updateAllCategories(Map<String, Map<String, double>> updatedData) {
    if (kDebugMode) {
      if (kDebugMode) {
        print("Updating all categories...");
      }
    }
    if (kDebugMode) {
      print("Before update: ${categoryData.value}");
    }
    categoryData.value = updatedData;
    if (kDebugMode) {
      print("After update: ${categoryData.value}");
    }
  }

  void updateCategoryData(String category, double value) {
    if (kDebugMode) {
      print("Updating category: $category with value: $value");
    }
    Map<String, double> updatedValues = {
      "Bad": (value <= 20) ? value : 0,
      "Good": (value > 20 && value <= 40) ? value : 0,
      "Average": (value > 40 && value <= 80) ? value : 0,
      "Excellent": (value > 80) ? value : 0,
      "Value": value,
    };

    if (kDebugMode) {
      print("Before update for $category: ${categoryData.value[category]}");
    }
    categoryData[category] = updatedValues;
    if (kDebugMode) {
      print("After update for $category: ${categoryData.value[category]}");
    }
  }

}
