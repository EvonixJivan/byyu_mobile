import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/screens/address/add_address_screen.dart';
import 'package:byyu/utils/navigation_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:byyu/models/addressModel.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'dart:developer' as logDev;
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:google_maps_webservice/places.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationScreen extends BaseRoute {
  final int? screenId;
  CartController? cartController;
  final String? isHomeSelected;
  final double? latSelected;
  final double? lngSelected;
  final String? societyName;
  final Address1? address;
  final double? societyLat, societyLng;
  final double? lat, lng;
  final String? fromWhere;
  final bool? isEditButtonClicked;
  bool? fromProfile;
  int? isHOmeOfficePresent = 0;
  bool? isHomePresent;
  bool? isOfficePresent;

  LocationScreen(
      {a,
      o,
      this.screenId,
      this.isHomeSelected,
      this.latSelected,
      this.lngSelected,
      this.societyName,
      this.address,
      this.societyLat,
      isHomePresent,
      isOfficePresent,
      this.societyLng,
      this.cartController,
      this.lat,
      this.lng,
      this.fromWhere,
      this.isHOmeOfficePresent,
      this.fromProfile,
      this.isEditButtonClicked})
      : super(a: a, o: o, r: 'LocationScreen');

  @override
  _LocationScreenState createState() => new _LocationScreenState(
      screenId: screenId,
      isHomeSelected: isHomeSelected,
      latSelected: latSelected,
      lngSelected: lngSelected,
      societyName: societyName,
      societyLat: societyLat,
      societyLng: societyLng,
      cartController: cartController,
      address: address,
      lat: lat,
      lng: lng,
      isHomePresent: isHomePresent,
      isOfficePresent: isOfficePresent,
      fromProfile: fromProfile,
      isHOmeOfficePresent: isHOmeOfficePresent,
      fromWhere: fromWhere,
      isEditButtonClicked: isEditButtonClicked);
}

class _LocationScreenState extends BaseRouteState {
  int? screenId;
  String? isHomeSelected;
  double? latSelected;
  double? lngSelected;
  String? societyName;
  Address1? address;
  double? lat, lng;
  String? fromWhere;
  double? societyLat, societyLng;
  CartController? cartController;
  bool? isEditButtonClicked;
  int? isHOmeOfficePresent = 0;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;
  Set<Polygon> _polygone = HashSet<Polygon>();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  double? _lat; //= 25.2048;
  double? _lng; //= 55.2708;
  TextEditingController _cSearch = new TextEditingController();
  bool isHomePresent = false;
  bool isOfficePresent = false;
  bool isInselectedArea = true;

  String location = 'Null, Press Button';


  FocusNode _fSearch = new FocusNode();
  bool _isDataLoaded = false;
  bool _isShowConfirmLocationWidget = false;
  Placemark? setPlace;
  bool? fromProfile;
  final Permission _permission = Permission.location;

  _LocationScreenState(
      {this.screenId,
      this.isHomeSelected,
      this.latSelected,
      this.lngSelected,
      this.societyName,
      this.address,
      this.societyLat,
      this.societyLng,
      this.lat,
      isHomePresent,
      isOfficePresent,
      this.cartController,
      this.lng,
      this.isHOmeOfficePresent,
      this.fromWhere,
      this.fromProfile,
      this.isEditButtonClicked})
      : super();
  GlobalKey<ScaffoldState>? _scaffoldKey;
  int percentValue = 4;

  get polygonPoins => null;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  LatLng? onCameraMoveEndLatLng;
  BitmapDescriptor? customIcon;
  bool isAreaServiceble = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.white,
      child: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return false;
          },
          child: _isDataLoaded
              ? Scaffold(
                  body:
                      Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: GoogleMap(
                                padding: EdgeInsets.only(
                                    top: Platform.isAndroid ? 100 : 0),
                                markers: Set<Marker>.of(_markers.values),
                                mapType: MapType.terrain,
                                onMapCreated:
                                    (GoogleMapController googlemapcontroller) {
                                  mapController = googlemapcontroller;
                                  setState(() {});
                                },
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(lat != null ? lat! : _lat!,
                                      lng != null ? lng! : _lng!),

                                  zoom: 15.0,
                                ),
                                myLocationEnabled: true,
                                // onCameraMove: (CameraPosition position) async {
                                //   onCameraMoveEndLatLng =
                                //       await pickCameraPositionOnMap(position);
                                //   // print('g1 ---->>>${onCameraMoveEndLatLng}');
                                // },
                                onCameraMove: _onCameraMove,
                                onCameraIdle: _getPinnedAddress,
                                myLocationButtonEnabled: true,
                                // initialCameraPosition: CameraPosition(
                                //   target: LatLng(latSelected!, lngSelected!),
                                //   zoom: 17.0,
                                // ),
                              )),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 5, left: 8, right: 8),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                  child: _isShowConfirmLocationWidget
                                      ? _setCurrentLocationWidget()
                                      : Container(
                                          height: 150,
                                          child: isAreaServiceble
                                              ? Container()
                                              : Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
                                                    child: Text(
                                                      "This location is out of selected area range. Kindly select other area.",
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                        ))),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 50),
                          child: IconButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: ColorConstants.pureBlack,
                              size: 25,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 50, right: 20),
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: global.textGrey, width: 0.1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(70),
                              ),
                              color: global.searchBox,
                            ),
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              autofocus: false,
                              cursorColor: Color(0xFFFA692C),
                              enabled: true,
                              readOnly: true,
                              style: Theme.of(context).textTheme.subtitle1,
                              controller: _cSearch,
                              focusNode: _fSearch,
                              onFieldSubmitted: (text) async {},
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 8),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    color: ColorConstants.allIconsBlack45,
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.search,
                                      color: ColorConstants.allIconsBlack45,
                                    ),
                                  ),
                                  hintStyle:
                                      Theme.of(context).textTheme.subtitle1,
                                  hintText: "Search"
                                  ),
                              onTap: () async {
                                _handlePressedButton();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 180,
                      child: Container(
                        padding: EdgeInsets.all(Platform.isIOS ? 188 : 178),

                        width: 10,
                        height: 10,
                        child: const Icon(
                          Icons.location_pin,
                          size: 35.0,
                          color: ColorConstants.appColor,
                        ),
                      ),
                    ),
                  ],
                )
                  )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }

  void _onCameraMove(CameraPosition position) {
    onCameraMoveEndLatLng = position.target;
    print("latitude: ${onCameraMoveEndLatLng!.latitude}");
    print("longitude: ${onCameraMoveEndLatLng!.longitude}");
  }

  void _getPinnedAddress() async {
    print("Nikhil from edit lng${lng}");
    print("Nikhil from edit latitude${lat}");
    print('G1-------11>${onCameraMoveEndLatLng}');
    List<Placemark> placemarks;
    if (onCameraMoveEndLatLng == null ||
        onCameraMoveEndLatLng!.latitude == null &&
            onCameraMoveEndLatLng == null ||
        onCameraMoveEndLatLng!.longitude == null) {
      if (lat != null && lng != null) {
        placemarks = await placemarkFromCoordinates(lat!, lng!);
      } else {
        placemarks = await placemarkFromCoordinates(_lat!, _lng!);
      }
    } else {
      placemarks = await placemarkFromCoordinates(
          onCameraMoveEndLatLng!.latitude, onCameraMoveEndLatLng!.longitude);
    }
   
    _lat =
        onCameraMoveEndLatLng == null || onCameraMoveEndLatLng!.latitude == null
            ? lat != null
                ? lat
                : _lat
            : onCameraMoveEndLatLng!.latitude;
    _lng =
        onCameraMoveEndLatLng == null || onCameraMoveEndLatLng!.latitude == null
            ? lng != null
                ? lng
                : _lng
            : onCameraMoveEndLatLng!.latitude;
    setPlace = placemarks.first;

    print('G1-------11>${setPlace.toString()}');
    print("Nikhil--------j--- ${setPlace!.name}");
    setState(() {});

    isAreaServiceble = true;

    _isShowConfirmLocationWidget = true;
  }

  Future<void> updateAddress(LatLng point) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(point.latitude, point.longitude, localeIdentifier: 'en_US');
    setPlace = placemarks[placemarks.length - 1];
    print("G1---->location");
    _isShowConfirmLocationWidget = true;
    societyName = '';
    print('g1--->${setPlace}');
    setState(() {});
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    logDev.log(placemarks.toString(), name: "place");
    Placemark place = placemarks[0];
    
    setState(() {});
  }

  double calculateDistance(selectedlat, selectedlng) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((selectedlat - latSelected) * p) / 2 +
        c(latSelected! * p) *
            c(selectedlat * p) *
            (1 - c((selectedlng - lngSelected) * p)) /
            2;
    print("back screen ${latSelected} & ${lngSelected}");
    print(" google map1 ${selectedlat} & ${selectedlng}");

    // print( lngSelected);

    // return 12742 * asin(sqrt(a)); // in kelometer
    return 1000 * 12742 * asin(sqrt(a)); //in meters
  }

  @override
  void dispose() {
    super.dispose();
  }

  Set<Circle>? circles;

  @override
  void initState() {
    _init();
    print("isHOmeOfficePresent initstate location screen");
    print(isHomePresent);
    print(isOfficePresent);
    isEditButtonClicked = isEditButtonClicked;
    super.initState();
  }

  _updateLocation() async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition _location;

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(_lat!, _lng!),
        zoom: 17.0,
      ),
    ));
    _location = CameraPosition(
      target: LatLng(_lat!, _lng!),
      zoom: 17,
    );
    print("Nikhil-----${location}");

    setState(() {});
  }

  PermissionStatus _permissionStatus = PermissionStatus.denied;

  _init() async {
    final status = await _permission.request();

    setState(() async {
      print(status);
      _permissionStatus = status;
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        _lat = position.latitude;
        _lng = position.longitude;

        print('markar update');
        print('sahil lat lng: ${_lat.toString()}, ${_lng.toString()}');
        Future.delayed(Duration(milliseconds: 50), () {
          _isDataLoaded = true;
          isAreaServiceble = true;
          _updateLocation();
          _getPinnedAddress();
        });

      } catch (e) {
        _lat = 25.2048;
        _lng = 55.2708;
        _isDataLoaded = true;

        print("Exception - location_screen.dart - _init():" + e.toString());
      }
      
    });
  }

  _setCurrentLocationWidget() {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select delivery location",
                style: TextStyle(
                    fontFamily: fontMetropolisRegular,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorConstants
                        .pureBlack) //Theme.of(context).textTheme.subtitle1,
                ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    size: 20.0,
                    color: ColorConstants.appColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      setPlace == null && setPlace!.name == null
                          ? ""
                          : "${setPlace!.name!.trim()}",
                      style: TextStyle(
                          fontFamily: fontMetropolisRegular,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.pureBlack,
                          letterSpacing: 1),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    //"Full Address",
                    setPlace!.street == null
                        ? ""
                        : "${setPlace!.street!.trim()}",
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 10,
                        fontFamily: fontMetropolisRegular,
                        color: ColorConstants.pureBlack,
                        fontWeight: FontWeight.normal),
                  )),
            ),
            isEditButtonClicked == true
                ? Padding(
                    padding: EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    MediaQuery.of(context).viewPadding.bottom, // Prevents bottom overlap
                  ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.appColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "CONFIRM LOCATION",
                            style: TextStyle(
                                fontFamily: fontMetropolisRegular,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: ColorConstants.white,
                                letterSpacing: 1),
                            // '${AppLocalizations.of(context).btn_confirm_location}'
                          ),
                        ),
                        onPressed: () async {
                          if (setPlace!.street!.trim().length < 0) {
                            onCameraMoveEndLatLng!.latitude !=
                                onCameraMoveEndLatLng!.latitude + 0.1;
                            onCameraMoveEndLatLng!.longitude !=
                                onCameraMoveEndLatLng!.longitude + 0.1;
                          } else {
                            if (setPlace!.country!
                                    .toLowerCase()
                                    .contains("dubai") ||
                                setPlace!.locality!
                                    .toLowerCase()
                                    .contains("dubai") ||
                                setPlace!.locality!
                                    .toLowerCase()
                                    .contains(global.arabicDubai) ||
                                setPlace!.administrativeArea!
                                    .toLowerCase()
                                    .contains("dubai") ||
                                setPlace!.administrativeArea!
                                    .toLowerCase()
                                    .contains(global.arabicDubai) ||
                                setPlace!.name!
                                    .toLowerCase()
                                    .contains("dubai") ||
                                setPlace!.name!
                                    .toLowerCase()
                                    .contains(global.arabicDubai) ||
                                setPlace!.country!
                                    .toLowerCase()
                                    .contains(global.arabicDubai) ||
                                setPlace!.street!
                                    .toLowerCase()
                                    .contains("dubai") ||
                                setPlace!.street
                                    .toString()
                                    .toLowerCase()
                                    .contains(global.arabicDubai)) {
                              Navigator.of(context).push(
                                NavigationUtils.createAnimatedRoute(
                                    2.0,
                                    AddAddressScreen(
                                      address!,
                                      a: widget.analytics,
                                      o: widget.observer,
                                      screenId: 0,
                                      fromProfile: fromProfile,
                                      isHOmeOfficePresent: isHOmeOfficePresent,

                                      isEditButtonClicked: true,
                                      // fromWhere: "editbutton",
                                      setPlace: setPlace,
                                      cartController:
                                          fromProfile! ? null : cartController,
                                      lat: onCameraMoveEndLatLng == null
                                          ? _lat
                                          : onCameraMoveEndLatLng!.latitude ==
                                                  null
                                              ? _lat
                                              : onCameraMoveEndLatLng!.latitude,

                                      lng: onCameraMoveEndLatLng == null
                                          ? _lng
                                          : onCameraMoveEndLatLng!.longitude ==
                                                  null
                                              ? _lng
                                              : onCameraMoveEndLatLng!
                                                  .longitude,
                                      // selectedScreen: "checkout",
                                    )),
                              );
                              setState(() {});
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "Currently we don't provide deliveries to this location", // message
                                toastLength: Toast.LENGTH_SHORT, // length
                                gravity: ToastGravity.CENTER, // location
                                // duration
                              );
                            }
                          }
                        },
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    MediaQuery.of(context).viewPadding.bottom-10, // Prevents bottom overlap
                  ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.appColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "CONFIRM LOCATION",
                            style: TextStyle(
                                fontFamily: fontMontserratMedium,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: ColorConstants.white,
                                letterSpacing: 1),
                            // '${AppLocalizations.of(context).btn_confirm_location}'
                          ),
                        ),
                        onPressed: () async {
                          print(onCameraMoveEndLatLng);
                          if (setPlace!.country!
                                  .toLowerCase()
                                  .contains("dubai") ||
                              setPlace!.locality!
                                  .toLowerCase()
                                  .contains("dubai") ||
                              setPlace!.administrativeArea!
                                  .toLowerCase()
                                  .contains("dubai") ||
                              setPlace!.name!.toLowerCase().contains("dubai") ||
                              setPlace!.name!
                                  .toLowerCase()
                                  .contains(global.arabicDubai) ||
                              setPlace!.country!
                                  .toLowerCase()
                                  .contains(global.arabicDubai) ||
                              setPlace!.street!
                                  .toLowerCase()
                                  .contains("dubai") ||
                              setPlace!.street
                                  .toString()
                                  .toLowerCase()
                                  .contains(global.arabicDubai)) {
                            Navigator.of(context).push(
                              NavigationUtils.createAnimatedRoute(
                                  2.0,
                                  AddAddressScreen(
                                    new Address1(),
                                    a: widget.analytics,
                                    o: widget.observer,
                                    screenId: 0,
                                    isEditButtonClicked: false,
                                    //fromWhere: "editbutton",
                                    setPlace: setPlace,
                                    fromProfile: fromProfile,
                                    cartController: cartController,
                                    isHOmeOfficePresent: isHOmeOfficePresent,

                                    lat: onCameraMoveEndLatLng == null
                                        ? _lat
                                        : onCameraMoveEndLatLng!.latitude ==
                                                null
                                            ? _lat
                                            : onCameraMoveEndLatLng!.latitude,

                                    lng: onCameraMoveEndLatLng == null
                                        ? _lng
                                        : onCameraMoveEndLatLng!.longitude ==
                                                null
                                            ? _lng
                                            : onCameraMoveEndLatLng!.longitude,
                                    // selectedScreen: "checkout",
                                  )),
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg:
                                  "Currently we don't provide deliveries to this location", // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.CENTER, // location
                              // duration
                            );
                          }
                        },
                      ),
                    ),
                  )
          ],
        ));
  }

  void showToastMessage(String s) {
    Fluttertoast.showToast(
        msg: s,
        //message to show toast
        toastLength: Toast.LENGTH_LONG,
        //duration for message to show
        gravity: ToastGravity.CENTER,
        //where you want to show, top, bottom
        timeInSecForIosWeb: 1,
        //for iOS only
        //backgroundColor: Colors.red, //background Color for message
        textColor: Colors.white,
        //message text color
        fontSize: 16.0 //message font size
        );
  }

  final Mode _mode = Mode.overlay;

  Future<void> _handlePressedButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: global.googleMapAPIKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        logo: Text(""),
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
          hintText: 'Search',
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
        ),
        components: [] //Component(Component.country, "ae")
        );
    print(p);
    displayPrediction(p!);
  }

  void onError(PlacesAutocompleteResponse response) {
    print(response.errorMessage);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: global.googleMapAPIKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());
    print(places.toString());
    var pppp = p.description;
    print('displayPrediction----:${pppp}');

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    print('QA123454321-->${p.placeId}');
    print("QA12321--> ${detail}");

    // setPlaceCountry = detail.result.;
    var setAddress = '${detail.result.formattedAddress}';
    _cSearch.text = setAddress;

    latSelected = detail.result.geometry!.location.lat;
    lngSelected = detail.result.geometry!.location.lng;

    print("Q12345567889");

    Set<Marker> markerList = {};

    markerList.clear();
    markerList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(latSelected!, lngSelected!),
        infoWindow: InfoWindow(title: detail.result.name)));
    setState(() {});

    mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(latSelected!, lngSelected!), 15.0));
  }
}
