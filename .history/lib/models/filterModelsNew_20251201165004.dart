class ProductFilter {
  String? byname;
  int? minPrice;
  int? maxPrice;
  String? stock;
  int? minDiscount;
  int? maxDiscount;
  int? minRating;
  int? maxRating;
  int? maxPriceValue;
  int? subCatID;
  String? keyword;
  String? sort;
  String? sortName;
  String? sortprice;
  String? filterPriceID;
  String? filterPriceValue;
  String? filterDiscountID;
  String? filterDiscountValue;
  String? filterSortID;
  String? filterSortValue;
  String? filterOcassionID;
  String? filterOcassionValue;

  ProductFilter();
}

class SetFiltersData {
  String? filterPriceID;
  String? filterDiscountID;
  String? filterSortID;
  SetFiltersData();
}

class ShowFilters {
  String? status;
  String? message;
  List<FilterPrice>? filterPrice;
  List<FilterDiscount>? filterDiscount;
  List<Sort>? sort;
  List<FilterOcassion>? filterOcassion;
  ShowFilters(
      {this.status,
      this.message,
      this.filterPrice,
      this.filterDiscount,
      this.sort});

  ShowFilters.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['filter_price'] != null) {
      filterPrice = <FilterPrice>[];
      json['filter_price'].forEach((v) {
        filterPrice!.add(new FilterPrice.fromJson(v));
      });
    }
    if (json['filter_discount'] != null) {
      filterDiscount = <FilterDiscount>[];
      json['filter_discount'].forEach((v) {
        filterDiscount!.add(new FilterDiscount.fromJson(v));
      });
    }
    if (json['sort'] != null) {
      sort = <Sort>[];
      json['sort'].forEach((v) {
        sort!.add(new Sort.fromJson(v));
      });
    }
    if (json['ocassion'] != null) {
      filterOcassion = <FilterOcassion>[];
      json['ocassion'].forEach((v) {
        filterOcassion!.add(new FilterOcassion.fromJson(v));
      });
    }
  }
}

class FilterPrice {
  int? id;
  String? type;
  String? name;
  int? isPriceChecked;

  FilterPrice({this.id, this.type, this.name});

  FilterPrice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    return data;
  }
}

class FilterOcassion {
  int? id;
  String? type;
  String? name;
  int? isOcassionChecked;

  FilterOcassion({this.id, this.type, this.name});

  FilterOcassion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    return data;
  }
}

class FilterDiscount {
  int? id;
  String? type;
  String? name;
  int? isDiscountChecked;

  FilterDiscount({this.id, this.type, this.name});

  FilterDiscount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    return data;
  }
}

class Sort {
  int? id;
  String? type;
  String? name;
  int? isSortSelected;

  Sort({this.id, this.type, this.name});

  Sort.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    return data;
  }
}

class AppliedFilterList {
  String? type;
  String? name;
  bool? isFilterValue;
  AppliedFilterList({this.type, this.name, this.isFilterValue});
}
