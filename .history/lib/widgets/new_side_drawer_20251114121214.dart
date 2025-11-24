import 'package:byyu/constants/color_constants.dart';
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
    _CategoryItem(
        title: 'Celebrate',
        imageUrl: 'https://picsum.photos/seed/celebrate/400'),
    _CategoryItem(
        title: 'Recipients',
        imageUrl: 'https://picsum.photos/seed/recipients/400'),
    _CategoryItem(
        title: 'Express Delivery',
        imageUrl: 'https://picsum.photos/seed/express/400'),
  ];

  final List<_ChipItem> _chips = [
    _ChipItem(
        title: 'Flowers & Gifts',
        iconUrl: 'https://picsum.photos/seed/gift/80'),
    _ChipItem(
        title: 'Flowers & Plants',
        iconUrl: 'https://picsum.photos/seed/plants/80'),
  ];

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
        color: ColorConstants.colorPageBackground,
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
                                  child: Image.network(
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
                              color: Colors.white,
                              border:
                                  Border.all(color: const Color(0xFFEEDFD9)),
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

                    const SizedBox(height: 18),

                    // Promo/cards grid (two cards)
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 75,
                            child: _PromoCard(
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
                            child: _PromoCard(
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

class _PromoCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  const _PromoCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 5 / 1.8,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(
                    blurRadius: 6, color: Colors.black45, offset: Offset(0, 2))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
