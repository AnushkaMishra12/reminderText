import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DoughnutGraphController extends GetxController {
  var categoryData = <String, Map<String, double>>{
    "Water": {"Bad": 2.0, "Good": 18.0, "Excellent": 50.0, "Average": 30.0, "Value": 50.0},
    "Sleep": {"Bad": 10.0, "Good": 30.0, "Excellent": 40.0, "Average": 20.0, "Value": 30.0},
    "Walk": {"Bad": 5.0, "Good": 45.0, "Excellent": 30.0, "Average": 20.0, "Value": 70.0},
    "Study": {"Bad": 15.0, "Good": 25.0, "Excellent": 40.0, "Average": 20.0, "Value": 40.0},
    "Bills": {"Bad": 20.0, "Good": 20.0, "Excellent": 50.0, "Average": 10.0, "Value": 20.0},
  }.obs;

  var selectedCategories = <String>{}.obs;

  void updateAllCategories(Map<String, Map<String, double>> updatedData) {
    if (kDebugMode) {
      print("Updating all categories...");
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
      "Bad": (value <= 20) ? value : 0.0,
      "Good": (value > 20 && value <= 40) ? value : 0.0,
      "Average": (value > 40 && value <= 80) ? value : 0.0,
      "Excellent": (value > 80) ? value : 0.0,
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

  void addSelectedCategory(String category) {
    selectedCategories.add(category);
  }

  void removeSelectedCategory(String category) {
    selectedCategories.remove(category);
  }

  Map<String, Map<String, double>> getFilteredCategoryData() {
    return Map.fromEntries(
        categoryData.entries.where((entry) => selectedCategories.contains(entry.key))
    );
  }
}
