import 'package:byyu/constants/color_constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'package:shimmer/shimmer.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/productFilterModel.dart';
//import 'package:byyu/screens/filter_screen.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/widgets/cart_item_count_button.dart';
import 'package:byyu/widgets/products_menu.dart';

class ProductListScreen extends BaseRoute {
  final int? screenId;
  final int? categoryId;
  final String? categoryName;
  final String? isHomeSelected;
  ProductListScreen(
      {a,
      o,
      this.screenId,
      this.categoryId,
      this.categoryName,
      this.isHomeSelected})
      : super(a: a, o: o, r: 'ProductListScreen');

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends BaseRouteState {
  final CartController cartController = Get.put(CartController());
  List<Product> _productsList = [];
  bool _isDataLoaded = false;
  int? screenId;
  int? categoryId;
  String? categoryName;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  String? isHomeSelected;

  ProductFilter _productFilter = new ProductFilter();
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  String apiResponseMessage = "";
  int page = 1;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _ProductListScreenState(
      {this.screenId, this.categoryId, this.categoryName, this.isHomeSelected});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.white,
          // centerTitle: true,
          leadingWidth: 50,
          centerTitle: false,
          toolbarHeight: 60,
          titleSpacing: 0,
          title: Container(
            // width: 450,
            child: Text(
              categoryName!,
              // style: textTheme.titleLarge, maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge, //TextStyle(fontSize: 16, color: global.indigoColor, fontWeight: FontWeight.bold),
            ),
          ),
          leading: BackButton(
              onPressed: () {
                if (isHomeSelected == 'home') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(
                                a: widget.analytics,
                                o: widget.observer,
                                selectedIndex: 0,
                              )));
                } else {
                  Navigator.pop(context);
                }
              },
              //icon: Icon(Icons.keyboard_arrow_left),
              color: global.bgCompletedColor),
          actions: [
            Container(
              margin: EdgeInsets.only(left: 0.0, right: 10),
              child: IconButton(
                onPressed: () {
                  // showBottomSheet();
                  // _applyFilters();
                },
                icon: Icon(
                  Icons.filter_alt,
                  color: global.indigoColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: _isDataLoaded
            ? _productsList != null && _productsList.length > 0
                ? RefreshIndicator(
                    onRefresh: () async {
                      await _onRefresh();
                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              ProductsMenu(
                                                                              isSubCatgoriesScreen: false,

                                analytics: widget.analytics,
                                observer: widget.observer,
                                categoryProductList: _productsList,
                                refreshProductList:callProductList

                              ),
                              _isMoreDataLoaded
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        )),
                  )
                : Center(child: Text('${apiResponseMessage}'))
            : _shimmer(),
        bottomNavigationBar: _productsList.length > 0
            ? Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  child: CartItemCountButton(
                    analytics: widget.analytics,
                    observer: widget.observer,
                    cartController: cartController,
                  ),
                ),
              )
            : Container(
                child: Text(''),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void callProductList(){
    _init();
  }

  // _applyFilters() async {
  //   try {
  //     showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (context) => FractionallySizedBox(
  //         heightFactor: 0.85,
  //         child: Padding(
  //             padding: EdgeInsets.only(top: 10),
  //             child: FilterScreen(
  //               _productFilter,
  //               isProductAvailable:
  //                   _productsList != null && _productsList.length > 0
  //                       ? true
  //                       : false,
  //               screenName: "subCate",
  //             )),
  //       ),
  //     ).then((value) async {
  //       if (value != null) {
  //         _isDataLoaded = false;
  //         _isRecordPending = true;
  //         if (_productsList != null && _productsList.length > 0) {
  //           _productsList.clear();
  //         }

  //         setState(() {});
  //         _productFilter = value;
  //         await _init();
  //       }
  //     });
  //   } catch (e) {
  //     print("Exception - productlist_screen.dart - _applyFilters():" +
  //         e.toString());
  //   }
  // }

  _getCategoryProduct() async {
    try {
      if (_isRecordPending) {
        setState(() {
          _isMoreDataLoaded = true;
        });
        if (_productsList.isEmpty) {
          page = 1;
        } else {
          page++;
        }
        await apiHelper
            .getCategoryProducts(categoryId!, page, _productFilter, 1 , "","","","","","","","","","")
            .then((result) async {
          print("This is the result${result}");
          if (result != null) {
            if (result.status == "1") {
              List<Product> _tList = result.data;
              if (_tList.isEmpty) {
                print("Nikhil is empty loop");
                _isDataLoaded = true;
              } else {
                _productsList.addAll(_tList);
                _isDataLoaded = true;
              }
              setState(() {
                _isMoreDataLoaded = false;
                _isDataLoaded = true;
              });
            } else if (result.status == "0") {
              _isDataLoaded = true;

              setState(() {
                apiResponseMessage = result.message;
                _isMoreDataLoaded = false;
                _isDataLoaded = true;
              });
            }
          } else {
            print("Nikhil is Main else");
          }
        });
      }
    } catch (e) {
      print("Exception - productlist_screen.dart - _getCategoryProduct():" +
          e.toString());
    }
  }

  // _getDealProduct() async {
  // AAAC useless code
  //   try {
  //     if (_isRecordPending) {
  //       setState(() {
  //         _isMoreDataLoaded = true;
  //       });
  //       if (_productsList.isEmpty) {
  //         page = 1;
  //       } else {
  //         page++;
  //       }
  //       await apiHelper
  //           .getDealProducts(page, _productFilter)
  //           .then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             List<Product> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }
  //             _productsList.addAll(_tList);
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception - productlist_screen.dart - _getDealProduct():" +
  //         e.toString());
  //   }
  // }

  _getProductList() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (screenId == 0) {
          await _getCategoryProduct();
        }
        // else if (screenId == 1) {
        //   await _getDealProduct();
        // } else if (screenId == 2) {
        //   await _getTagProducts();
        // } else if (screenId == 3) {
        //   await _getWhatsNewProduct();
        // } else if (screenId == 4) {
        //   await _getSpotLightProduct();
        // } else if (screenId == 5) {
        //   await _getRecentSellingProduct();
        // } else {
        //   await _getTopSellingProduct();
        // }

        _isDataLoaded = true;
      } else {
        showNetworkErrorSnackBar1(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - productlist_screen.dart - _getProductList():" +
          e.toString());
    }
  }

  // _getRecentSellingProduct() async {
  // AAAC useless code
  //   try {
  //     if (_isRecordPending) {
  //       setState(() {
  //         _isMoreDataLoaded = true;
  //       });
  //       if (_productsList.isEmpty) {
  //         page = 1;
  //       } else {
  //         page++;
  //       }
  //       print(_productsList.length);

  //       await apiHelper
  //           .recentSellingProduct(page, _productFilter)
  //           .then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             List<Product> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }
  //             _productsList.addAll(_tList);
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print(
  //         "Exception - productlist_screen.dart - _getRecentSellingProduct():" +
  //             e.toString());
  //   }
  // }

  // _getSpotLightProduct() async {
  // AAAC useless code
  //   try {
  //     if (_isRecordPending) {
  //       setState(() {
  //         _isMoreDataLoaded = true;
  //       });
  //       if (_productsList.isEmpty) {
  //         page = 1;
  //       } else {
  //         page++;
  //       }
  //       await apiHelper
  //           .spotLightProduct(page, _productFilter)
  //           .then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             List<Product> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }
  //             _productsList.addAll(_tList);
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception - productlist_screen.dart - _getSpotLightProduct():" +
  //         e.toString());
  //   }
  // }

  // _getTagProducts() async {
  // AAAC useless code
  //   try {
  //     if (_isRecordPending) {
  //       setState(() {
  //         _isMoreDataLoaded = true;
  //       });
  //       if (_productsList.isEmpty) {
  //         page = 1;
  //       } else {
  //         page++;
  //       }
  //       await apiHelper
  //           .getTagProducts(categoryName!, page, _productFilter)
  //           .then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             List<Product> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }
  //             _productsList.addAll(_tList);
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception - productlist_screen.dart - _getDealProduct():" +
  //         e.toString());
  //   }
  // }

  // _getTopSellingProduct() async {
  // AAAC useless code
  //   try {
  //     if (_isRecordPending) {
  //       setState(() {
  //         _isMoreDataLoaded = true;
  //       });
  //       if (_productsList.isEmpty) {
  //         page = 1;
  //       } else {
  //         page++;
  //       }
  //       await apiHelper
  //           .getTopSellingProducts(page, _productFilter)
  //           .then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             List<Product> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }
  //             _productsList.addAll(_tList);
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception - productlist_screen.dart - _getTopSellingProduct():" +
  //         e.toString());
  //   }
  // }

  // _getWhatsNewProduct() async {
  // AAAC useless code
  //   try {
  //     if (_isRecordPending) {
  //       setState(() {
  //         _isMoreDataLoaded = true;
  //       });
  //       if (_productsList.isEmpty) {
  //         page = 1;
  //       } else {
  //         page++;
  //       }
  //       await apiHelper
  //           .whatsnewProduct(page, _productFilter)
  //           .then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             List<Product> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }
  //             _productsList.addAll(_tList);
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception - productlist_screen.dart - _getWhatsNewProduct():" +
  //         e.toString());
  //   }
  // }

  _init() async {
    try {
      await _getProductList();

      _scrollController1 = ScrollController()..addListener(_scrollListener);

      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - productlist_screen.dart - _init():" + e.toString());
    }
  }

  void _scrollListener() {
    if (_scrollController1.position.pixels ==
        _scrollController1.position.maxScrollExtent * 0.75) {
      print('At the bottom caaling g1');
      _getProductList();
    }
  }

  _onRefresh() async {
    try {
      _productsList.clear();
      _isDataLoaded = false;
      _isRecordPending = true;
      setState(() {});
      await _init();
    } catch (e) {
      print(
          "Exception - productlist_screen.dart - _onRefresh():" + e.toString());
    }
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 15,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: 100 * MediaQuery.of(context).size.height / 830,
                    width: MediaQuery.of(context).size.width,
                    child: Card());
              })),
    );
  }

  showNetworkErrorSnackBar1(GlobalKey<ScaffoldState> scaffoldKey) {
    try {
      // bool isConnected;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(days: 1),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.signal_wifi_off,
              color: Colors.white,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: Text(
                  'No internet-------------available',
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
            textColor: Colors.white,
            label: 'RETRY',
            onPressed: () {
              _onRefresh();
            }),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      print("Exception -  base.dart - showNetworkErrorSnackBar1():" +
          e.toString());
    }
  }
}
