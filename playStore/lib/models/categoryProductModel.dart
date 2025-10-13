import 'package:byyu/models/imageModel.dart';
import 'package:byyu/models/tagsModel.dart';
import 'package:byyu/models/varientModel.dart';

class Product {
  int? pId;
  int? varientId;
  int? stock;
  int? storeId;
  int? storeOrderId;
  double? mrp;
  double? price;
  int? minOrdQty;
  int? maxOrdQty;
  int? productId;
  int? quantity;
  String? unit;
  double? baseMrp;
  double? basePrice;
  String? description;
  String? varientImage;
  String? ean;
  int? approved;
  int? addedBy;
  int? catId;
  String? productName;
  String? productImage;
  String? type;

  String? repeated_order_cart;
  int? hide;
  int? count;
  List<ImageModel>? images = [];
  List<ImageModel>? Mainimages = [];
  List<TagsModel>? tags = [];
  List<Varient>? varient = [];
  int? qty;
  double? totalMrp;
  String? orderCartId;
  String? orderDate;
  String? delivery;
  int? storeApproval;
  double? txPer;
  double? priceWithoutTax;
  double? txPrice;
  String? txName;
  String? isFavourite;
  int? cartQty;
  int? countrating;
  int? rating;
  int? ratingCount;
  int? userRating;
  bool? isSelected = false;
  dynamic? discount;
  double? maxprice;
  String? ratingDescription;
  String? thumbnail;
  int? isSubscription;
  String? repeatDays;
  String? repeat_orders;
  bool? isCardVisible = true;
  bool? sun = false,
      mon = false,
      tues = false,
      wed = false,
      thu = false,
      fri = false,
      sat = false;
  String? next_delivery_date;
  String? order_status_delivery;
  String? cart_personalized_message;
  String? cart_delivery_time;
  String? cart_delivery_date;

  List<String>? eggEggless;
  int? vegOrNonveg = 0;
  List<Flavour>? flavour;
  String? productStartDate;
  String? productEndDate;
  String? labelFlavourColor;

  // Product();
  Product(String productName,String productImage, double price, double mrp, int discountper,int stock){
      this.productName=productName;
      this.productImage=productImage;
      this.price=price;
      this.mrp=mrp;
      this.discount=discountper;
      this.stock=stock;

  }
  Product.fromJson(Map<String, dynamic> json) {
    try {
      pId = json['p_id'] != null ? int.parse(json['p_id'].toString()) : null;

      varientId = json['varient_id'] != null
          ? int.parse(json['varient_id'].toString())
          : null;

      stock = json['stock'] != null ? int.parse(json['stock'].toString()) : 0;

      storeId = json['store_id'] != null
          ? int.parse(json['store_id'].toString())
          : null;

      storeOrderId = json['store_order_id'] != null
          ? int.parse(json['store_order_id'].toString())
          : null;

      mrp =
          json['mrp'] != null ? double.parse('${json['mrp'].toString()}') : 0.0;

      price = json['price'] != null
          ? double.parse('${json['price'].toString()}')
          : null;

      minOrdQty = json['min_ord_qty'] != null
          ? int.parse(json['min_ord_qty'].toString())
          : null;

      maxOrdQty = json['max_ord_qty'] != null
          ? int.parse(json['max_ord_qty'].toString())
          : null;

      productId = json['product_id'] != null
          ? int.parse(json['product_id'].toString())
          : null;

      quantity = json['quantity'] != null
          ? int.parse(json['quantity'].toString())
          : null;

      unit = json['unit'] != null ? json['unit'] : '';

      baseMrp = json['base_mrp'] != null
          ? double.parse(json['base_mrp'].toString())
          : 0.0;

      basePrice = json['base_price'] != null
          ? double.parse(json['base_price'].toString())
          : 0.0;

      repeated_order_cart = json['repeated_order_cart'] != null
          ? json['repeated_order_cart']
          : '';

      description = json['description'] != null ? json['description'] : '';

      varientImage = json['varient_image'] != null ? json['varient_image'] : '';

      ean = json['ean'] != null ? json['ean'] : '';

      approved = json['approved'] != null
          ? int.parse(json['approved'].toString())
          : null;

      addedBy = json['added_by'] != null
          ? int.parse(json['added_by'].toString())
          : null;

      catId =
          json['cat_id'] != null ? int.parse(json['cat_id'].toString()) : null;

      productName = json['product_name'] != null ? json['product_name'] : '';

      productImage = json['product_image'] != null ? json['product_image'] : '';

      type = json['type'] != null ? json['type'] : '';

      hide = json['hide'] != null ? int.parse(json['hide'].toString()) : null;

      count =
          json['count'] != null ? int.parse(json['count'].toString()) : null;

      qty = json['qty'] != null ? int.parse(json['qty'].toString()) : null;

      totalMrp = json['total_mrp'] != null
          ? double.parse(json['total_mrp'].toString())
          : null;

      orderCartId =
          json['order_cart_id'] != null ? json['order_cart_id'] : null;

      orderDate = json['order_date'] != null ? json['order_date'] : '';

      delivery = json['delivery'] != null
          ? json['delivery'] == "Today"
              ? "1"
              : json['delivery'] == "Tomorrow"
                  ? "2"
                  : json['delivery']
          : '';

      storeApproval = json['store_approval'] != null
          ? int.parse(json['store_approval'].toString())
          : null;

      txPer = json['tx_per'] != null
          ? double.parse(json['tx_per'].toString())
          : null;

      priceWithoutTax = json['price_without_tax'] != null
          ? double.parse(json['price_without_tax'].toString())
          : 0.0;

      txPrice = json['tx_price'] != null
          ? double.parse(json['tx_price'].toString())
          : null;

      txName = json['tx_name'] != null ? json['tx_name'] : null;
      isFavourite =
          json['isFavourite'] != null ? json['isFavourite'].toString() : "";
      cart_personalized_message = json['cart_personalized_message'] != null
          ? json['cart_personalized_message'].toString()
          : "";
      cart_delivery_time = json['cart_delivery_time'] != null
          ? json['cart_delivery_time'].toString()
          : "";
      cart_delivery_date = json['cart_delivery_date'] != null
          ? json['cart_delivery_date'].toString()
          : "";

      cartQty =
          json['cart_qty'] != null ? int.parse(json['cart_qty'].toString()) : 0;

      countrating = json['countrating'] != null
          ? int.parse(json['countrating'].toString())
          : null;

      rating = json['avgrating'] != null
          ? double.parse(json['avgrating'].toString()).round()
          : 0;

      userRating = json['rating'] != null
          ? double.parse(json['rating'].toString()).round()
          : 0;

      ratingCount = json['countrating'] != null
          ? int.parse(json['countrating'].toString())
          : 0;

      ratingDescription =
          json['rating_description'] != null ? json['rating_description'] : '';

      discount = json['discountper'] != null
          ? double.parse(json['discountper'].toString()).round()
          : 0;
      // discount=null;    

      maxprice =
          json['maxprice'] != null ? double.parse('${json['maxprice']}') : null;
      images = json['images'] != null
          ? List<ImageModel>.from(
              json['images'].map((x) => ImageModel.fromJson(x)))
          : [];
      Mainimages = json['main_image'] != null
          ? List<ImageModel>.from(
              json['images'].map((x) => ImageModel.fromJson(x)))
          : [];
      tags = json['tags'] != null
          ? List<TagsModel>.from(json['tags'].map((x) => TagsModel.fromJson(x)))
          : [];
      varient = json['varients'] != null
          ? List<Varient>.from(json['varients'].map((x) => Varient.fromJson(x)))
          : [];
      repeatDays = json['repeat_orders'] != null ? json['repeat_orders'] : "";
      repeat_orders =
          json['repeat_orders'] != null ? json['repeat_orders'] : "";
      next_delivery_date =
          json['next_delivery_date'] != null ? json['next_delivery_date'] : "";
      order_status_delivery = json['order_status_delivery'] != null
          ? json['order_status_delivery']
          : "";
      thumbnail = json['thumbnail'] != null ? json['thumbnail'] : "";
     
      if (repeatDays == null) {
        repeatDays = "";
      }
      final split = repeatDays!.split(',');
     
      for (int i = 0; i < split.length; i++) {
        if (split[i] == "mon") {
          mon = true;
        }
        if (split[i] == "tue") {
          tues = true;
        }
        if (split[i] == "wed") {
          wed = true;
        }
        if (split[i] == "thu") {
          thu = true;
        }
        if (split[i] == "fri") {
          fri = true;
        }
        if (split[i] == "sat") {
          sat = true;
        }
        if (split[i] == "sun") {
          sun = true;
        }
      }

      if (json['egg_eggless'] != null) {
        eggEggless = <String>[];
        eggEggless = json['egg_eggless'].cast<String>();
      }
      if (json['flavour'] != null) {
        flavour = <Flavour>[];
        json['flavour'].forEach((v) {
          flavour!.add(new Flavour.fromJson(v));
        });
      }
      productStartDate = json['from_date'];
    productEndDate = json['to_date'];
    labelFlavourColor = json['flavour_name'];
    } catch (e) {
      print("Exception - categoryProductModel.dart - Product.fromJson():" +
          e.toString());
    }
  }
}

class Flavour {
  String? name;

  Flavour({this.name});

  Flavour.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class AddOnProduct {
  int? addOnPID;
  int? addOnvarientId;
  int? stock;
 
  double? mrp;
  double? price;
  int? addOnProductId;
  String? unit;
  double? baseMrp;
  double? basePrice;
  String? description;
  String? varientImage;
 
  int? catId;
  String? productName;
  String? productImage;
  String? type;

  String? repeated_order_cart;
  int? hide;
  int? count;
  List<ImageModel>? images = [];
  List<Varient>? varient = [];
  int? qty;
  double? totalMrp;
  
  String? txName;
  String? isFavourite;
  int? cartQty;
  int? countrating;
  int? rating;
  int? ratingCount;
  int? userRating;
  bool? isSelected = false;
  bool? isAdded = false;
  dynamic? discount;
  double? maxprice;
  String? ratingDescription;
  String? thumbnail;
  

  List<String>? eggEggless;
  int? vegOrNonveg = 0;
  String? labelFlavourColor;

  // Product();
  AddOnProduct(String productName,String productImage, double price, double mrp, int discountper,int stock, String description, int cartQty){
      this.productName=productName;
      this.productImage=productImage;
      this.price=price;
      this.mrp=mrp;
      this.discount=discountper;
      this.stock=stock;
      this.description=description;
      this.cartQty=cartQty;

  }
  AddOnProduct.fromJson(Map<String, dynamic> json) {
    try {
      addOnPID = json['p_id'] != null ? int.parse(json['p_id'].toString()) : null;

      addOnvarientId = json['varient_id'] != null
          ? int.parse(json['varient_id'].toString())
          : null;

      stock = json['stock'] != null ? int.parse(json['stock'].toString()) : 0;

      

      mrp =
          json['mrp'] != null ? double.parse('${json['mrp'].toString()}') : 0.0;

      price = json['price'] != null
          ? double.parse('${json['price'].toString()}')
          : null;


      addOnProductId = json['product_id'] != null
          ? int.parse(json['product_id'].toString())
          : null;

     

      unit = json['unit'] != null ? json['unit'] : '';

      baseMrp = json['base_mrp'] != null
          ? double.parse(json['base_mrp'].toString())
          : 0.0;

      basePrice = json['base_price'] != null
          ? double.parse(json['base_price'].toString())
          : 0.0;

      repeated_order_cart = json['repeated_order_cart'] != null
          ? json['repeated_order_cart']
          : '';

      description = json['description'] != null ? json['description'] : '';

      varientImage = json['varient_image'] != null ? json['varient_image'] : '';


      catId =
          json['cat_id'] != null ? int.parse(json['cat_id'].toString()) : null;

      productName = json['product_name'] != null ? json['product_name'] : '';

      productImage = json['product_image'] != null ? json['product_image'] : '';

      type = json['type'] != null ? json['type'] : '';

      hide = json['hide'] != null ? int.parse(json['hide'].toString()) : null;

      count =
          json['count'] != null ? int.parse(json['count'].toString()) : null;

      qty = json['qty'] != null ? int.parse(json['qty'].toString()) : null;

      totalMrp = json['total_mrp'] != null
          ? double.parse(json['total_mrp'].toString())
          : null;

      
      isFavourite =
          json['isFavourite'] != null ? json['isFavourite'].toString() : "";
     

      cartQty =
          json['cart_qty'] != null ? int.parse(json['cart_qty'].toString()) : 0;

      countrating = json['countrating'] != null
          ? int.parse(json['countrating'].toString())
          : null;

      rating = json['avgrating'] != null
          ? double.parse(json['avgrating'].toString()).round()
          : 0;

      userRating = json['rating'] != null
          ? double.parse(json['rating'].toString()).round()
          : 0;

      ratingCount = json['countrating'] != null
          ? int.parse(json['countrating'].toString())
          : 0;

      ratingDescription =
          json['rating_description'] != null ? json['rating_description'] : '';

      discount = json['discountper'] != null
          ? double.parse(json['discountper'].toString()).round()
          : 0;

      images = json['images'] != null
          ? List<ImageModel>.from(
              json['images'].map((x) => ImageModel.fromJson(x)))
          : [];
    
      varient = json['varients'] != null
          ? List<Varient>.from(json['varients'].map((x) => Varient.fromJson(x)))
          : [];
      
      thumbnail = json['thumbnail'] != null ? json['thumbnail'] : "";
     
    
      

      if (json['egg_eggless'] != null) {
        eggEggless = <String>[];
        eggEggless = json['egg_eggless'].cast<String>();
      }
   
    labelFlavourColor = json['flavour_name'];
    } catch (e) {
      print("Exception - categoryProductModel.dart - Product.fromJson():" +
          e.toString());
    }
  }
}

