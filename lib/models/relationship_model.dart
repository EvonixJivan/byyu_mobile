class RelationshipModel {
  String? status;
  String? message;
  List<RelationshipData>? data;

  RelationshipModel({this.status, this.message, this.data});

  RelationshipModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RelationshipData>[];
      json['data'].forEach((v) {
        data!.add(new RelationshipData.fromJson(v));
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

class RelationshipData {
  int? id;
  String? name;
  String? type;
  String? icon;
  String? addedBy;
  int? isDelete;

  RelationshipData({this.id, this.name, this.type, this.icon, this.addedBy, this.isDelete});

  RelationshipData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    icon = json['icon'];
    addedBy = json['added_by'];
    isDelete = json['is_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['icon'] = this.icon;
    data['added_by'] = this.addedBy;
    data['is_delete'] = this.isDelete;
    return data;
  }
}
