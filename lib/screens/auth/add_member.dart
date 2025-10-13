import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/eventsListModel.dart';
import 'package:byyu/models/relationship_model.dart';
import 'package:byyu/widgets/bottom_button.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/controllers/user_profile_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/userModel.dart';

final _formkeySD = GlobalKey<FormState>();

final _formAddMemberKey = GlobalKey<FormState>();

class UserInfoTile extends StatefulWidget {
  String? value;
  Widget? leadingIcon;
  String? heading;
  Function? onPressed;
  final key;

  UserInfoTile(
      {this.heading, this.value, this.leadingIcon, this.onPressed, this.key})
      : super();

  @override
  _UserInfoTileState createState() => _UserInfoTileState(
      heading: heading,
      value: value,
      leadingIcon: leadingIcon,
      onPressed: onPressed,
      key: key);
}

class UserOrdersDashboardBox extends StatefulWidget {
  final String? heading;
  final String? value;

  UserOrdersDashboardBox({this.heading, this.value}) : super();

  @override
  _UserOrdersDashboardBoxState createState() => _UserOrdersDashboardBoxState();
}

class AddMemberScreen extends BaseRoute {
  String? fullName, relation, specialDay, date, month;
  int? memberID;

  AddMemberScreen(
      {a,
      o,
      this.memberID,
      this.fullName,
      this.relation,
      this.specialDay,
      this.date,
      this.month})
      : super(a: a, o: o, r: 'AboutUserScreen');

  @override
  _AddMemberScreenState createState() => _AddMemberScreenState(
      memberID: memberID,
      fullName: fullName,
      relation: relation,
      specialDay: specialDay,
      date: date,
      month: month);
}

class _UserInfoTileState extends State<UserInfoTile> {
  String? value;
  Widget? leadingIcon;
  String? heading;
  Function? onPressed;
  var key;

  _UserInfoTileState(
      {this.heading, this.value, this.leadingIcon, this.onPressed, this.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      key: key,
      onTap: () => onPressed!(),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  leadingIcon ?? Container(),
                  leadingIcon == null ? Container() : SizedBox(width: 8),
                  Text(
                    heading!,
                    style: textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            value == null ? FontWeight.bold : FontWeight.normal,
                        fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 8),
              value == null
                  ? Container()
                  : Text(
                      value!,
                      style: textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
              value == null ? Container() : SizedBox(height: 8),
              Divider(
                thickness: 2.0,
              ),
            ],
          ),
          onPressed == null
              ? Container()
              : Positioned(
                  bottom: 24,
                  right: global.isRTL ? null : 0,
                  left: global.isRTL ? 0 : null,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                ),
        ],
      ),
    );
  }
}

class _UserOrdersDashboardBoxState extends State<UserOrdersDashboardBox> {
  String? value;
  Widget? leadingIcon;
  String? heading;
  Function? onPressed;

  _UserOrdersDashboardBoxState({@required this.heading, this.value});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          heading!,
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value!,
          style: textTheme.titleMedium,
        )
      ],
    );
  }
}

class _AddMemberScreenState extends BaseRouteState {
  bool _isDataLoaded = false;
  GlobalKey<ScaffoldState>? _scaffoldKey1;

  FocusNode _fEvents = new FocusNode();
  List<Celbrations>? _celebEventsList = [];
  List<RelationshipData>? _relationshipModelList = [];
  String? countryCode;
  TextEditingController _fullNameTextController = TextEditingController();
  TextEditingController _othreRelationTxtController = TextEditingController();
  TextEditingController _relationTextController = TextEditingController();
  String? celebrationEventName;
  String? selectedDay, selectedMonth;
  bool boolErrorShow = false;
  String strErrorShow = "";

  String? selectedCelebEvent, relationshipEvent;

  bool _isRecordPending = true;
  bool addButtonClicked = false;
  bool isDaySelected = true;
  bool? _isMoreDataLoaded;

  String? fullName, relation, specialDay, date, month;
  int? memberID;
  bool showRelationOthers = false;
  GlobalKey<ScaffoldState>? _scaffoldKey;

  _AddMemberScreenState(
      {this.memberID,
      this.fullName,
      this.relation,
      this.specialDay,
      this.date,
      this.month})
      : super();

  Widget _loadColumnData(dynamic heading, dynamic value) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: textTheme.titleMedium,
        )
      ],
    );
  }

  String? _validateDropdown(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an option';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: ColorConstants.colorPageBackground,
        key: _scaffoldKey1,
        appBar: AppBar(
            backgroundColor: ColorConstants.appBarColorWhite,
            leadingWidth: 46,
            actions: [],
            leading: BackButton(
              onPressed: () {
                print("Go back");
                Navigator.pop(context);
              },
              color: ColorConstants.appColor,
            ),
            centerTitle: false,
            title: Text(
              fullName != null && fullName!.length > 0
                  ? "Update Special Day"
                  : "Add Special Day",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorConstants.newTextHeadingFooter,
                  fontFamily: fontRailwayRegular,
                  fontWeight: FontWeight.w200),
            )),
        body: Form(
          key: _formAddMemberKey,
          child: Container(
              height: MediaQuery.of(context).size.height,
             
              child: global.currentUser != null && global.currentUser.id != null
                  ? _isDataLoaded
                      ? GetBuilder<UserProfileController>(
                          init: global.userProfileController,
                          builder: (value) => RefreshIndicator(
                                onRefresh: () async {
                                  // global.userProfileController.currentUser =
                                  //     new CurrentUser();
                                  
                                },
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7.0))),
                                          margin: EdgeInsets.only(
                                              top: 0, left: 20, right: 20),
                                          padding: EdgeInsets.only(),
                                          child: MaterialTextField(
                                              style: TextStyle(
                                                  fontFamily: global
                                                      .fontRailwayRegular,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200,
                                                  color:
                                                      ColorConstants.newTextHeadingFooter),
                                              theme: FilledOrOutlinedTextTheme(
                                                radius: 8,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 4),
                                                errorStyle: const TextStyle(
                                                    fontSize: 10,
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight:
                                                        FontWeight.w200),
                                                fillColor: Colors.transparent,
                                                enabledColor: Colors.grey,
                                                focusedColor:
                                                    ColorConstants.newTextHeadingFooter,
                                                floatingLabelStyle:
                                                    const TextStyle(
                                                        color: ColorConstants
                                                            .newTextHeadingFooter),
                                                width: 0.5,
                                                labelStyle: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              ),
                                              controller:
                                                  _fullNameTextController,
                                              labelText: "Full Name*",

                                              keyboardType: TextInputType.name,
                                              onChanged: (val) {
                                                if (addButtonClicked &&
                                                    _formAddMemberKey
                                                        .currentState!
                                                        .validate()) {
                                                  print("Submit Data");
                                                }
                                              },
                                              validator: (value) {
                                                print(value);
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Please enter Full Name  ";
                                                } else {
                                                  return null;
                                                }
                                              }),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: const TextSpan(
                                                  text: 'Relationship*',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontFamily:
                                                          fontRailwayRegular,
                                                      color: ColorConstants
                                                          .newTextHeadingFooter,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: isDaySelected ? 40 : 70,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          decoration: BoxDecoration(
                                              color: ColorConstants.colorPageBackground,
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7.0))),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10, right: 10),
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              color: ColorConstants.colorPageBackground,
                                            ),
                                            child: FormField<String>(
                                              builder: (FormFieldState<String>
                                                  state) {
                                                return DropdownButton<String>(
                                                  menuMaxHeight: 400.0,
                                                  underline: SizedBox(),
                                                  focusNode: _fEvents,
                                                  key: Key('26'),
                                                  hint: Text(
                                                      relation != null &&
                                                              relation!.length >
                                                                  0
                                                          ? "$relation"
                                                          : "Select Relationship",
                                                      style: TextStyle(
                                                          color: relation !=
                                                                      null &&
                                                                  relation!
                                                                          .length >
                                                                      0
                                                              ? const Color.fromRGBO(0, 0, 0, 1)
                                                              : ColorConstants
                                                                  .grey,
                                                          fontSize: 14,
                                                          
                                                          fontFamily:
                                                              fontRailwayRegular)),
                                                  dropdownColor:
                                                      ColorConstants.white,
                                                  iconEnabledColor:
                                                      ColorConstants.appColor,
                                                  isExpanded: true,
                                                  value: relationshipEvent,
                                                  isDense: true,
                                                  onTap: () {
                                                  
                                                  },
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      relationshipEvent =
                                                          newValue;
                                                      print(relationshipEvent);
                                                      if (relationshipEvent!
                                                                  .toLowerCase() ==
                                                              "others" ||
                                                          relationshipEvent!
                                                                  .toLowerCase() ==
                                                              "other") {
                                                        showRelationOthers =
                                                            true;
                                                        setState(() {});
                                                      }else{
                                                        showRelationOthers =
                                                            false;
                                                        setState(() {});
                                                      }
                                                      
                                                    });
                                                  },
                                                  items: _relationshipModelList!
                                                      .map((RelationshipData
                                                          ralationData) {
                                                    return DropdownMenuItem(
                                                      value: ralationData.name
                                                          .toString(),
                                                      child: Text(
                                                        ralationData.name
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                ColorConstants
                                                                    .newTextHeadingFooter,
                                                            fontFamily:
                                                                fontRailwayRegular,
                                                            letterSpacing: 1),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Visibility(
                                            visible:
                                                relationshipEvent == null &&
                                                        addButtonClicked
                                                    ? true
                                                    : false,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  40,
                                              margin: EdgeInsets.only(
                                                  left: 25, top: 5, right: 25),
                                              child: Text(
                                                "Select Relationship",
                                                style: TextStyle(
                                                    color:
                                                        ColorConstants.newTextHeadingFooter,
                                                    fontSize: 10,
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight:
                                                        FontWeight.w200),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        
                                        Visibility(
                                          visible: showRelationOthers,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(7.0))),
                                            margin: EdgeInsets.only(
                                                top: 0, left: 20, right: 20),
                                            padding: EdgeInsets.only(),
                                            child: MaterialTextField(
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w200,
                                                    color: ColorConstants
                                                        .pureBlack),
                                                theme:
                                                    FilledOrOutlinedTextTheme(
                                                  radius: 8,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4,
                                                          vertical: 4),
                                                  errorStyle: const TextStyle(
                                                      fontSize: 10,
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontWeight:
                                                          FontWeight.w200),
                                                  fillColor: Colors.transparent,
                                                  enabledColor: Colors.grey,
                                                  focusedColor:
                                                      ColorConstants.appColor,
                                                  floatingLabelStyle:
                                                      const TextStyle(
                                                          color: ColorConstants
                                                              .appColor),
                                                  width: 0.5,
                                                  labelStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                ),
                                                controller:
                                                    _othreRelationTxtController,
                                                labelText: "Other Relation*",

                                                keyboardType:
                                                    TextInputType.name,
                                                onChanged: (val) {
                                                  if (showRelationOthers) {
                                                    if (addButtonClicked &&
                                                        _formAddMemberKey
                                                            .currentState!
                                                            .validate()) {
                                                      print("Submit Data");
                                                    }
                                                    // relationshipEvent = val;
                                                  }
                                                },
                                                validator: (value) {
                                                  print(value);
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please enter Other Relation";
                                                  } else {
                                                    return null;
                                                  }
                                                }),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: const TextSpan(
                                                  text: 'Special Day*',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontFamily:
                                                          fontRailwayRegular,
                                                      color: ColorConstants
                                                          .newTextHeadingFooter,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: isDaySelected ? 40 : 70,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          decoration: BoxDecoration(
                                              
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7.0))),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10, right: 10),
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              
                                            ),
                                            child: FormField<String>(
                                              builder: (FormFieldState<String>
                                                  state) {
                                                return DropdownButton<String>(
                                                  underline: SizedBox(),
                                                  focusNode: _fEvents,
                                                  key: Key('26'),
                                                  hint: Text(
                                                      specialDay != null &&
                                                              specialDay!
                                                                      .length >
                                                                  0
                                                          ? "${specialDay}"
                                                          : "Select Special Day",
                                                      style: TextStyle(
                                                          color: specialDay !=
                                                                      null &&
                                                                  specialDay!
                                                                          .length >
                                                                      0
                                                              ? ColorConstants
                                                                  .pureBlack
                                                              : ColorConstants
                                                                  .grey,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              fontRailwayRegular)),
                                                  dropdownColor:
                                                      ColorConstants.white,
                                                  iconEnabledColor:
                                                      ColorConstants.pureBlack,
                                                  isExpanded: true,
                                                  value: selectedCelebEvent,
                                                  isDense: true,
                                                  onTap: () {
                                                  },
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedCelebEvent =
                                                          newValue;
                                                      print(selectedCelebEvent);
                                                    });
                                                  },
                                                  items: _celebEventsList!.map(
                                                      (Celbrations eventsData) {
                                                    return DropdownMenuItem(
                                                      value: eventsData
                                                          .celebrationName
                                                          .toString(),
                                                      child: Text(
                                                        eventsData
                                                            .celebrationName
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                ColorConstants
                                                                    .pureBlack,
                                                            fontFamily:
                                                                fontRailwayRegular,
                                                            letterSpacing: 1),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Visibility(
                                            visible:
                                                selectedCelebEvent == null &&
                                                        addButtonClicked
                                                    ? true
                                                    : false,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  40,
                                              margin: EdgeInsets.only(
                                                  left: 25, top: 5, right: 25),
                                              child: Text(
                                                "Select Special Day",
                                                style: TextStyle(
                                                    color:
                                                        ColorConstants.appColor,
                                                    fontSize: 10,
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight:
                                                        FontWeight.w200),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: const TextSpan(
                                                  text: 'Date of Special Day*',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontFamily:
                                                          fontRailwayRegular,
                                                      color: ColorConstants
                                                          .newTextHeadingFooter,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 10),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 8, right: 8),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  DatePickerWidget(
                                                    initialDate: date != null &&
                                                            month != null &&
                                                            date!.length > 0 &&
                                                            month!.length > 0
                                                        ? DateTime(
                                                            DateTime.now().year,
                                                            DateFormat("MMMM")
                                                                .parse(month!)
                                                                .month,
                                                            DateFormat("dd")
                                                                .parse(date!)
                                                                .day)
                                                        : DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now()
                                                                .month,
                                                            DateTime.now().day),
                                                    
                                                    dateFormat: "dd/MMMM",
                                                    locale: DatePicker
                                                        .localeFromString('en'),
                                                    onChange:
                                                        (DateTime newDate, _) {
                                                      setState(() {
                                                        selectedDay = newDate
                                                            .day
                                                            .toString();
                                                        selectedMonth = global
                                                            .allMonths[
                                                                newDate.month -
                                                                    1]
                                                            .toString();
                                                      });
                                                    },
                                                    pickerTheme:
                                                        DateTimePickerTheme(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      itemTextStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily: global
                                                              .fontRailwayRegular,
                                                          fontWeight:
                                                              FontWeight.w200),
                                                      dividerColor:
                                                          ColorConstants.newTextHeadingFooter,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        SizedBox(
                                          height: 35,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Container(
                                            height: 35,
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.1),
                                            decoration: BoxDecoration(
                                                color: ColorConstants.appColor,
                                                border: Border.all(
                                                    color:
                                                        ColorConstants.appColor,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: BottomButton(
                                                color: ColorConstants.appColor,
                                                child: Text(
                                                  fullName != null &&
                                                          fullName!.length > 0
                                                      ? "UPDATE SPECIAL DAY"
                                                      : "ADD SPECIAL DAY",

                                                  style: TextStyle(
                                                      fontFamily:
                                                          fontRalewayMedium,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color:
                                                          ColorConstants.white,
                                                      letterSpacing: 1),
                                                ),
                                                loadingState: false,
                                                disabledState: true,
                                                onPressed: () {
                                                  addButtonClicked = true;
                                                  setState(() {});
                                                  if (_formAddMemberKey
                                                      .currentState!
                                                      .validate()) {
                                                    print("Submit Data");
                                                    if (fullName != null) {
                                                      _callUpdateMemberAPI();
                                                    } else {
                                                      _callAddMembersAPI();
                                                    }
                                                  }
                                                }),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Visibility(
                                              visible: boolErrorShow,
                                              child: Text(
                                                strErrorShow,
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12,
                                                    color: ColorConstants
                                                        .newTextHeadingFooter),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                      : Center(child: new CircularProgressIndicator())
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Text(
                          global.pleaseLogin,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: global.fontMontserratLight,
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: ColorConstants.grey),
                        ),
                      ),
                    )),
        ));
  }

  _callAddMembersAPI() async {
    try {
      showOnlyLoaderDialog();
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (selectedDay == null && selectedMonth == null) {
          selectedDay = DateTime.now().day.toString();
          selectedMonth = DateFormat("MMMM").format(DateTime.now());
        }
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          if (selectedDay == null) {
            hideLoader();
            
          } else {
            await apiHelper
                .addMember(
                    _fullNameTextController.text,
                    relationshipEvent !=null && relationshipEvent!.toLowerCase()=="others"?_othreRelationTxtController.text:relationshipEvent!,
                    selectedCelebEvent!,
                    selectedDay!,
                    selectedMonth!,
                    "0000")
                .then((result) async {
              if (result != null) {
                AddMember _tList = result.data;
                if (_tList.status == "1") {
                  _isRecordPending = false;
                  boolErrorShow = false;
                  showSnackBarWithDuration(
                    key: _scaffoldKey1,
                    snackBarMessage: result.message.toString(),
                  );
                  setState(() {
                    hideLoader();
                    _isMoreDataLoaded = false;
                    Navigator.of(context).pop("true");
                  });
                } else {
                  hideLoader();
                  boolErrorShow = true;
                  strErrorShow = result.message.toString();
                  
                }
              }
            });
          }
        }
      } else {
        hideLoader();
        showNetworkErrorSnackBar1(_scaffoldKey!);
      }
    } catch (e) {
      hideLoader();
      print("Exception - all_categories_screen.dart - _getEventsList()1:" +
          e.toString());
    }
  }

  _callUpdateMemberAPI() async {
    try {
      showOnlyLoaderDialog();
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });

          await apiHelper
              .updateMember(
            memberID!,
            _fullNameTextController.text,
            relationshipEvent !=null && relationshipEvent!.toLowerCase()=="others"?_othreRelationTxtController.text:relationshipEvent!,
            selectedCelebEvent!,
            selectedDay!,
            selectedMonth!,
          )
              .then((result) async {
            if (result != null) {
              AddMember _tList = result.data;
              if (_tList.status == "1") {
                _isRecordPending = false;
                showSnackBarWithDuration(
                  key: _scaffoldKey1,
                  snackBarMessage: result.message.toString(),
                );
                setState(() {
                  hideLoader();
                  _isMoreDataLoaded = false;
                  Navigator.of(context).pop("true");
                });
              } else {
                hideLoader();

                showSnackBarWithDuration(
                  key: _scaffoldKey1,
                  snackBarMessage: result.message.toString(),
                );
                Navigator.of(context).pop("false");
              }
            }
          });
        }
      } else {
        hideLoader();
        showNetworkErrorSnackBar1(_scaffoldKey!);
      }
    } catch (e) {
      hideLoader();
      print("Exception - all_categories_screen.dart - _getEventsList():" +
          e.toString());
    }
  }

  _getCelebrationsList() async {
    try {
      
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });

          await apiHelper.getCelebrationsList().then((result) async {
            if (result != null) {
              List<Celbrations> _tList = result.data;
              if (_tList.isEmpty) {
                _isRecordPending = false;
              }

              _celebEventsList!.addAll(_tList);

              setState(() {
                _isMoreDataLoaded = false;
              });
            }
          });
        }
      } else {
        showNetworkErrorSnackBar1(_scaffoldKey!);
      }
    } catch (e) {
      print("Exception - all_categories_screen.dart - _getEventsList():" +
          e.toString());
    }
  }
  showOnlyLoaderDialog1() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(child: new CircularProgressIndicator()),
        );
      },
    );
  }
  void hideLoader1() {
    Navigator.pop(context);
  }
  _getRelationshipList() async {
    try {
      // showOnlyLoaderDialog1();
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });

          await apiHelper.getRelationList().then((result) async {
            if (result != null) {
              List<RelationshipData> _tList = result.data;
              if (_tList.isEmpty) {
                _isRecordPending = false;
              }
              bool isFromList = false;
              int index = 0;
              if (relation != null && _tList != null && _tList.length > 0) {
                for (int i = 0; i < _tList.length; i++) {
                  if (_tList![i].name!.toString() == relationshipEvent) {
                    isFromList = true;
                    index = i;
                  }
                }
              }
              if (isFromList) {
                relation = _tList[index].name;
                relationshipEvent = _tList[index].name;
                print("Hello1");
                
              } else {

                if(relationshipEvent!=null && relationshipEvent!.length>0){

                _othreRelationTxtController.text=relationshipEvent!;
                relation = "Others";
                relationshipEvent = "Others";
                showRelationOthers =true;
                print("hello2");
                }else{

                  print("hello 3");
                }
              }
              _relationshipModelList!.addAll(_tList);
              // hideLoader1();
              setState(() {
                _isMoreDataLoaded = false;
              });
            }
          });
        }
      } else {
        // hideLoader1();
        showNetworkErrorSnackBar1(_scaffoldKey!);
      }
    } catch (e) {
      // hideLoader1();
      print("Exception - all_categories_screen.dart - _getRelationshipList():" +
          e.toString());
    }
  }

  showNetworkErrorSnackBar1(GlobalKey<ScaffoldState> scaffoldKey) {
    try {
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
                  'No internet available',
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
              ;
            }),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      print("Exception -  base.dart - showNetworkErrorSnackBar1():" +
          e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      _isRecordPending = true;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - all_categories_screen.dart - _onRefresh():" +
          e.toString());
    }
  }

  _init() async {
    try {
      await _getCelebrationsList();
      await _getRelationshipList();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - add_member_screen.dart - _init():" + e.toString());
    }
  }

  String allWordsCapitilize(String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  @override
  void initState() {
    super.initState();
    if (global.currentUser.id != null) {
      print("addmember----------> InitState");
      _isDataLoaded = false;
      _fullNameTextController.text = fullName ?? "";
      selectedCelebEvent = specialDay;
      relationshipEvent = relation;
      selectedDay = date;
      selectedMonth = month;

      _init();
    }
  }

  _shimmer() {
    try {
      return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Card()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Card()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Card()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Card()),
                ),
              ],
            ),
          ));
    } catch (e) {
      print("Exception - UserProfileScreen.dart - _shimmer():" + e.toString());
    }
  }
}
