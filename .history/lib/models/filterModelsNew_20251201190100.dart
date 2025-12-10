class FilterModels {
  String? status;
  String? message;
  List<NewFilterModel>? newFilterModel;

  FilterModels({this.status, this.message, this.newFilterModel});

  FilterModels.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    message = json['message'];

    if (json['data'] != null && json['data'] is List) {
      newFilterModel = List<NewFilterModel>.from(
        json['data'].map((v) => NewFilterModel.fromJson(v)),
      );
    } else {
      newFilterModel = [];
    }
  }
}

class NewFilterModel {
  List<String>? flavours;
  List<String>? colors;
  List<String>? plants;
  List<String>? packs;
  List<String>? variants;
  List<String>? sort;
  List<String>? occasion;
  List<String>? types;

  NewFilterModel.fromJson(Map<String, dynamic> json) {
    flavours = _parseList(json["flavours"]);
    colors = _parseList(json["colors"]);
    plants = _parseList(json["plants"]);
    packs = _parseList(json["packs"]);
    variants = _parseList(json["variants"]);
    sort = _parseList(json["sort"]);
    occasion = _parseList(json["occasion"]);
    types = _parseList(json["types"]);
  }

  List<String> _parseList(dynamic data) {
    if (data == null) return [];
    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }
    return [];
  }
}
