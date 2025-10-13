import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/varientModel.dart';

class Cart {
  String? status;
  String? message;
  CartData? cartData;

  List<FrequentlyboughttogetherProduct>? simmilarProducts;

  Cart();
  Cart.fromJson(Map<String, dynamic> json) {
    try {
      cartData =
          json['data'] != null ? new CartData.fromJson(json['data']) : null;
      if (json['frequentlyboughttogether_product'] != null) {
        simmilarProducts = <FrequentlyboughttogetherProduct>[];
        json['frequentlyboughttogether_product'].forEach((v) {
          simmilarProducts!
              .add(new FrequentlyboughttogetherProduct.fromJson(v));
        });
      }
    } catch (e) {
      print("Exception - cartModel.dart - Cart.fromJson():" + e.toString());
    }
  }
}

class AddtoCart {
  String? status;
  String? message;
  CartData? cartData;

  AddtoCart();
  AddtoCart.fromJson(Map<String, dynamic> json) {
    try {
      
      cartData =
          json['data'] != null ? new CartData.fromJson(json['data']) : null;
      
    } catch (e) {
      print(
          "Exception - cartModel.dart - AddtoCart.fromJson():" + e.toString());
    }
  }
}

class StoreDetails {
  int? id;
  String? storeName;
  String? employeeName;
  String? phoneNumber;
  String? storePhoto;
  String? city;
  int? cityId;
  int? adminShare;
  dynamic deviceId;
  String? email;
  String? password;
  int? delRange;
  String? lat;
  String? lng;
  String? address;
  int? adminApproval;
  int? orders;
  int? storeStatus;
  String? storeOpeningTime;
  String? storeClosingTime;
  int? timeInterval;
  dynamic inactiveReason;
  String? idType;
  String? idNumber;
  String? idPhoto;
  int? storeRoleId;
  dynamic roleName;
  dynamic storeId;

  StoreDetails(
      {this.id,
      this.storeName,
      this.employeeName,
      this.phoneNumber,
      this.storePhoto,
      this.city,
      this.cityId,
      this.adminShare,
      this.deviceId,
      this.email,
      this.password,
      this.delRange,
      this.lat,
      this.lng,
      this.address,
      this.adminApproval,
      this.orders,
      this.storeStatus,
      this.storeOpeningTime,
      this.storeClosingTime,
      this.timeInterval,
      this.inactiveReason,
      this.idType,
      this.idNumber,
      this.idPhoto,
      this.storeRoleId,
      this.roleName,
      this.storeId});

  StoreDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['store_name'];

    employeeName = json['employee_name'];

    phoneNumber = json['phone_number'];

    storePhoto = json['store_photo'];

    city = json['city'];

    cityId = json['city_id'];

    adminShare = json['admin_share'];

    deviceId = json['device_id'];

    email = json['email'];

    password = json['password'];

    delRange = json['del_range'];

    lat = json['lat'];

    lng = json['lng'];

    address = json['address'];

    adminApproval = json['admin_approval'];

    orders = json['orders'];

    storeStatus = json['store_status'];

    storeOpeningTime = json['store_opening_time'];

    storeClosingTime = json['store_closing_time'];

    timeInterval = json['time_interval'];

    inactiveReason = json['inactive_reason'];

    idType = json['id_type'];

    idNumber = json['id_number'];

    idPhoto = json['id_photo'];

    storeRoleId = json['store_role_id'];

    roleName = json['role_name'];

    storeId = json['store_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_name'] = this.storeName;
    data['employee_name'] = this.employeeName;
    data['phone_number'] = this.phoneNumber;
    data['store_photo'] = this.storePhoto;
    data['city'] = this.city;
    data['city_id'] = this.cityId;
    data['admin_share'] = this.adminShare;
    data['device_id'] = this.deviceId;
    data['email'] = this.email;
    data['password'] = this.password;
    data['del_range'] = this.delRange;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['admin_approval'] = this.adminApproval;
    data['orders'] = this.orders;
    data['store_status'] = this.storeStatus;
    data['store_opening_time'] = this.storeOpeningTime;
    data['store_closing_time'] = this.storeClosingTime;
    data['time_interval'] = this.timeInterval;
    data['inactive_reason'] = this.inactiveReason;
    data['id_type'] = this.idType;
    data['id_number'] = this.idNumber;
    data['id_photo'] = this.idPhoto;
    data['store_role_id'] = this.storeRoleId;
    data['role_name'] = this.roleName;
    data['store_id'] = this.storeId;
    return data;
  }
}

class CartData {
  double? discountonmrp;
  double? totalPrice;
  double? totalMrp;
  int? totalItems;
  StoreDetails? storeDetails;
  int? totalTax;
  int? avgTax;
  double? deliveryCharge;
  double? deliverychargediscount;
  int? subscriptionFee;
  List<CartProduct>? cartProductdata;

  CartData.fromJson(Map<String, dynamic> json) {
    print("CartData-1");
    discountonmrp = double.parse(json['discountonmrp'].toString());

    totalPrice = double.parse(json['total_price'].toString());

    totalMrp = double.parse(json['total_mrp'].toString());

    totalItems = json['total_items'];

    storeDetails = json['store_details'] != null
        ? new StoreDetails.fromJson(json['store_details'])
        : null;

    totalTax = json['total_tax'];

    avgTax = json['avg_tax'];

    deliveryCharge = double.parse(json['delivery_charge'].toString());

    deliverychargediscount =
        double.parse(json['delivery_charge_discount'].toString());

    subscriptionFee = json['subscription_fee'];

    if (json['data'] != null) {
      cartProductdata = <CartProduct>[];
      json['data'].forEach((v) {
        cartProductdata!.add(new CartProduct.fromJson(v));
      });
    }
  }
}

class CartProduct {
  String? repeatedOrderCart;
  String? productName;
  String? varientImage;
  int? quantity;
  String? unit;
  double? totalMrp;
  double? price;
  double? mrp;
  int? cartQty;
  String? orderCartId;
  String? orderDate;
  String? delivery_date;
  String? delivery_time;
  String? selectedMessage;
  int? storeApproval;
  int? storeId;
  int? varientId;
  int? productId;
  int? stock;
  int? txPer;
  double? priceWithoutTax;
  double? txPrice;
  String? txName;
  String? productImage;
  String? thumbnail;
  String? description;
  String? deliveryType;
  String? type;
  double? ordPrice;
  String? repeatOrders;
  String? isFavourite;
  double? avgrating;
  int? countrating;
  int? discountper;
  int? isDeliveryValid;
  int? isTimeValid;

  String? flavour;
  String? eggEggless;
  

  CartProduct.fromJson(Map<String, dynamic> json) {
    print("CartData-2");
    repeatedOrderCart = json['repeated_order_cart'];

    productName = json['product_name'];

    varientImage = json['varient_image'];

    quantity = json['quantity'];

    unit = json['unit'];

    totalMrp = double.parse(json['total_mrp'].toString());

    price = double.parse(json['price'].toString());

    mrp = double.parse(json['mrp'].toString());
    deliveryType = json['delivery_type'].toString();

    cartQty = json['cart_qty'];

    orderCartId = json['order_cart_id'];

    orderDate = json['order_date'];

    delivery_date = json['delivery_date'];

    delivery_time = json['delivery_time'];

    storeApproval = json['store_approval'];

    storeId = json['store_id'];

    varientId = json['varient_id'];

    productId = json['product_id'];

    stock = json['stock'];

    txPer = json['tx_per'];

    priceWithoutTax = json['price_without_tax'] != null
        ? double.parse(json['price_without_tax'].toString())
        : 0;

    txPrice = json['tx_price'] != null
        ? double.parse(json['tx_price'].toString())
        : 0;

    txName = json['tx_name'];

    productImage = json['product_image'];

    thumbnail = json['thumbnail'];

    description = json['description'];
    isDeliveryValid = json['is_delivery_valid'];
    isTimeValid = json['is_time_valid'];

    type = json['type'];

    ordPrice = json['ord_price'] != null
        ? double.parse(json['ord_price'].toString())
        : 0;

    repeatOrders = json['repeat_orders'];

    isFavourite = json['isFavourite'];

    avgrating = double.parse(json['avgrating'].toString());

    countrating = json['countrating'];

    discountper = json['discountper'];

    selectedMessage = json['personalized_message'];
    eggEggless = json['egg_eggless'];
    flavour = json['flavour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['repeated_order_cart'] = this.repeatedOrderCart;
    data['product_name'] = this.productName;
    data['varient_image'] = this.varientImage;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['total_mrp'] = this.totalMrp;
    data['price'] = this.price;
    data['mrp'] = this.mrp;
    data['cart_qty'] = this.cartQty;
    data['order_cart_id'] = this.orderCartId;
    data['order_date'] = this.orderDate;
    data['delivery_date'] = this.delivery_date;
    data['delivery_time'] = this.delivery_time;
    data['store_approval'] = this.storeApproval;
    data['store_id'] = this.storeId;
    data['varient_id'] = this.varientId;
    data['product_id'] = this.productId;
    data['stock'] = this.stock;
    data['tx_per'] = this.txPer;
    data['price_without_tax'] = this.priceWithoutTax;
    data['tx_price'] = this.txPrice;
    data['tx_name'] = this.txName;
    data['product_image'] = this.productImage;
    data['thumbnail'] = this.thumbnail;
    data['description'] = this.description;
    data['type'] = this.type;
    data['ord_price'] = this.ordPrice;
    data['repeat_orders'] = this.repeatOrders;
    data['isFavourite'] = this.isFavourite;
    data['avgrating'] = this.avgrating;
    data['countrating'] = this.countrating;
    data['discountper'] = this.discountper;
    return data;
  }
}

class FrequentlyboughttogetherProduct {
  int? pId;
  int? varientId;
  int? stock;
  int? storeId;
  double? mrp;
  double? price;
  int? minOrdQty;
  int? maxOrdQty;
  double? buyingprice;
  double? buying_Price;
  int? isActive;
  int? productId;
  String? id;
  int? quantity;
  String? unit;
  double? baseMrp;
  double? basePrice;
  String? description;
  String? varientImage;
  String? ean;
  int? approved;
  int? addedBy;
  int? personalizedTextLength;
  int? personalizedImageHeight;
  int? personalizedImageWidth;
  int? catId;
  String? brandId;
  String? productName;
  String? productImage;
  String? type;
  String? delivery;
  int? hide;
  int? isSubscription;
  String? thumbnail;
  int? isPersonalized;
  bool? isFavourite;
  int? cartQty;
  double? avgrating;
  int? countrating;
  int? discountper;
  List<Images>? images;
  List<Tags>? tags;
  List<Varients>? varients;

  FrequentlyboughttogetherProduct(
      {this.pId,
      this.varientId,
      this.stock,
      this.storeId,
      this.mrp,
      this.price,
      this.minOrdQty,
      this.maxOrdQty,
      this.buyingprice,
      this.buying_Price,
      this.isActive,
      this.productId,
      this.id,
      this.quantity,
      this.unit,
      this.baseMrp,
      this.basePrice,
      this.description,
      this.varientImage,
      this.ean,
      this.approved,
      this.addedBy,
      this.personalizedTextLength,
      this.personalizedImageHeight,
      this.personalizedImageWidth,
      this.catId,
      this.brandId,
      this.productName,
      this.productImage,
      this.type,
      this.delivery,
      this.hide,
      this.isSubscription,
      this.thumbnail,
      this.isPersonalized,
      this.isFavourite,
      this.cartQty,
      this.avgrating,
      this.countrating,
      this.discountper,
      this.images,
      this.tags,
      this.varients});

  FrequentlyboughttogetherProduct.fromJson(Map<String, dynamic> json) {
    pId = json['p_id'];

    varientId = json['varient_id'];

    stock = json['stock'];

    storeId = json['store_id'];

    mrp = double.parse(json['mrp'].toString());

    price = double.parse(json['price'].toString());

    minOrdQty = json['min_ord_qty'];

    maxOrdQty = json['max_ord_qty'];
    //print("FBTP8");
    buyingprice = json['buyingprice'] != null
        ? double.parse(json['buyingprice'].toString())
        : 0.0;
    //print(json['buyingprice']);
    buying_Price = json['buying_price'] != null
        ? double.parse(json['buying_price'].toString())
        : 0.0;
    isActive = json['is_active'];

    productId = json['product_id'];
    id = json['id'];

    quantity = json['quantity'];

    unit = json['unit'];

    baseMrp = double.parse(json['base_mrp'].toString());

    basePrice = double.parse(json['base_price'].toString());

    description = json['description'];

    varientImage = json['varient_image'];

    ean = json['ean'];

    approved = json['approved'];

    addedBy = json['added_by'];

    personalizedTextLength = json['personalized_text_length'];

    personalizedImageHeight = json['personalized_image_height'];

    personalizedImageWidth = json['personalized_image_width'];

    catId = json['cat_id'];

    brandId = json['brand_id'];

    productName = json['product_name'];

    productImage = json['product_image'];

    type = json['type'];

    delivery = json['delivery'];

    hide = json['hide'];

    isSubscription = json['is_subscription'];

    thumbnail = json['thumbnail'];

    isPersonalized = json['is_personalized'];

    isFavourite = json['isFavourite'];

    cartQty = json['cart_qty'];

    avgrating = double.parse(json['avgrating'].toString());

    countrating = json['countrating'];

    discountper = json['discountper'];

    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }

    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(new Tags.fromJson(v));
      });
    }

    if (json['varients'] != null) {
      varients = <Varients>[];
      json['varients'].forEach((v) {
        varients!.add(new Varients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['p_id'] = this.pId;
    data['varient_id'] = this.varientId;
    data['stock'] = this.stock;
    data['store_id'] = this.storeId;
    data['mrp'] = this.mrp;
    data['price'] = this.price;
    data['min_ord_qty'] = this.minOrdQty;
    data['max_ord_qty'] = this.maxOrdQty;
    data['buyingprice'] = this.buyingprice;
    data['buying_price'] = this.buying_Price;
    data['is_active'] = this.isActive;
    data['product_id'] = this.productId;
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['base_mrp'] = this.baseMrp;
    data['base_price'] = this.basePrice;
    data['description'] = this.description;
    data['varient_image'] = this.varientImage;
    data['ean'] = this.ean;
    data['approved'] = this.approved;
    data['added_by'] = this.addedBy;
    data['personalized_text_length'] = this.personalizedTextLength;
    data['personalized_image_height'] = this.personalizedImageHeight;
    data['personalized_image_width'] = this.personalizedImageWidth;
    data['cat_id'] = this.catId;
    data['brand_id'] = this.brandId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['type'] = this.type;
    data['delivery'] = this.delivery;
    data['hide'] = this.hide;
    data['is_subscription'] = this.isSubscription;
    data['thumbnail'] = this.thumbnail;
    data['is_personalized'] = this.isPersonalized;
    data['isFavourite'] = this.isFavourite;
    data['cart_qty'] = this.cartQty;
    data['avgrating'] = this.avgrating;
    data['countrating'] = this.countrating;
    data['discountper'] = this.discountper;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    if (this.varients != null) {
      data['varients'] = this.varients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? image;

  Images({this.image});

  Images.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}

class Tags {
  int? tagId;
  int? productId;
  String? tag;

  Tags({this.tagId, this.productId, this.tag});

  Tags.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'];
    productId = json['product_id'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag_id'] = this.tagId;
    data['product_id'] = this.productId;
    data['tag'] = this.tag;
    return data;
  }
}

class Varients {
  int? storeId;
  int? stock;
  int? varientId;
  String? description;
  int? price;
  int? mrp;
  String? varientImage;
  String? unit;
  int? quantity;
  int? dealPrice;
  String? validFrom;
  String? validTo;
  bool? isFavourite;
  int? cartQty;
  double? avgrating;
  int? countrating;
  int? discountper;

  Varients(
      {this.storeId,
      this.stock,
      this.varientId,
      this.description,
      this.price,
      this.mrp,
      this.varientImage,
      this.unit,
      this.quantity,
      this.dealPrice,
      this.validFrom,
      this.validTo,
      this.isFavourite,
      this.cartQty,
      this.avgrating,
      this.countrating,
      this.discountper});

  Varients.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];

    stock = json['stock'];

    varientId = json['varient_id'];

    description = json['description'];

    price = json['price'];

    mrp = json['mrp'];

    varientImage = json['varient_image'];

    unit = json['unit'];

    quantity = json['quantity'];

    dealPrice = json['deal_price'];

    validFrom = json['valid_from'];

    validTo = json['valid_to'];

    isFavourite = json['isFavourite'];

    cartQty = json['cart_qty'];

    avgrating = double.parse(json['avgrating'].toString());

    countrating = json['countrating'];

    discountper = json['discountper'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['stock'] = this.stock;
    data['varient_id'] = this.varientId;
    data['description'] = this.description;
    data['price'] = this.price;
    data['mrp'] = this.mrp;
    data['varient_image'] = this.varientImage;
    data['unit'] = this.unit;
    data['quantity'] = this.quantity;
    data['deal_price'] = this.dealPrice;
    data['valid_from'] = this.validFrom;
    data['valid_to'] = this.validTo;
    data['isFavourite'] = this.isFavourite;
    data['cart_qty'] = this.cartQty;
    data['avgrating'] = this.avgrating;
    data['countrating'] = this.countrating;
    data['discountper'] = this.discountper;
    return data;
  }
}
