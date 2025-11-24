import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/cartModel.dart';
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

  final List<_ChipItem> _chips = [
    _ChipItem(title: 'Flowers & Gifts', iconUrl: "assets/Images/F1.png"),
    _ChipItem(title: 'Flowers & Plants', iconUrl: "assets/Images/F2.png"),
  ];

  static get assets => null;

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
    final double drawerHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        width: drawerWidth,
        height: drawerHeight,
        color: ColorConstants.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header (fixed)
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
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 0.5,
              color: ColorConstants.greyfaint,
            ),
            const SizedBox(height: 20),

            // Search (fixed) - no underline / no divider line
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

            // Only below content scrolls
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Grid of categories
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.05,
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];

                        return GestureDetector(
                          onTap: () => widget.onCategoryTap?.call(index),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Bigger Image Area (rounded top corners)
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(120),
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
                                    topLeft: Radius.circular(120),
                                    topRight: Radius.circular(120),
                                  ),
                                  child: Image.asset(
                                    cat.imageUrl,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 120,
                                      height: 120,
                                      color: Colors.grey[200],
                                      child:
                                          const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Title (wider)
                              SizedBox(
                                width: 130,
                                child: Text(
                                  cat.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    // Chips row
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // ← 2 chips in horizontal row
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.8, // controls chip width vs height
                      ),
                      itemCount: _chips.length,
                      itemBuilder: (context, index) {
                        final chip = _chips[index];

                        return GestureDetector(
                          onTap: () => widget.onChipTap?.call(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: ColorConstants.colorPageBackground,
                              border: Border.all(
                                  color: ColorConstants.newAppColor,
                                  width: 0.3),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0F000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                )
                              ],
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
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    chip.iconUrl,
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    // Promo/cards grid (two cards)
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 75,
                            child: PromoSmallCard(
                              title: 'CORPORATE GIFTS',
                              imageUrl:
                                  'https://picsum.photos/seed/corp/900/300',
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
                              imageUrl:
                                  'https://picsum.photos/seed/reminder/900/300',
                              onTap: () {},
                            ),
                          ),
                        ),
                      ],
                    ),

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),

        // bottom-center text
        child: Stack(
          children: [
            // bottom gradient overlay for better text visibility
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.45),
                    ],
                  ),
                ),
              ),
            ),

            // text
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  title,
                  style: const TextStyle(
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
