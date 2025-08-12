class Varient {
  int? varientId;
  int? productId;
  int? quantity;
  String? unit;
  double? baseMrp;
  double? basePrice;
  double? buyingPrice;
  int? discountper;
  String? description;
  String? varientImage;
  int? cartQty;
  String? ean;
  int? approved;
  int? addedBy;
  int? stock = 0;
  int? dealPrice;
  String? validFrom;
  String? validTo;
  String? isFavourite;
  int? avgrating;
  int? countrating;
  String? vegOrNonveg;

  Varient();
  Varient.fromJson(Map<String, dynamic> json) {
    try {
      varientId = json['varient_id'];
      productId = json['product_id'];
      quantity = json['quantity'];
      cartQty = json['cartQty'];
      unit = json['unit'];
      baseMrp =
          json['mrp'] != null ? double.parse(json['mrp'].toString()) : null;
      basePrice =
          json['price'] != null ? double.parse(json['price'].toString()) : null;
      ;
      buyingPrice = json['buying_price'];
      description = json['description'];
      isFavourite =
          json['isFavourite'] != null ? json['isFavourite'].toString() : "";
      varientImage = json['varient_image'];
      ean = json['ean'];
      approved = json['approved'];
      addedBy = json['added_by'];
      discountper = json['discountper'];
      stock = json['stock'] != null ? int.parse(json['stock'].toString()) : 0;
      vegOrNonveg = json['vegOrNonveg'] != null ? json['vegOrNonveg'] : null;
    } catch (e) {
      print(
          "Exception - varientModel.dart - Varient.fromJson():" + e.toString());
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stock'] = this.stock;
    data['varient_id'] = this.varientId;
    data['description'] = this.description;
    data['price'] = this.basePrice;
    data['mrp'] = this.baseMrp;
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
