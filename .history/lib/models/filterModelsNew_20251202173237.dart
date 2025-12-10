// class FilterItem {
//   int? id;
//   String? name; // for items that use "name"
//   String? typeStr; // for items that use "type" as a string (packs)
//   int? type; // for numeric "type"
//   String? status;
//   String? createdAt;
//   int? isDeleted;

//   FilterItem({
//     this.id,
//     this.name,
//     this.typeStr,
//     this.type,
//     this.status,
//     this.createdAt,
//     this.isDeleted,
//   });

//   factory FilterItem.fromJson(Map<String, dynamic> json) {
//     return FilterItem(
//       id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
//       name: json['name']?.toString(),
//       typeStr: json['type'] is String ? json['type']?.toString() : null,
//       type: json['type'] is int
//           ? json['type'] as int
//           : (json['type'] is String ? int.tryParse(json['type']) : null),
//       status: json['status']?.toString(),
//       createdAt: json['created_at'] ??
//           json['createde_at'] ??
//           json['createdAt']?.toString(),
//       isDeleted: json['is_deleted'] is int ? json['is_deleted'] as int : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name ?? typeStr,
//         'type': type ?? typeStr,
//         'status': status,
//         'created_at': createdAt,
//         'is_deleted': isDeleted,
//       };
// }

// class FilterCategory {
//   String? key; // optional: the map key like "occasion", "colors"
//   String? title;
//   List<FilterItem> items;

//   FilterCategory({this.key, this.title, this.items = const []});

//   factory FilterCategory.fromJson(Map<String, dynamic> json, {String? key}) {
//     return FilterCategory(
//       key: key,
//       title: json['title']?.toString(),
//       items: (json['items'] as List<dynamic>?)
//               ?.map((e) => FilterItem.fromJson(e as Map<String, dynamic>))
//               .toList() ??
//           [],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'title': title,
//         'items': items.map((i) => i.toJson()).toList(),
//       };
// }

// class NewFilterModel {
//   String? status;
//   String? message;
//   List<FilterCategory>? data; // flattened list of categories

//   NewFilterModel({this.status, this.message, this.data});

//   factory NewFilterModel.fromJson(Map<String, dynamic> json) {
//     final rawData = json['data'];
//     final List<FilterCategory> cats = [];

//     if (rawData is Map<String, dynamic>) {
//       // iterate map entries (occasion, delivery, colors, packs, ...)
//       rawData.forEach((key, value) {
//         if (value is Map<String, dynamic>) {
//           cats.add(FilterCategory.fromJson(value, key: key));
//         }
//       });
//     } else if (rawData is List) {
//       // backward-compat: if backend ever returns list
//       for (var v in rawData) {
//         if (v is Map<String, dynamic>) {
//           cats.add(FilterCategory.fromJson(v));
//         }
//       }
//     }

//     return NewFilterModel(
//       status: json['status']?.toString(),
//       message: json['message']?.toString(),
//       data: cats,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'status': status,
//         'message': message,
//         'data': {for (var c in (data ?? [])) c.key ?? c.title!: c.toJson()},
//       };
// }

class NewFilterModel {
  String? status;
  String? message;
  List<FilterCategory>? data;

  NewFilterModel({this.status, this.message, this.data});

  NewFilterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FilterCategory>[];
      json['data'].forEach((v) {
        data!.add(new FilterCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterCategory {
  String? title;
  List<FilterItem>? items;

  FilterCategory({this.title, this.items});

  FilterCategory.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    items = json['items'];
    if (json['items'] != null) {
      items = <FilterItem>[];
      json['items'].forEach((v) {
        items!.add(new FilterItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterItem {
  int? id;
  String? name;
  // int? type;
  // String? status;
  // String? createdAt;

  FilterItem({
    this.id,
    this.name,
    // this.type,
    // this.status,
    // this.createdAt,
  });
  FilterItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // type = json['type'];
    // status = json['status'];
    // createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    // data['type'] = this.type;
    // data['status'] = this.status;
    // data['created_at'] = this.createdAt;
    return data;
  }
}
