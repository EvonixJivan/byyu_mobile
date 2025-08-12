class Address1 {
  int? addressId;
  String? type;
  int? userId;
  String? receiverName;
  String? receiverPhone;
  String? countryCode;
  String? prefixCode;

  int? cityId;
  int? societyId;
  String? houseNo;

  String? landmark;
  String? cityName;
  String? society;
  String? city;
  String? state;
  String? pincode;
  String? lat;
  String? lng;
  int? selectStatus;
  DateTime? addedAt;
  DateTime? updatedAt;
  double? distancee;
  String? phoneCode;
  String? phoneCode1;
  String? building_villa;
  int? flag;
  String? street;
  String? recepientName;
  String? emirates;
  bool? isSelected = false;
  String? society_lat, society_lng;

  Address1();
  Address1.fromJson(Map<String, dynamic> json) {
    try {
      flag = json["flag"] != null ? int.parse(json["flag"].toString()) : null;
      addressId = json["address_id"] != null
          ? int.parse(json["address_id"].toString())
          : null;
      type = json["type"] != null ? json["type"] : null;
      userId = json["user_id"] != null
          ? int.parse(json["user_id"].toString())
          : null;

      receiverName =
          json["receiver_name"] != null ? json["receiver_name"] : null;
      receiverPhone =
          json["receiver_phone"] != null ? json["receiver_phone"] : null;
      city = json["city"] != null ? json["city"] : null;
      cityName = json["cityname"] != null ? json["cityname"] : null;
      society = json["society"] != null ? json["society"] : null;
      cityId = json["city_id"] != null
          ? int.parse(json["city_id"].toString())
          : null;
      societyId = json["society_id"] != null
          ? int.parse(json["society_id"].toString())
          : 0;

      houseNo = json["house_no"] != null ? json["house_no"] : null;
      landmark = json["landmark"] != null ? json["landmark"] : null;
      state = json["state"] != null ? json["state"] : null;
      pincode = json["pincode"] != null ? json["pincode"] : null;
      lat = json["lat"] != null ? json["lat"] : null;
      lng = json["lng"] != null ? json["lng"] : null;
      selectStatus = json["select_status"] != null
          ? int.parse(json["select_status"].toString())
          : null;
      distancee = json["distancee"] != null
          ? double.parse(json["distancee"].toString())
          : null;
      addedAt =
          json["added_at"] != null ? DateTime.parse(json["added_at"]) : null;
      updatedAt = json["updated_at"] != null
          ? DateTime.parse(json["updated_at"])
          : null;

      street = json["street"] != null ? json["street"] : null;
      recepientName = json["to_name"] != null ? json["to_name"] : null;
      emirates = json["emirates"] != null ? json["emirates"] : null;

      countryCode =
          json["country_code"] != null ? json["country_code"].toString() : null;
      prefixCode =
          json["prefix_code"] != null ? json["prefix_code"].toString() : null;
      building_villa =
          json["building_villa"] != null ? json["building_villa"] : null;
      society_lat = json["society_lat"] != null ? json["society_lat"] : null;
      society_lng = json["society_lng"] != null ? json["society_lng"] : null;
    } catch (e) {
      print(
          "Exception - addressModel.dart - Address.fromJson():" + e.toString());
    }
  }
}
