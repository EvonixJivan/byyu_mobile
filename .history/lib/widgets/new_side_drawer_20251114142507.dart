import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
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
  final TextEditingController _searchController = TextEditingController();

  final List<_CategoryItem> _categories = [
    _CategoryItem(title: 'Celebrate', imageUrl: "assets/images/N1.png"),
    _CategoryItem(title: 'Recipients', imageUrl: "assets/images/N2.png"),
    _CategoryItem(title: 'Express Delivery', imageUrl: "assets/images/N3.png"),
  ];

  // final List<_ChipItem> _chips = [
  //   _ChipItem(title: 'Flowers & Gifts', iconUrl: "assets/images/N3.png"),
  //   _ChipItem(title: 'Flowers & Plants', iconUrl: "assets/images/N2.png"),
  // ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchSubmitted(String text) {
    widget.onSearch?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = MediaQuery.of(context).size.width * 0.85;

    return SafeArea(
      child: Container(
        width: drawerWidth,
        color: ColorConstants.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            /// HEADER
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
                IconButton(
                  icon: const Icon(Icons.close),
                  color: ColorConstants.newAppColor,
                  onPressed:
                      widget.onClose ?? () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Divider(height: 0.5, color: ColorConstants.greyfaint),
            const SizedBox(height: 20),

            /// SEARCH BOX
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
                        hintText: 'Search for flowers, cakes, gifts and more',
                        border: InputBorder.none,
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

            const SizedBox(height: 18),

            /// MAIN CONTENT SCROLL AREA
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// CATEGORIES GRID
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        return GestureDetector(
                          onTap: () => widget.onCategoryTap?.call(index),
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
                                  borderRadius: BorderRadius.only(
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
                                      child:
                                          const Icon(Icons.image_not_supported),
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

                    const SizedBox(height: 25),

                    /// CHIPS — using Wrap (NO OVERFLOW)
                    // Wrap(
                    //   spacing: 12,
                    //   runSpacing: 12,
                    //   children: _chips.map((chip) {
                    //     return SizedBox(
                    //       width: (drawerWidth - 48) / 2,
                    //       child: GestureDetector(
                    //         onTap: () =>
                    //             widget.onChipTap?.call(_chips.indexOf(chip)),
                    //         child: Container(
                    //           padding: const EdgeInsets.symmetric(
                    //               horizontal: 12, vertical: 10),
                    //           decoration: BoxDecoration(
                    //             color: ColorConstants.colorPageBackground,
                    //             border: Border.all(
                    //                 color: ColorConstants.newAppColor,
                    //                 width: 0.3),
                    //             borderRadius: BorderRadius.circular(14),
                    //           ),
                    //           child: Row(
                    //             children: [
                    //               Expanded(
                    //                 child: Text(
                    //                   chip.title,
                    //                   style: const TextStyle(
                    //                     color: ColorConstants.newAppColor,
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.w500,
                    //                   ),
                    //                   maxLines: 2,
                    //                   overflow: TextOverflow.ellipsis,
                    //                 ),
                    //               ),
                    //               const SizedBox(width: 8),
                    //               SizedBox(
                    //                 width: 28,
                    //                 height: 28,
                    //                 child: ClipRRect(
                    //                   borderRadius: BorderRadius.circular(6),
                    //                   child: Image.asset(
                    //                     chip.iconUrl,
                    //                     fit: BoxFit.cover,
                    //                     errorBuilder:
                    //                         (context, error, stackTrace) =>
                    //                             const Icon(Icons.broken_image,
                    //                                 size: 18),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),

                    const SizedBox(height: 25),

                    /// BOTTOM PROMO CARDS
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: SizedBox(
                    //         height: 75,
                    //         child: PromoSmallCard(
                    //           title: 'CORPORATE GIFTS',
                    //           imageUrl: "assets/images/C1.png", // asset image
                    //           onTap: () {},
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 12),
                    //     Expanded(
                    //       child: SizedBox(
                    //         height: 75,
                    //         child: PromoSmallCard(
                    //           title: 'ADD AS REMINDER',
                    //           imageUrl:
                    //               'https://picsum.photos/seed/reminder/900/300',
                    //           onTap: () {},
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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

  bool get isAsset => !imageUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.45),
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
}
