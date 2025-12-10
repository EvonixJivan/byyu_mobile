class NewFilterModel {
//   List<String>? flavours;
//   List<String>? colors;
//   List<String>? plants;
//   List<String>? packs;
//   List<String>? variants;
//   List<String>? sort;
//   List<String>? occasion;
//   List<String>? types;

//   NewFilterModel.fromJson(Map<String, dynamic> json) {
//     flavours = _parseList(json["flavours"]);
//     colors = _parseList(json["colors"]);
//     plants = _parseList(json["plants"]);
//     packs = _parseList(json["packs"]);
//     variants = _parseList(json["variants"]);
//     sort = _parseList(json["sort"]);
//     occasion = _parseList(json["occasion"]);
//     types = _parseList(json["types"]);
//   }

//   List<String> _parseList(dynamic data) {
//     if (data == null) return [];
//     if (data is List) {
//       return data.map((e) => e.toString()).toList();
//     }
//     return [];
//   }
  Map<String, FilterCategory> categories = {};

  NewFilterModel.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      categories[key] = FilterCategory.fromJson(value);
    });
  }
}

class FilterCategory {
  String? title;
  List<FilterItem> items;

  FilterCategory({
    this.title,
    this.items = const [],
  });

  factory FilterCategory.fromJson(Map<String, dynamic> json) {
    return FilterCategory(
      title: json["title"],
      items:
          (json["items"] as List).map((e) => FilterItem.fromJson(e)).toList(),
    );
  }
}

class FilterItem {
  int? id;
  String? name;
  int? type;
  String? status;
  String? createdAt;

  FilterItem({
    this.id,
    this.name,
    this.type,
    this.status,
    this.createdAt,
  });

  factory FilterItem.fromJson(Map<String, dynamic> json) {
    return FilterItem(
      id: json["id"],
      name: json["name"] ?? json["type"], // 🔥 Supports both name OR type
      type: json["type"],
      status: json["status"],
      createdAt: json["created_at"] ?? json["createde_at"],
    );
  }
}
