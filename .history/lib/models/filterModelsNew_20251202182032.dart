class FilterItem {
  int? id;
  String? name;
  String? type;

  FilterItem({this.id, this.name, this.type});

  factory FilterItem.fromJson(Map<String, dynamic> json) {
    return FilterItem(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      name: json['name']?.toString(),
      type: json['type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'type': type};
}

class FilterCategory {
  String? key; // e.g. "occasion" or "colors"
  String? title; // "Occasion", "Color Palette"
  List<FilterItem>? items;

  FilterCategory({this.key, this.title, this.items});

  factory FilterCategory.fromJson(Map<String, dynamic> json, {String? key}) {
    return FilterCategory(
      key: key,
      title: json['title']?.toString(),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => FilterItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'items': items?.map((i) => i.toJson()).toList(),
      };
}

class NewFilterModel {
  String? status;
  String? message;
  List<FilterCategory>? data; // flattened list of categories

  NewFilterModel({this.status, this.message, this.data});

  factory NewFilterModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final List<FilterCategory> cats = [];

    if (raw is Map) {
      // iterate over map entries like "occasion": { title: ..., items: [...] }
      raw.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          cats.add(FilterCategory.fromJson(value, key: key.toString()));
        }
      });
    } else if (raw is List) {
      // fallback: if backend returns list in some cases
      for (final v in raw) {
        if (v is Map<String, dynamic>) {
          cats.add(FilterCategory.fromJson(v));
        }
      }
    }

    return NewFilterModel(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      data: cats,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': {for (var c in (data ?? [])) c.key ?? c.title!: c.toJson()},
      };
}

// class NewFilterModel {
//   String? status;
//   String? message;
//   List<FilterCategory>? data;

//   NewFilterModel({this.status, this.message, this.data});

//   NewFilterModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <FilterCategory>[];
//       json['data'].forEach((v) {
//         data!.add(new FilterCategory.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class FilterCategory {
//   String? title;
//   List<FilterItem>? items;

//   FilterCategory({this.title, this.items});

//   FilterCategory.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     items = json['items'];
//     if (json['items'] != null) {
//       items = <FilterItem>[];
//       json['items'].forEach((v) {
//         items!.add(new FilterItem.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title'] = this.title;
//     if (this.items != null) {
//       data['items'] = this.items!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class FilterItem {
//   int? id;
//   String? name;
//   // int? type;
//   // String? status;
//   // String? createdAt;

//   FilterItem({
//     this.id,
//     this.name,
//     // this.type,
//     // this.status,
//     // this.createdAt,
//   });
//   FilterItem.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     // type = json['type'];
//     // status = json['status'];
//     // createdAt = json['created_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     // data['type'] = this.type;
//     // data['status'] = this.status;
//     // data['created_at'] = this.createdAt;
//     return data;
//   }
// }
