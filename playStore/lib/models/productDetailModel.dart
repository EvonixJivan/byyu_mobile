import 'dart:io';

import 'package:byyu/models/categoryProductModel.dart';

class ProductDetail {
  Product? productDetail;
  List<Product>? similarProductList = [];
  List<Product>? boughtTogetherProduct = [];
  List<EventsDetail>? eventsDetail = [];
  List<RatingReview>? ratingReview = [];
  List<TimeSlotsDetails>? timeSlots;
  List<OtherDetails>? otherDetails;
  List<DeliveryInformation>? deliveryInformation;

  ProductDetail();
  ProductDetail.fromJson(Map<String, dynamic> json) {
    try {
      productDetail =
          json['detail'] != null ? Product.fromJson(json['detail']) : null;
      similarProductList = json['similar_product'] != null
          ? List<Product>.from(
              json['similar_product'].map((x) => Product.fromJson(x)))
          : [];
      boughtTogetherProduct = json['frequentlyboughttogether_product'] != null
          ? List<Product>.from(json['frequentlyboughttogether_product']
              .map((x) => Product.fromJson(x)))
          : [];
      eventsDetail = json['events_detail'] != null
          ? List<EventsDetail>.from(
              json['events_detail'].map((x) => EventsDetail.fromJson(x)))
          : [];
      ratingReview = json['rating_review'] != null
          ? List<RatingReview>.from(
              json['rating_review'].map((x) => RatingReview.fromJson(x)))
          : [];
      timeSlots = json['time_slots_details'] != null
          ? List<TimeSlotsDetails>.from(json['time_slots_details']
              .map((x) => TimeSlotsDetails.fromJson(x)))
          : [];
      otherDetails = json['other_details'] != null
          ? List<OtherDetails>.from(
              json['other_details'].map((x) => OtherDetails.fromJson(x)))
          : [];
      deliveryInformation = json['delivery_information'] != null
          ? List<DeliveryInformation>.from(json['delivery_information']
              .map((x) => DeliveryInformation.fromJson(x)))
          : [];
    } catch (e) {
      print("Exception - productDetailModel.dart - ProductDetail.fromJson():" +
          e.toString());
    }
  }
}

class EventsDetail {
  int? id;
  String? eventName;
  String? eventDescription;
  String? eventBannerImg;
  String? colorcode;
  List<EventsMessage>? eventsMessage;

  EventsDetail(
      {this.id,
      this.eventName,
      this.eventDescription,
      this.eventBannerImg,
      this.colorcode,
      this.eventsMessage});

  EventsDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventName = json['event_name'];
    eventDescription = json['event_description'];
    eventBannerImg = json['event_banner_img'];
    colorcode = json['colorcode'];
    if (json['events_message'] != null) {
      eventsMessage = <EventsMessage>[];
      json['events_message'].forEach((v) {
        eventsMessage!.add(new EventsMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event_name'] = this.eventName;
    data['event_description'] = this.eventDescription;
    data['event_banner_img'] = this.eventBannerImg;
    data['colorcode'] = this.colorcode;
    if (this.eventsMessage != null) {
      data['events_message'] =
          this.eventsMessage!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class EventsMessage {
  int? id;
  int? eventId;
  String? message;
  String? status;
  String? addedBy;
  String? addedOn;

  EventsMessage(
      {this.id,
      this.eventId,
      this.message,
      this.status,
      this.addedBy,
      this.addedOn});

  EventsMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    message = json['message'];
    status = json['status'];
    addedBy = json['added_by'];
    addedOn = json['added_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event_id'] = this.eventId;
    data['message'] = this.message;
    data['status'] = this.status;
    data['added_by'] = this.addedBy;
    data['added_on'] = this.addedOn;
    return data;
  }
}

class RatingReview {
  String? user_name;
  int? rate_id;
  int? varient_id;
  String? rating;
  String? description;
  int? user_id;
  String? created_at;
  String? updated_at;
  RatingReview(
      {this.user_name,
      this.rate_id,
      this.varient_id,
      this.rating,
      this.description,
      this.user_id,
      this.created_at,
      this.updated_at});
  RatingReview.fromJson(Map<String, dynamic> json) {
    user_name = json['user_name'];
    rate_id = json['rate_id'];
    varient_id = json['varient_id'];
    rating = json['rating'];
    description = json['description'];
    user_id = json['user_id'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.user_name;
    data['rate_id'] = this.rate_id;
    data['varient_id'] = this.varient_id;
    data['rating'] = this.rating;
    data['description'] = this.description;
    data['user_id'] = this.user_id;
    data['created_at'] = this.created_at;
    data['updated_at'] = this.updated_at;
    return data;
  }
}

class OtherDetails {
  String? fieldType;
  String? fieldLimit;
  String? require;
  String? fieldValue;
  String? characterLimt;
  File? setImagePath = null;
  String? setTextValue;

  OtherDetails(
      {this.fieldType,
      this.fieldLimit,
      this.require,
      this.fieldValue,
      this.characterLimt});

  OtherDetails.fromJson(Map<String, dynamic> json) {
    fieldType = json['field_type'];
    fieldLimit = json['field_limit'];
    require = json['require'];
    fieldValue = json['field_value'];
    characterLimt = json['character_limt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['field_type'] = this.fieldType;
    data['field_limit'] = this.fieldLimit;
    data['require'] = this.require;
    data['field_value'] = this.fieldValue;
    data['character_limt'] = this.characterLimt;
    return data;
  }
}

class TimeSlotsDetails {
  int? timeSlotId;
  String? timeSlot;

  TimeSlotsDetails({this.timeSlotId, this.timeSlot});

  TimeSlotsDetails.fromJson(Map<String, dynamic> json) {
    timeSlotId = json['time_slot_id'];
    timeSlot = json['time_slot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time_slot_id'] = this.timeSlotId;
    data['time_slot'] = this.timeSlot;
    return data;
  }
}

class FlavourList {
  int? flavourId;
  String? flavourName;

  FlavourList({this.flavourId, this.flavourName});

  FlavourList.fromJson(Map<String, dynamic> json) {
    flavourId = json['flavour_id'];
    flavourName = json['flavour_name'];
  }
}

class DeliveryInformation {
  String? productRowsName;

  DeliveryInformation({this.productRowsName});

  DeliveryInformation.fromJson(Map<String, dynamic> json) {
    productRowsName = json['product_rows_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_rows_name'] = this.productRowsName;
    return data;
  }
}

class PersonalizedTextList {
  String? name;
  String? value;
  PersonalizedTextList({this.name, this.value});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class PersonalizedImagesList {
  String? name;
  dynamic value;
  PersonalizedImagesList({this.name, this.value});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
