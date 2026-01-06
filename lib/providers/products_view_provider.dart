import 'package:flutter/material.dart';

class ProductsViewProvider extends ChangeNotifier {
  /// Store selection state for each row by id
  Map<int, bool> selectedRows = {};

  /// Toggle selection for a row
  void toggleRow(int id) {
    selectedRows[id] = !(selectedRows[id] ?? false);
    notifyListeners();
  }

  /// Check if a row is selected
  bool isSelected(int id) {
    return selectedRows[id] ?? false;
  }

  /// Select or deselect all rows
  void selectAll(bool value, List<int> ids) {
    for (var id in ids) {
      selectedRows[id] = value;
    }
    notifyListeners();
  }
}
