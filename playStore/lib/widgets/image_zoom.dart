import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:flutter/material.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

class ZoomImage extends BaseRoute {
  List<String>? productImages;
  ZoomImage({a, o, this.productImages}) : super(a: a, o: o, r: 'ZoomImage');
  @override
  ZoomImageState createState() => new ZoomImageState(productImages!);
}

class ZoomImageState extends BaseRouteState {
  List<String> productImages = [];
  int selectedImageIndex = 0;
  ZoomImageState(this.productImages) : super();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.white,
        automaticallyImplyLeading: false, // use for back button remover
        actions: [
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
                //Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).primaryColor,
                  //color: Colors.black, this is working Aayush by static color
                ),
              ))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Zoom(
          child: Image.network(
            productImages[selectedImageIndex],
            cacheWidth: 360,
            fit: BoxFit.contain,
          ),
          clipBehavior: true,
        ),

        // Container(
        //                               width: MediaQuery.of(context).size.width,
        //                               child: BannerImage(
        //                                 // autoPlay: false,
        //                                 // timerDuration:
        //                                 //     Duration(seconds: 8),
        //                                 padding:
        //                                     EdgeInsets.only(left: 3, right: 3),
        //                                 aspectRatio: 0.9,
        //                                 borderRadius: BorderRadius.circular(1),
        //                                 itemLength: productImages.length,
        //                                 imageUrlList: productImages,
                                        
        //                                     withOutIndicator: true,
        //                                 fit: BoxFit.contain,
        //                                 errorBuilder:
        //                                     (context, child, loadingProgress) {
        //                                   return SizedBox(
        //                                     child: Center(
        //                                         child:
        //                                             CircularProgressIndicator()),
        //                                     height: 30.0,
        //                                     width: 30.0,
        //                                   );
        //                                 },
        //                               ),
        //                             ),
         
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 15, top: 8),
        height: 80,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                  itemCount: productImages.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        selectedImageIndex = index;
                        setState(() {});
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedImageIndex == index
                                  ? ColorConstants.appColor
                                  : ColorConstants.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 6,
                            height: MediaQuery.of(context).size.width / 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                productImages[index],
                                cacheWidth: 360,
                                fit: BoxFit.contain,
                                width: MediaQuery.of(context).size.width / 2.1,
                                height: MediaQuery.of(context).size.height,
                              ),
                            ),
                          )),
                    );
                  })),
        ),
      ),
    );
  }
}
