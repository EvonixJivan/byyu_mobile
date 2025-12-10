class FilterModels {
  String? status;
  String? message;
  List<NewFilterModel>? newFilterModel;

  FilterModels({this.status, this.message, this.newFilterModel});

  FilterModels.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      newFilterModel = <NewFilterModel>[];
      json['data'].forEach((v) {
        newFilterModel?.add(new NewFilterModel.fromJson(v));
      });
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

  NewFilterModel({
    this.flavours,
    this.colors,
    this.plants,
    this.packs,
    this.variants,
    this.sort,
    this.occasion,
    this.types,
  });

  NewFilterModel.fromJson(Map<String, dynamic> json) {
    try {
      flavours = json["flavours"] != null
          ? List<String>.from(json["flavours"].map((x) => x.toString()))
          : [];

      colors = json["colors"] != null
          ? List<String>.from(json["colors"].map((x) => x.toString()))
          : [];

      plants = json["plants"] != null
          ? List<String>.from(json["plants"].map((x) => x.toString()))
          : [];

      packs = json["packs"] != null
          ? List<String>.from(json["packs"].map((x) => x.toString()))
          : [];

      variants = json["variants"] != null
          ? List<String>.from(json["variants"].map((x) => x.toString()))
          : [];

      sort = json["sort"] != null
          ? List<String>.from(json["sort"].map((x) => x.toString()))
          : [];

      occasion = json["occasion"] != null
          ? List<String>.from(json["occasion"].map((x) => x.toString()))
          : [];

      types = json["types"] != null
          ? List<String>.from(json["types"].map((x) => x.toString()))
          : [];
    } catch (e) {
      print("Exception - NewFilterModel.fromJson(): ${e.toString()}");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "flavours": flavours ?? [],
      "colors": colors ?? [],
      "plants": plants ?? [],
      "packs": packs ?? [],
      "variants": variants ?? [],
      "sort": sort ?? [],
      "occasion": occasion ?? [],
      "types": types ?? [],
    };
  }
}
