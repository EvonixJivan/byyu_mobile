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
  FilterItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}
