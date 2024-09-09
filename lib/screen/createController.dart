import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroceryController extends GetxController {
  var items = <String>[].obs;

  var itemController = TextEditingController();

  void addItem(String item) {
    if (item.isNotEmpty) {
      items.insert(0, item);
      itemController.clear();
    }
  }

  void removeItem(String item) {
    items.remove(item);
  }
}
