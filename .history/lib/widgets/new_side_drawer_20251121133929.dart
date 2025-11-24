import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart' as apiHelper;
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/eventsListModel.dart';
import 'package:byyu/screens/auth/add_member.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/auth/user_members_list_sccreen.dart';
import 'package:byyu/screens/product/search_results_screen.dart';
import 'package:byyu/screens/product/sub_categories_screen%20copy.dart';
import 'package:byyu/screens/product/sub_categories_screen.dart';
import 'package:byyu/utils/navigation_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewSideDrawer extends StatefulWidget {
  final VoidCallback? onClose;
  final ValueChanged<String>? onSearch;
  final ValueChanged<int>? onCategoryTap;
  final ValueChanged<int>? onChipTap;
  final Object? analytics;
  final Object? observer;

  const NewSideDrawer({
    Key? key,
    this.onClose,
    this.onSearch,
    this.onCategoryTap,
    this.onChipTap,
    this.analytics,
    this.observer,
  }) : super(key: key);

  @override
  State<NewSideDrawer> createState() => _NewSideDrawerState();
}

class _NewSideDrawerState extends State<NewSideDrawer> {
  // main state flags
  bool categoriesScreen = false;
  bool filterCategoryScreen = false;
  bool filterSubCategoryScreen = false;
  String SelectedSubCategoryName = "";

  // bool flowersGiftsScreen = false;
  // bool flowersPlantsScreen = false;
  double _ageSliderValue = 40.0;
  int _minAge = 30;
  int _maxAge = 70;

  int selectedCategoryIndex = 0;

  final TextEditingController _searchController = TextEditingController();

//Celebrate section data from API
  List<Map<String, dynamic>> celebrateEvents = [];
  List<Map<String, dynamic>> filterCategoryItems = [];
  List<Map<String, dynamic>> filterSubCategoryItems = [];
  List<Map<String, dynamic>> recipientsList = [];

  bool isLoadingCelebrate = false;
  String? celebrateError;

  final List<_CategoryItem> _categories = [
    _CategoryItem(title: 'Celebrate', imageUrl: "assets/images/N1.png"),
    _CategoryItem(title: 'Recipients', imageUrl: "assets/images/N2.png"),
    _CategoryItem(title: 'Express Delivery', imageUrl: "assets/images/N3.png"),
  ];

  // final List<_ChipItem> _chips = [
  //   _ChipItem(title: 'Flowers & Gifts', iconUrl: "assets/images/F1.png"),
  //   _ChipItem(title: 'Flowers & Plants', iconUrl: "assets/images/F2.png"),
  // ];

  final Map<String, List<_SubCategoryItem>> categorySubMap = {
    // 'Celebrate': [
    //   _SubCategoryItem(
    //       title: 'National Day', icon: 'assets/images/I_national.png'),
    //   _SubCategoryItem(title: 'Birthday', icon: 'assets/images/I_birthday.png'),
    //   _SubCategoryItem(
    //       title: 'Anniversary', icon: 'assets/images/I_anniversary.png'),
    //   _SubCategoryItem(
    //       title: 'Gift For Her', icon: 'assets/images/I_gift_her.png'),
    //   _SubCategoryItem(
    //       title: 'Gift For Him', icon: 'assets/images/I_gift_him.png'),
    //   _SubCategoryItem(
    //       title: 'Personalised', icon: 'assets/images/I_personalised.png'),
    //   _SubCategoryItem(
    //       title: 'Graduation Day', icon: 'assets/images/I_graduation.png'),
    // ],
    'Recipients': [
      _SubCategoryItem(title: 'For Mom', icon: 'assets/images/I_mom.png'),
      _SubCategoryItem(title: 'For Dad', icon: 'assets/images/I_dad.png'),
      _SubCategoryItem(title: 'For Kids', icon: 'assets/images/I_kids.png'),
    ],
    'Express Delivery': [
      _SubCategoryItem(title: 'Same Day', icon: 'assets/images/I_sameday.png'),
      _SubCategoryItem(title: 'Next Day', icon: 'assets/images/I_nextday.png'),
    ],
  };
  @override
  void initState() {
    filltercatgory();

    print("RELATIONSHIP DATA?>>>>>>>>>>>>>>>>>>>>>");
    fetchFilterCategories();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchSubmitted(String text) {
    widget.onSearch?.call(text);
  }

  List<_SubCategoryItem> get _currentSubList {
    final key = _categories[selectedCategoryIndex].title;
    return categorySubMap[key] ?? [];
  }

  // --- Category Detail Screen (reused for Celebrate/Recipients/Express Delivery) ---
  Widget _buildCategoryDetailScreen(double drawerWidth) {
    final categoryTitle = _categories[selectedCategoryIndex].title;

    // Build the celebrate grid
    Widget celebrateGrid() {
      if (celebrateEvents.isEmpty) {
        return const Center(
            child: Text("No events found", style: TextStyle(fontSize: 14)));
      }

      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: celebrateEvents.length,
        itemBuilder: (context, index) {
          final item = celebrateEvents[index];
          return InkWell(
            onTap: () {
              global.homeSelectedCatID = item["id"];
              global.isEventProduct = true;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategoriesScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    showCategories: true,
                    screenHeading: item["event_name"],
                    categoryId: item["id"],
                    isEventProducts: true,
                    isSubcategory: false,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.network(
                    "${global.catImageBaseUrl}${item["event_image"]}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.transparent,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item["event_name"] ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    // Build recipients grid
    Widget recipientsGrid() {
      if (recipientsList.isEmpty) {
        return const Center(
            child: Text("No recipients found", style: TextStyle(fontSize: 14)));
      }

      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: recipientsList.length,
        itemBuilder: (context, index) {
          final item = recipientsList[index];
          final icon = (item["icon"] ?? "").toString();

          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategoriesScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    showCategories: true,
                    screenHeading: "recipients",
                    categoryId: null,
                    isEventProducts: true,
                    isSubcategory: false,
                    minAge: _minAge,
                    maxAge: _maxAge,
                    recipientId: null,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: icon.toLowerCase().endsWith(".svg")
                      ? SvgPicture.network(
                          "https://byyu.com/admin$icon",
                          fit: BoxFit.contain,
                          placeholderBuilder: (_) => const Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        )
                      : Image.network(
                          "https://byyu.com/admin$icon",
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.transparent,
                            child:
                                const Icon(Icons.image_not_supported, size: 20),
                          ),
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  item["relationship_name"] ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    // Decide which main child to show based on selectedCategoryIndex
    Widget mainChild;
    if (selectedCategoryIndex == 0) {
      mainChild = celebrateGrid();
    } else if (selectedCategoryIndex == 1) {
      mainChild = recipientsGrid();
    } else {
      mainChild = const Center(
        child: Text(
          "Express Delivery Coming Soon",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: ColorConstants.newAppColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with back icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categoryTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: ColorConstants.newAppColor,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: ColorConstants.newAppColor,
              onPressed: () {
                setState(() {
                  _minAge = 30;
                  _maxAge = 70;
                  categoriesScreen = false;
                });
              },
            ),
          ],
        ),

        const SizedBox(height: 10),
        Divider(height: 0.5, color: ColorConstants.greyfaint),

        // Age range controls only for recipients (index == 1)
        if (selectedCategoryIndex == 1) ...[
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Age",
                style: TextStyle(
                  color: ColorConstants.newAppColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Slider (use a constrained width)
              SizedBox(
                height: 40,
                width: 270,
                child: RangeSlider(
                  values: RangeValues(
                    _minAge.toDouble(),
                    _maxAge.toDouble(),
                  ),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  activeColor: ColorConstants.newAppColor,
                  inactiveColor: Colors.brown.shade100,
                  labels: RangeLabels(
                    '${_minAge.round()}',
                    '${_maxAge.round()}',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      // keep doubles but snap to whole numbers
                      _minAge = values.start.round();
                      _maxAge = values.end.round();
                    });
                    // debug prints (will show 31.0 etc). Use .round() when printing if you need integers.
                    print("Selected Min Age = ${_minAge.round()}");
                    print("Selected Max Age = ${_maxAge.round()}");
                  },
                ),
              ),
              Text(
                '${_minAge.round()} - ${_maxAge.round()}',
                style: const TextStyle(
                  fontFamily: fontRalewayMedium,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.newAppColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],

        const SizedBox(height: 20),

        // Main grid or message
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: mainChild,
        ),
      ],
    );
  }

  // --- Flowers & Gifts screen (now GridView with crossAxisCount: 2) ---
  Widget _filterSubCategoryScreen() {
    // final List<_SubCategoryItem> giftsList = [
    //   _SubCategoryItem(
    //       title: "Baked with Love", icon: "assets/images/dryfruits.png"),
    //   _SubCategoryItem(
    //       title: "Luxury Blooms", icon: "assets/images/flowers.png"),
    //   _SubCategoryItem(
    //       title: "Sweet Moments", icon: "assets/images/chocolate.png"),
    // ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              SelectedSubCategoryName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: ColorConstants.newAppColor,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: ColorConstants.newAppColor,
              onPressed: () {
                setState(() {
                  filterSubCategoryScreen = false;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Divider(height: 0.5, color: ColorConstants.greyfaint),
        const SizedBox(height: 20),

        // Grid with 2 columns
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.6, // wide pill-like boxes
          ),
          itemCount: filterSubCategoryItems.length,
          itemBuilder: (context, index) {
            final item = filterSubCategoryItems[index];

            return Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  setState(() {});
                  final name = item["title"];
                  final id = item["cat_id"];

                  // guard against missing id
                  if (id == null) {
                    print("Missing category id for item: $item");
                    return;
                  }

                  print(
                      "Tapped:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $name (id: $id)");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesScreen(
                        a: widget
                            .analytics, // ensure this isn't null or handle inside SubCategoriesScreen
                        o: widget
                            .observer, // ensure this isn't null or handle inside SubCategoriesScreen
                        showCategories: true,
                        screenHeading: name,
                        categoryId: id,
                        isEventProducts: false,
                        isSubcategory: false,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: ColorConstants.colorPageBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: ColorConstants.newAppColor.withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item["title"] ?? item["event_name"] ?? "",
                          style: const TextStyle(
                            color: ColorConstants.newAppColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 34,
                        height: 34,
                        child: Image.network(
                          "${global.catImageBaseUrl}${item["image"] ?? item["event_image"] ?? ""}",
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // --- Flowers & Plants screen (now GridView with crossAxisCount: 2) ---
  Widget _buildFlowersPlantsScreen() {
    final List<_SubCategoryItem> plantsList = [
      _SubCategoryItem(title: "Garden Fresh", icon: "assets/images/plant1.png"),
      _SubCategoryItem(
          title: "Luxury Blooms", icon: "assets/images/plant2.png"),
      _SubCategoryItem(
          title: "Sweet Moments", icon: "assets/images/chocolate.png"),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Flowers & Plants",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: ColorConstants.newAppColor,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: ColorConstants.newAppColor,
              onPressed: () {
                setState(() {
                  filterSubCategoryScreen = false;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Divider(height: 0.5, color: ColorConstants.greyfaint),
        const SizedBox(height: 20),

        // Grid with 2 columns
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.6, // wide pill-like boxes
          ),
          itemCount: plantsList.length,
          itemBuilder: (context, index) {
            final item = plantsList[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: ColorConstants.colorPageBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: ColorConstants.newAppColor.withOpacity(0.15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        color: ColorConstants.newAppColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 34,
                    height: 34,
                    child: Image.asset(
                      item.icon,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 18),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = MediaQuery.of(context).size.width * 1;

    return SafeArea(
      child: Container(
        width: drawerWidth,
        color: ColorConstants.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.newAppColor,
                  ),
                ),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   color: ColorConstants.newAppColor,
//                  onPressed: () async {
//   final api = ApiHelper();
//   await api.oneAPIfirst();

//   // after API call you can close drawer if needed:
//   // widget.onClose?.call();
//   // Navigator.of(context).pop();
// },
//                       // widget.onClose ?? () => Navigator.of(context).pop(),
//                 ),

                IconButton(
                  icon: const Icon(Icons.close),
                  color: ColorConstants.newAppColor,
                  onPressed: () async {
                    // final api = APIHelper();
                    // await api.oneAPIfirst();

                    // Close drawer if needed
                    widget.onClose?.call();
                    or:
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),

            const SizedBox(height: 10),
            Divider(height: 0.5, color: ColorConstants.greyfaint),
            const SizedBox(height: 20),

            // SEARCH BOX
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFE7DCDC)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _handleSearchSubmitted,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Search for flowers, cakes, gifts and more',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                      ),
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {},
                      onEditingComplete: () {
                        // use the current text from controller
                        final query = _searchController.text.trim();
                        Navigator.of(context).push(
                          NavigationUtils.createAnimatedRoute(
                            1.0,
                            SearchResultsScreen(
                                a: widget.analytics,
                                o: widget.observer,
                                searchParams: query,
                                searchScreen: "search",
                                subCatName: " ",
                                subCatID: " "),
                          ),
                        );
                      },
                    ),
                  ),

                  // search button on the right
                  IconButton(
                    icon: const Icon(Icons.search),
                    color: ColorConstants.newAppColor,
                    onPressed: () =>
                        _handleSearchSubmitted(_searchController.text),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // MAIN CONTENT AREA
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // show only one of these screens at a time
                    if (categoriesScreen)
                      _buildCategoryDetailScreen(drawerWidth)
                    else if (filterSubCategoryScreen)
                      _filterSubCategoryScreen()
                    else if (filterCategoryScreen)
                      _buildFlowersPlantsScreen()
                    else ...[
                      // CATEGORIES GRID (original)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          return GestureDetector(
                            onTap: () {
                              // If Celebrate category (index 0)
                              if (index == 0) {
                                oneAPIFirst();
                                setState(() {
                                  categoriesScreen = true;
                                  selectedCategoryIndex = index;
                                });
                                return;
                              }

                              // If Recipients category (index 1)
                              if (index == 1) {
                                setState(() {
                                  categoriesScreen = true;
                                  selectedCategoryIndex = index;
                                });
                                return;
                              }

                              // If Express Delivery (index 2) → Navigate
                              if (index == 2) {
                                global.isSubCatSelected = true;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubCategoriesScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                      showCategories: true,
                                      screenHeading: "Express",
                                      categoryId: null,
                                      isEventProducts: true,
                                      isSubcategory: false,
                                      // minAge: _minAge,
                                      // maxAge: _maxAge,
                                      // recipientId: null,
                                    ),
                                  ),
                                );

                                return;
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(100),
                                      topRight: Radius.circular(100),
                                    ),
                                    child: Image.asset(
                                      cat.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                            Icons.image_not_supported),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: 130,
                                  child: Text(
                                    cat.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.9,
                        ),
                        itemCount: filterCategoryItems.length,
                        itemBuilder: (context, index) {
                          final item = filterCategoryItems[index];

                          return GestureDetector(
                            onTap: () {
                              filterSubCategoryScreen = true;
                              // Save the selected categoryList into subcategory list
                              filterSubCategoryItems =
                                  List.from(item["categoryList"] ?? []);

                              print(
                                  "Selected Subcategories = ${filterSubCategoryItems.length}");
                              print(
                                  "Selected Subcategories = ${filterSubCategoryItems.toList()}");

                              SelectedSubCategoryName = item["name"] ?? "";

                              setState(() {});

                              // add your navigation here
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: ColorConstants.colorPageBackground,
                                border: Border.all(
                                    color: ColorConstants.newAppColor,
                                    width: 0.3),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  // Left: Title
                                  Expanded(
                                    child: Text(
                                      item["name"] ?? "",
                                      style: const TextStyle(
                                        color: ColorConstants.newAppColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // Right: Image
                                  SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        "${global.catImageBaseUrl}${item["image"]}",
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image,
                                                    size: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 25),

                      // BOTTOM PROMO CARDS
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 75,
                              child: PromoSmallCard(
                                title: 'CORPORATE GIFTS',
                                imageUrl: "assets/images/C1.webp",
                                onTap: () async {
                                  const url =
                                      "https://esganalytix.com/coming-soon";

                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url),
                                        mode: LaunchMode.externalApplication);
                                  } else {
                                    print("Could not launch the URL");
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 75,
                              child: PromoSmallCard(
                                title: 'ADD AS REMINDER',
                                imageUrl: "assets/images/C2.webp",
                                onTap: () {
                                  global.currentUser != null &&
                                          global.stayLoggedIN! &&
                                          global.currentUser.id != null
                                      ? Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserMemberListScreen(
                                              a: widget.analytics,
                                              o: widget.observer,
                                            ),
                                          ),
                                        )
                                      : Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(
                                              a: widget.analytics,
                                              o: widget.observer,
                                            ),
                                          ),
                                        );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  oneAPIFirst() async {
    showOnlyLoaderDialog();
    try {
      await apiHelper
          .oneAPIfirst(
        global.currentUser.id == null ? " " : global.currentUser.id,
      )
          .then(
        (result) async {
          if (result["status"] == "1") {
            final list = result["data"] is List
                ? result["data"]
                : result["data"]["events"] ?? [];

            celebrateEvents = List.from(list);
            print("Total events: ${celebrateEvents.length}");

            setState(() {});

            hideLoader();
          } else {
            hideLoader();
            oneAPIFirst();
          }
        },
      );
    } catch (e) {
      print("one API FIRST ERRRRORRRRRRRR$e");
      hideLoader();
    }
  }

  Future<void> filltercatgory() async {
    showOnlyLoaderDialog();
    try {
      final result = await apiHelper.filltercatgory(
        global.currentUser?.id ?? "",
      );

      // Make sure result is parsed as Map
      if (result is Map && result["status"] == "1") {
        // result["data"] should be a List (top-level categories)
        final dataList =
            result["data"] is List ? List.from(result["data"]) : [];

        // Use the variable you actually want to show in UI:
        filterCategoryItems = List.from(dataList);
        // If you also need celebrateEvents for other code, set it intentionally:

        print("Total categories: ${filterCategoryItems.length}");
        print("API FILTER CATEGORY SUCCESS >>> $result");

        setState(() {}); // update UI
      } else {
        print("API FILTER CATEGORY FAILED >>> $result");
        // don't recursively call filltercatgory() — consider retry policy if needed
      }
    } catch (e, st) {
      print("one API FIRST ERROR: $e");
      print(st);
    } finally {
      hideLoader();
    }
  }

  Future<void> fetchFilterCategories() async {
    showOnlyLoaderDialog();
    try {
      final result = await apiHelper.searchfilters();

      if (result is Map && result["status"] == "1") {
        final data = result["data"] ?? {};

        // Extract only search_relationship safely
        recipientsList = data["search_relationship"] is List
            ? List.from(data["search_relationship"])
            : [];
        print(
            "AAAAAAAAAA>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>BBBBBBBBBBBB");
        print(recipientsList);

        setState(() {});
      } else {
        print("API SEARCH FILTER FAILED >>> $result");
      }
    } catch (e, st) {
      print("fetchFilterCategories error: $e");
      print(st);
    } finally {
      hideLoader();
    }
  }

  void showOnlyLoaderDialog() {}

  void hideLoader() {}
}

class _CategoryItem {
  final String title;
  final String imageUrl;
  _CategoryItem({required this.title, required this.imageUrl});
}

class _ChipItem {
  final String title;
  final String iconUrl;
  _ChipItem({required this.title, required this.iconUrl});
}

class _SubCategoryItem {
  final String title;
  final String icon;
  _SubCategoryItem({required this.title, required this.icon});
}

/// MINI CARD AT BOTTOM
class PromoSmallCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  const PromoSmallCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onTap,
  });

  get apiHelper => null;

  @override
  Widget build(BuildContext context) {
    final bool isAsset = !imageUrl.startsWith('http');
    final DecorationImage decorationImage = DecorationImage(
      image: isAsset
          ? AssetImage(imageUrl)
          : NetworkImage(imageUrl) as ImageProvider,
      fit: BoxFit.cover,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          image: decorationImage,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(14)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.45)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: fontRalewayMedium,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // oneAPIFirst() async {
  //   showOnlyLoaderDialog();
  //   try {
  //     await apiHelper
  //         .oneAPIfirst(
  //       global.currentUser.id == null ? " " : global.currentUser.id,
  //     )
  //         .then(
  //       (result) async {
  //         if (result.status == "1") {
  //           print(result.data);

  //           hideLoader();
  //         } else {
  //           hideLoader();
  //           oneAPIFirst();
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     print("one API FIRST ERRRRORRRRRRRR");
  //     hideLoader();
  //   }
  // }

  // void showOnlyLoaderDialog() {}

  // void hideLoader() {}
}
