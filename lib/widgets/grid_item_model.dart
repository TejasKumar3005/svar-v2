import '../../../core/app_export.dart';

/// This class is used in the [grid_item_widget] screen.
class GridItemModel {
  GridItemModel({
    this.widget,
    this.id,
  }) {
    widget = widget ?? "ग";
    id = id ?? "";
  }

  String? widget;

  String? id;
}
