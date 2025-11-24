import 'package:byyu/models/bannerModel.dart';
import 'package:byyu/models/categoryListModel.dart';
import 'package:byyu/models/categoryProductModel.dart';

class HomeScreenData {
  String? status;
  String? message;
  List<Banner>? banner;

  List<CategoryList>? topCat;
  List<Recentselling>? recentselling;
  List<Product>? topselling;
  // List<String>? dealproduct;
  List<String>? whatsnew;
  List<String>? spotlight;
  List<Events>? events;
  List<ReviewRatingsModel>? reviewratings;
  String? category;

  String? popupdata;
  List<Eventsbanner>? eventsbanner;
  List<Eventsoccasion>? eventsoccasion;

  HomeScreenData();

  HomeScreenData.fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'];
      message = json['message'];
      if (json['banner'] != null) {
        banner = <Banner>[];
        json['banner'].forEach((v) {
          banner!.add(new Banner.fromJson(v));
        });
      }

      if (json['review_ratings'] != null) {
        reviewratings = <ReviewRatingsModel>[];
        json['review_ratings'].forEach((v) {
          reviewratings!.add(new ReviewRatingsModel.fromJson(v));
        });
      }
      if (json['top_cat'] != null) {
        topCat = <CategoryList>[];
        json['top_cat'].forEach((v) {
          topCat!.add(new CategoryList.fromJson(v));
        });
      }
      if (json['events'] != null) {
        events = <Events>[];
        json['events'].forEach((v) {
          events!.add(new Events.fromJson(v));
        });
      }
      if (json['recentselling'] != null) {
        recentselling = <Recentselling>[];
        json['recentselling'].forEach((v) {
          recentselling!.add(new Recentselling.fromJson(v));
        });
      }
      if (json['topselling'] != null) {
        topselling = <Product>[];
        json['topselling'].forEach((v) {
          topselling!.add(new Product.fromJson(v));
        });
      }
      if (json['eventsbanner'] != null) {
        eventsbanner = <Eventsbanner>[];
        json['eventsbanner'].forEach((v) {
          eventsbanner!.add(new Eventsbanner.fromJson(v));
        });
      }
      if (json['eventsoccasion'] != null) {
        eventsoccasion = <Eventsoccasion>[];
        json['eventsoccasion'].forEach((v) {
          eventsoccasion!.add(new Eventsoccasion.fromJson(v));
        });
      }

      // category = json['category'];

      // popupdata = json['popupdata'];
    } catch (e) {
      print(
          "Exception - homeScreenDataModel.dart - HomeScreenData.fromJson():" +
              e.toString());
    }
  }
}

class Recentselling {
  String? catName;
  int? catId;
  List<Product>? productList;

  Recentselling({this.catName, this.productList});

  Recentselling.fromJson(Map<String, dynamic> json) {
    catName = json['cat_name'];
    catId = json['cat_id'];
    if (json['product_list'] != null) {
      productList = <Product>[];
      json['product_list'].forEach((v) {
        productList!.add(new Product.fromJson(v));
      });
    }
  }
}

class Events {
  int? id;
  String? eventName;
  String? eventDescription;
  String? eventImage;
  String? eventBannerImage;
  Null addedBy;
  Null addedOn;

  Events(
      {this.id,
      this.eventName,
      this.eventDescription,
      this.eventImage,
      this.addedBy,
      this.addedOn});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventName = json['event_name'];
    eventDescription = json['event_description'];
    eventImage = json['event_image'];
    eventBannerImage = json['event_banner_img'];
    // addedBy = json['added_by'];
    // addedOn = json['added_on'];
  }
}

class EventIconName {
  int? eventID;
  String? eventName;

  String? eventIconURL;

  EventIconName(this.eventID, this.eventName, this.eventIconURL);
}

class ReviewRatingsModel {
  int? id;
  String? ratingcount;

  String? username;
  String? message;

  ReviewRatingsModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      ratingcount = json['rating_count'];
      username = json['user_name'];
      message = json['message'];
    } catch (e) {
      print("Exception - reviewRatings.dart - Product.fromJson():" +
          e.toString());
    }
  }

  ReviewRatingsModel({this.id, this.ratingcount, this.username, this.message});
}

class Eventsbanner {
  int? id;
  String? eventName;
  String? eventDescription;
  String? eventImage;
  String? eventBannerImg;
  String? colorcode;
  String? status;
  int? sequence;
  String? addedBy;
  String? addedOn;
  int? isDelete;
  String? platform;
  String? metaTitle;
  String? metaDescription;
  String? startDate;
  String? endDate;

  Eventsbanner(
      {this.id,
      this.eventName,
      this.eventDescription,
      this.eventImage,
      this.eventBannerImg,
      this.colorcode,
      this.status,
      this.sequence,
      this.addedBy,
      this.addedOn,
      this.isDelete,
      this.platform,
      this.metaTitle,
      this.metaDescription,
      this.startDate,
      this.endDate});

  Eventsbanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventName = json['event_name'];
    eventDescription = json['event_description'];
    eventImage = json['event_image'];
    eventBannerImg = json['event_banner_img'];
    colorcode = json['colorcode'];
    status = json['status'];
    sequence = json['sequence'];
    addedBy = json['added_by'];
    addedOn = json['added_on'];
    isDelete = json['is_delete'];
    platform = json['platform'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event_name'] = this.eventName;
    data['event_description'] = this.eventDescription;
    data['event_image'] = this.eventImage;
    data['event_banner_img'] = this.eventBannerImg;
    data['colorcode'] = this.colorcode;
    data['status'] = this.status;
    data['sequence'] = this.sequence;
    data['added_by'] = this.addedBy;
    data['added_on'] = this.addedOn;
    data['is_delete'] = this.isDelete;
    data['platform'] = this.platform;
    data['meta_title'] = this.metaTitle;
    data['meta_description'] = this.metaDescription;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}

class Eventsoccasion {
  int? id;
  String? eventName;
  String? eventDescription;
  String? eventImage;
  String? eventBannerImg;
  String? colorcode;
  String? status;
  int? sequence;
  String? addedBy;
  String? addedOn;
  int? isDelete;
  String? platform;
  String? metaTitle;
  String? metaDescription;
  String? startDate;
  String? endDate;

  Eventsoccasion(
      {this.id,
      this.eventName,
      this.eventDescription,
      this.eventImage,
      this.eventBannerImg,
      this.colorcode,
      this.status,
      this.sequence,
      this.addedBy,
      this.addedOn,
      this.isDelete,
      this.platform,
      this.metaTitle,
      this.metaDescription,
      this.startDate,
      this.endDate});

  Eventsoccasion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventName = json['event_name'];
    eventDescription = json['event_description'];
    eventImage = json['event_image'];
    eventBannerImg = json['event_banner_img'];
    colorcode = json['colorcode'];
    status = json['status'];
    sequence = json['sequence'];
    addedBy = json['added_by'];
    addedOn = json['added_on'];
    isDelete = json['is_delete'];
    platform = json['platform'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event_name'] = this.eventName;
    data['event_description'] = this.eventDescription;
    data['event_image'] = this.eventImage;
    data['event_banner_img'] = this.eventBannerImg;
    data['colorcode'] = this.colorcode;
    data['status'] = this.status;
    data['sequence'] = this.sequence;
    data['added_by'] = this.addedBy;
    data['added_on'] = this.addedOn;
    data['is_delete'] = this.isDelete;
    data['platform'] = this.platform;
    data['meta_title'] = this.metaTitle;
    data['meta_description'] = this.metaDescription;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}
