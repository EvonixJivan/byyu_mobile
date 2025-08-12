import 'package:byyu/models/subCategoryModel.dart';

class CategoryList {
  String? title;
  int? catId;
  String? image;
  int? storeId;
  String? description;
  int? delRange;
  int? tx_id;
  int? count;
  double? stfrom;
  bool? isSelected = false;
  bool? isgridView = false;
  int? index;
  List<SubCategory>? subcategory = [];

  CategoryList({this.isSelected, this.isgridView});
  CategoryList.fromJson(Map<String, dynamic> json) {
    try {
      title = json['title'] != null ? json['title'] : '';
      catId =
          json['cat_id'] != null ? int.parse(json['cat_id'].toString()) : null;
      image = json['image'] != null ? json['image'] : '';
      delRange = json['del_range'] != null
          ? int.parse(json['del_range'].toString())
          : null;
      tx_id =
          json['tx_id'] != null ? int.parse(json['tx_id'].toString()) : null;
      count =
          json['count'] != null ? int.parse(json['count'].toString()) : null;
      stfrom = json['stfrom'] != null
          ? double.parse(json['stfrom'].toString())
          : null;
      storeId = json['store_id'] != null
          ? int.parse(json['store_id'].toString())
          : null;
      description = json['description'] != null ? json['description'] : '';
      subcategory = json['subcategory'] != null
          ? List<SubCategory>.from(
              json['subcategory'].map((x) => SubCategory.fromJson(x)))
          : [];
    } catch (e) {
      print("Exception - categoryListModel.dart - CategoryList.fromJson():" +
          e.toString());
    }
  }

  @override
String toString() {
  return '''
CategoryList(
  title: $title,
  catId: $catId,
  image: $image,
  storeId: $storeId,
  description: $description,
  delRange: $delRange,
  tx_id: $tx_id,
  count: $count,
  stfrom: $stfrom,
  isSelected: $isSelected,
  isgridView: $isgridView,
  index: $index,
  subcategory: $subcategory
)
''';
}
}
