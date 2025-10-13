import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/categoryProductModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
 final dynamic analytics;
  final dynamic observer;
    final Product? product;
 final int? callId;
  final List<Product>? categoryProductList;
  Function? funOnTap;
  bool? isSubCatgoriesScreen;
  final String? isHomeSelected;
  final dynamic passdata1;
  final dynamic passdata2;
  final dynamic passdata3;
  final dynamic screenName;

  ProductItem({this.analytics, this.observer, this.product,
  this.categoryProductList,
      this.callId,
      this.funOnTap,
      this.isHomeSelected,
      
      this.passdata1,
      this.passdata2,
      this.passdata3,
      this.isSubCatgoriesScreen,
      this.screenName}): super();
  
  @override
  _ProductsItemState createState() => _ProductsItemState(
this.analytics, this.observer, this.product
  );
  

}
class _ProductsItemState extends State<ProductItem> {
final dynamic analytics;
  final dynamic observer;
      final Product? product;

  _ProductsItemState(this.analytics, this.observer, this.product);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(product);
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              
              Image.network(
                            
                            global.imageBaseUrl +
                                product!.productImage! +
                                "?width=500&height=500",
                            cacheWidth: 360,
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width / 2.1,
                            height: MediaQuery.of(context).size.height,
                          ),
                         
            ],
            
          ),
           Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Text(
                                    "${product!.productName}",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily:
                                            global.fontRailwayRegular,
                                        fontWeight: FontWeight.w200,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        color: ColorConstants.pureBlack),
                                  ),
                                ),
                                // product.productName.length < 18
                                //     ? SizedBox(height: 20)
                                //     : Container(),
                                // Container(
                                //   margin: EdgeInsets.only(top: 1, bottom: 1),
                                //   child: Text(
                                //     "${product.productName}",
                                //     maxLines: 1,
                                //     // "${categoryProductList[index].varient[0].description}",
                                //     style: TextStyle(
                                //         fontFamily: global.fontMontserratLight,
                                //         fontSize: 16,
                                //         overflow: TextOverflow.ellipsis,
                                //         color: Colors.black54),
                                //   ),
                                // ),
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 3),
                                        child: Text(
                                          "AED ",
                                          style: TextStyle(
                                              fontFamily:
                                                  global.fontRailwayRegular,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 13,
                                              color: ColorConstants.pureBlack),
                                        ),
                                      ),
                                      Text(
                                        int.parse(product!.price
                                                    .toString()
                                                    .substring(product!
                                                            
                                                            .price
                                                            .toString()
                                                            .indexOf(".") +
                                                        1)) >
                                                0
                                            ? "${product!.price!.toStringAsFixed(2)}"
                                            : "${product!.price.toString().substring(0, product!.price.toString().indexOf("."))}", //"${product.varient[0].buyingPrice}",
                                        style: TextStyle(
                                            fontFamily:
                                                global.fontMontserratLight,
                                            fontSize: 15,
                                            color: ColorConstants.pureBlack),
                                      ),
                                      product!.price! <
                                              product!.mrp!
                                          ? Stack(children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 3),
                                                padding: EdgeInsets.only(
                                                    top: 2, bottom: 2),
                                                child: Text(
                                                  int.parse(product!
                                                              .mrp
                                                              .toString()
                                                              .substring(product!
                                                                      
                                                                      .mrp
                                                                      .toString()
                                                                      .indexOf(
                                                                          ".") +
                                                                  1)) >
                                                          0
                                                      ? "${product!.mrp!.toStringAsFixed(2)}"
                                                      : "${product!.mrp.toString().substring(0, product!.mrp.toString().indexOf("."))}", //"${product.varient[0].baseMrp}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 11,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 3, top: 1),
                                                alignment: Alignment.center,
                                                // decoration: BoxDecoration(
                                                //     color: Colors.white.withOpacity(0.6),
                                                //     borderRadius: BorderRadius.circular(5)),
                                                //padding: const EdgeInsets.all(5),
                                                child: Center(
                                                  child: Transform.rotate(
                                                    angle: 0,
                                                    child: Text(
                                                        product!
                                                                    .mrp
                                                                    .toString()
                                                                    .length ==
                                                                3
                                                            ? "----"
                                                            : "-----",
                                                        // '${AppLocalizations.of(context).txt_out_of_stock}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontFamily: global
                                                                .fontRailwayRegular,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 11,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                ),
                                              ),
                                            ])
                                          : Container(),
                                      // Container(
                                      //   margin: EdgeInsets.only(left: 3, right: 5),
                                      //   child: Text(
                                      //     product.varient[0].discountper
                                      //             .toString()
                                      //             .startsWith("-")
                                      //         ? "${product.varient[0].discountper.toString().substring(1)}% off"
                                      //         : "${product.varient[0].discountper}% off", //"${product.varient[0].buyingPrice}",
                                      //     style: TextStyle(
                                      //         fontFamily:
                                      //             global.fontRailwayRegular,
                                      //         fontWeight: FontWeight.w200,
                                      //         fontSize: 12,
                                      //         color: ColorConstants.appColor),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                               
                              ],
                            ),
                          ),
                     
        ],
      ),
    );
  }
}


