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

  String? category;

  String? popupdata;

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
    addedBy = json['added_by'];
    addedOn = json['added_on'];
  }

}

class EventIconName {
  int? eventID;
  String? eventName;
  
  String? eventIconURL;

  EventIconName(this.eventID, this.eventName, this.eventIconURL);

  
}


