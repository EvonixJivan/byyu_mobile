import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart' as apiHelper;
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/eventsListModel.dart';
import 'package:byyu/screens/auth/add_member.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class NewSideDrawer extends StatefulWidget {
  final VoidCallback? onClose;
  final ValueChanged<String>? onSearch;
  final ValueChanged<int>? onCategoryTap;
  final ValueChanged<int>? onChipTap;

  const NewSideDrawer({
    Key? key,
    this.onClose,
    this.onSearch,
    this.onCategoryTap,
    this.onChipTap,
    FirebaseAnalytics? analytics,
    FirebaseAnalyticsObserver? observer,
  }) : super(key: key);

  @override
  State<NewSideDrawer> createState() => _NewSideDrawerState();
}

class _NewSideDrawerState extends State<NewSideDrawer> {
  // main state flags
  bool categoriesScreen = false;
  bool flowersGiftsScreen = false;
  bool flowersPlantsScreen = false;
  double _ageSliderValue = 40.0;

  int selectedCategoryIndex = 0;

  final TextEditingController _searchController = TextEditingController();

//Celebrate section data from API
  List<Map<String, dynamic>> celebrateEvents = [];
  bool isLoadingCelebrate = false;
  String? celebrateError;

  final List<_CategoryItem> _categories = [
    _CategoryItem(title: 'Celebrate', imageUrl: "assets/images/N1.png"),
    _CategoryItem(title: 'Recipients', imageUrl: "assets/images/N2.png"),
    _CategoryItem(title: 'Express Delivery', imageUrl: "assets/images/N3.png"),
  ];

  final List<_ChipItem> _chips = [
    _ChipItem(title: 'Flowers & Gifts', iconUrl: "assets/images/F1.png"),
    _ChipItem(title: 'Flowers & Plants', iconUrl: "assets/images/F2.png"),
  ];

  // sample sub-items for category detail screens (replace icons/titles with your assets)
  final Map<String, List<_SubCategoryItem>> categorySubMap = {
    'Celebrate': [
      _SubCategoryItem(
          title: 'National Day', icon: 'assets/images/I_national.png'),
      _SubCategoryItem(title: 'Birthday', icon: 'assets/images/I_birthday.png'),
      _SubCategoryItem(
          title: 'Anniversary', icon: 'assets/images/I_anniversary.png'),
      _SubCategoryItem(
          title: 'Gift For Her', icon: 'assets/images/I_gift_her.png'),
      _SubCategoryItem(
          title: 'Gift For Him', icon: 'assets/images/I_gift_him.png'),
      _SubCategoryItem(
          title: 'Personalised', icon: 'assets/images/I_personalised.png'),
      _SubCategoryItem(
          title: 'Graduation Day', icon: 'assets/images/I_graduation.png'),
    ],
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
    // oneAPIfirst();
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
                  categoriesScreen = false;
                });
              },
            ),
          ],
        ),

        const SizedBox(height: 10),
        Divider(height: 0.5, color: ColorConstants.greyfaint),

        if (selectedCategoryIndex == 1) ...[
          const SizedBox(height: 25),

          // Label row: show current age value and mapped percent (0-100)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // 'Age: ${_ageSliderValue.round()} yrs',
                "Age",
                style: const TextStyle(
                  color: ColorConstants.newAppColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                height: 5,
                width: 240,
                child: Slider(
                  activeColor: ColorConstants.newAppColor,
                  value: _ageSliderValue, // <-- Use your state variable
                  min: 0.0,
                  max: 70.0,
                  divisions: 70,
                  label: '${_ageSliderValue.round()}', // label updates live
                  onChanged: (double value) {
                    setState(() {
                      _ageSliderValue = value; // <-- Update variable on slide
                    });

                    // print("Selected age: $_ageSliderValue");
                    // print("Age as int: ${_ageSliderValue.round()}");
                    // print(
                    //     "Age as string: ${_ageSliderValue.round().toString()}");
                  },
                ),
              ),
              Text(
                // 'Selected: ${_sliderPercent(_ageSliderValue)}%',
                'Selected: 0- ${_ageSliderValue.round().toString()} yrs',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.newAppColor,
                ),
              ),
            ],
          ),

          // Slider itself: range 0 - 70

          const SizedBox(height: 8),
        ],

        const SizedBox(height: 20),

        // Grid like the screenshot (3 columns)
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: celebrateEvents.length,
            itemBuilder: (context, index) {
              final item = _currentSubList[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      item.icon,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.transparent,
                        child: const Icon(Icons.image_not_supported, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // --- Flowers & Gifts screen (now GridView with crossAxisCount: 2) ---
  Widget _buildFlowersGiftsScreen() {
    final List<_SubCategoryItem> giftsList = [
      _SubCategoryItem(
          title: "Baked with Love", icon: "assets/images/dryfruits.png"),
      _SubCategoryItem(
          title: "Luxury Blooms", icon: "assets/images/flowers.png"),
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
              "Flowers & Gifts",
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
                  flowersGiftsScreen = false;
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
          itemCount: giftsList.length,
          itemBuilder: (context, index) {
            final item = giftsList[index];
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
                  flowersPlantsScreen = false;
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
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    color: ColorConstants.newAppColor,
                    onPressed: () =>
                        _handleSearchSubmitted(_searchController.text),
                  )
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
                    else if (flowersGiftsScreen)
                      _buildFlowersGiftsScreen()
                    else if (flowersPlantsScreen)
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
                              setState(() {
                                // print("111111111>>>>>>>>>>>>>>>>>>");
                                if (index == 0) {
                                  oneAPIFirst();
                                }
                                categoriesScreen = true;
                                selectedCategoryIndex = index;
                                // optionally notify parent:
                                // widget.onCategoryTap?.call(index);
                              });
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

                      // CHIPS — open specialized screens when tapped
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: List.generate(_chips.length, (index) {
                          final chip = _chips[index];
                          return SizedBox(
                            width: (drawerWidth - 48) / 2,
                            child: GestureDetector(
                              onTap: () {
                                // index 0 -> Flowers & Gifts
                                // index 1 -> Flowers & Plants
                                setState(() {
                                  if (index == 0) {
                                    flowersGiftsScreen = true;
                                    flowersPlantsScreen = false;
                                    categoriesScreen = false;
                                  } else if (index == 1) {
                                    flowersPlantsScreen = true;
                                    flowersGiftsScreen = false;
                                    categoriesScreen = false;
                                  }
                                });
                                // optionally notify parent
                                // widget.onChipTap?.call(index);
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
                                    Expanded(
                                      child: Text(
                                        chip.title,
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
                                    SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.asset(
                                          chip.iconUrl,
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
                            ),
                          );
                        }),
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
                                onTap: () {},
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
                                // onTap: () {
                                //   Navigator.of(context).push(
                                //     MaterialPageRoute(
                                //       builder: (_) => AddMemberScreen(
                                //           // optional: pass data to the new screen if it accepts arguments
                                //           // title: item.title,
                                //           ),
                                //     ),
                                //   );
                                // },
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
          if (result.status == "1") {
            print(result.data);

            hideLoader();
          } else {
            hideLoader();
            oneAPIFirst();
          }
        },
      );
    } catch (e) {
      print("one API FIRST ERRRRORRRRRRRR");
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
