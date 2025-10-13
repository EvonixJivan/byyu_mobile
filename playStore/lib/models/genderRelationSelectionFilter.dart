class SelectionFilterModel {
  String? status;
  String? message;
  SelectionData? selectionData;

  SelectionFilterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    selectionData =
        json['data'] != null ? new SelectionData.fromJson(json['data']) : null;
  }
}

class SelectionData {
  List<SearchAge>? searchAge;
  List<SearchGender>? searchGender;
  List<SearchOccasion>? searchOccasion;
  List<SearchRelationship>? searchRelationship;

  SelectionData(
      {this.searchAge,
      this.searchGender,
      this.searchOccasion,
      this.searchRelationship});

  SelectionData.fromJson(Map<String, dynamic> json) {
    if (json['search_age'] != null) {
      searchAge = <SearchAge>[];
      json['search_age'].forEach((v) {
        searchAge!.add(new SearchAge.fromJson(v));
      });
    }
    if (json['search_gender'] != null) {
      searchGender = <SearchGender>[];
      json['search_gender'].forEach((v) {
        searchGender!.add(new SearchGender.fromJson(v));
      });
    }
    if (json['search_occasion'] != null) {
      searchOccasion = <SearchOccasion>[];
      json['search_occasion'].forEach((v) {
        searchOccasion!.add(new SearchOccasion.fromJson(v));
      });
    }
    if (json['search_relationship'] != null) {
      searchRelationship = <SearchRelationship>[];
      json['search_relationship'].forEach((v) {
        searchRelationship!.add(new SearchRelationship.fromJson(v));
      });
    }
  }
}

class SearchAge {
  int? id;
  String? name;
  String? icon;
  String? addedOn;
  String? addedBy;
  int? isDelete;
  bool? selectedAge = false;

  SearchAge(
      {this.id,
      this.name,
      this.icon,
      this.addedOn,
      this.addedBy,
      this.isDelete});

  SearchAge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    addedOn = json['added_on'];
    addedBy = json['added_by'];
    isDelete = json['is_delete'];
  }
}

class SearchGender {
  int? id;
  String? name;
  String? icon;
  String? addedOn;
  String? addedBy;
  int? isDelete;
  bool? selectedGender = false;

  SearchGender(
      {this.id,
      this.name,
      this.icon,
      this.addedOn,
      this.addedBy,
      this.isDelete});

  SearchGender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    addedOn = json['added_on'];
    addedBy = json['added_by'];
    isDelete = json['is_delete'];
  }
}

class SearchRelationship {
  int? id;
  String? name;
  String? type;
  String? icon;
  String? addedBy;
  int? isDelete;
  bool? selectedRelation = false;

  SearchRelationship(
      {this.id, this.name, this.type, this.icon, this.addedBy, this.isDelete});

  SearchRelationship.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    icon = json['icon'];
    addedBy = json['added_by'];
    isDelete = json['is_delete'];
  }
}

class SearchOccasion {
  int? id;
  String? name;
  String? icon;
  String? addedOn;
  String? addedBy;
  int? isDelete;
  bool? selectedOcassion = false;

  SearchOccasion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    addedOn = json['added_on'];
    addedBy = json['added_by'];
    isDelete = json['is_delete'];
  }
}
